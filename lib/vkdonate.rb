# frozen_string_literal: true

require 'net/http'
require 'json'
require 'date'

require 'vkdonate/client'
require 'vkdonate/donate'

# Main module
module Vkdonate
  # Gem version
  VERSION = '1.0.2'
  public_constant :VERSION

  # URI for requests
  REQUEST_URI = URI('https://api.vkdonate.ru')
  private_constant :REQUEST_URI

  # Array of available actions
  ACTIONS = %i[donates].freeze
  private_constant :ACTIONS

  # Array of available sort-by
  SORT = %i[date sum].freeze
  private_constant :SORT

  # Array of available order-by
  ORDER = %i[asc desc].freeze
  private_constant :ORDER

  # Time offset of API server
  TIME_OFFSET = 'UTC+3'
  private_constant :TIME_OFFSET

  # Requests timeout in seconds
  REQUEST_TIMEOUT = 10
  private_constant :REQUEST_TIMEOUT

  # @!macro [new] request_option
  #    @param count [Integer] amount of donates (up to 50)
  #    @param offset [Integer] donates offset
  #    @param sort [Symbol] sort by
  #    @param order [Symbol] order by
  #    @see Vkdonate::SORT
  #    @see Vkdonate::ORDER

  class << self
    # Simple POST request to API
    # @param api_key [String]
    # @param action [Symbol]
    # @!macro request_option
    # @see Vkdonate::ACTIONS
    # @return [Array]
    def request(api_key, action, count: 10, offset: 0, sort: :date, order: :desc)
      validate_request_options(action, count, offset, sort, order)

      res = Net::HTTP.post_form(REQUEST_URI, key: api_key, action: action.to_s, count: count,
                                             offset: offset, sort: sort.to_s, order: order.to_s)

      json = JSON.parse res.body

      raise json['text'] unless json['success']

      json['donates'].map { |e| Donate.from_json(e) }
    end

    # POST request for +donates+ action
    # @param api_key [String]
    # @!macro request_option
    # @see Vkdonate.request
    # @return [Array]
    def donates(api_key, **options)
      request(api_key, :donates, **options)
    end

    private

    def validate_request_options(action, count, offset, sort, order)
      raise 'Unknown action' unless ACTIONS.include? action
      raise 'Count is out of range' unless count >= 1 && count <= 50
      raise 'Offset is out of range' unless offset >= 0
      raise 'Unknown sorting' unless SORT.include? sort
      raise 'Unknown ordering' unless ORDER.include? order
    end
  end
end
