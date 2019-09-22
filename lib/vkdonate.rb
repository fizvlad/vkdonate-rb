require "vkdonate/version"
require "vkdonate/donate"

require "net/http"
require "json"
require "date"

##
# Main module.
module Vkdonate

  ##
  # URI for requests.
  REQUEST_URI = URI("https://api.vkdonate.ru")

  ##
  # Array of available actions.
  ACTIONS = [:donates]

  ##
  # Array of available sort-by.
  SORT = [:date, :sum]

  ##
  # Array of available order-by.
  ORDER = [:asc, :desc]

  ##
  # Time offset of API server.
  TIME_OFFSET = "UTC+3"

  ##
  # Requests timeout in seconds
  REQUEST_TIMEOUT = 10

  ##
  # @!macro [new] request_option
  #    @option options [Integer] count (10) amount of donates (up to 50).
  #    @option options [Integer] offset (0) donates offset.
  #    @option options [Symbol] sort (:date) sort by.
  #    @option options [Symbol] order (:desc) order by.
  #    @see Vkdonate::SORT
  #    @see Vkdonate::ORDER
  #
  # @!macro [new] request_return
  #    @return [Array]
  #
  # @!macro [new] request
  #    Simple POST request to API.
  #    @param action [Symbol]
  #    @param options [Hash]
  #    @!macro request_option
  #    @see Vkdonate::ACTIONS
  #    @!macro request_return
  #
  # @!macro [new] donates
  #    POST request for +donates+ action.
  #    @param options [Hash]
  #    @!macro request_option
  #    @see Vkdonate::ACTIONS
  #    @!macro request_return

  ##
  # @param api_key [String]
  # @!macro request
  def self.request(api_key, action, options = {})
    raise "Unknown action" unless ACTIONS.include? action

    count = options[:count] || 10
    offset = options[:offset] || 0
    sort = options[:sort] || :date
    order = options[:order] || :desc

    raise "Count is out of range" unless count >= 1 && count <= 50
    raise "Offset is out of range" unless offset >= 0
    raise "Unknown sorting" unless SORT.include? sort
    raise "Unknown ordering" unless ORDER.include? order

    res = Net::HTTP.post_form(REQUEST_URI,
      key: api_key.to_s,
      action: action.to_s,
      count: count.to_i,
      offset: offset.to_i,
      sort: sort.to_s,
      order: order.to_s
    )

    json = JSON.parse res.body

    if json["success"]
      json["donates"].map { |e| Donate.from_json(e) }
    else
      raise json["text"]
    end
  end

  ##
  # @param api_key [String]
  # @!macro donates
  def self.donates(api_key, options = {})
    request(api_key, :donates, options)
  end

  ##
  # Client which saves API key.
  class Client

    ##
    # New client to work with API.
    #
    # @param api_key [String]
    def initialize(api_key)
      @api_key = api_key.to_s
      raise "API key can not be empty" if @api_key.empty?
    end

    ##
    # @!macro request
    def request(action, options = {})
      Vkdonate.request(@api_key, action, options)
    end

    ##
    # @!macro donates
    def donates(options = {})
      Vkdonate.donates(@api_key, options)
    end

  end

end
