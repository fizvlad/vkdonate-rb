require "vkdonate/version"

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
  # Single donation
  class Donate

    ##
    # @return [Integer] Unique payment ID.
    attr_reader :id

    ##
    # @return [Integer] Donator VK ID.
    attr_reader :uid

    ##
    # @return [DateTime] Date and time of donation.
    attr_reader :date

    ##
    # @return [Integer] Size of donation.
    attr_reader :sum

    ##
    # @return [String, nil] User message or +nil+ if empty.
    attr_reader :msg
    alias_method :message, :msg

    ##
    # @return [Boolean] Whether donation is anonymous.
    attr_reader :anon
    alias_method :anon?, :anon

    ##
    # @return [Boolean] Whether donate is visible in group.
    attr_reader :visible
    alias_method :visible?, :visible

    ##
    # @return [String] Human readable information.
    def to_s
      "Donation ##{id} by @#{uid} for #{sum}RUR (at #{date})"
    end

    ##
    # Save data about donation.
    #
    # @param options [Hash]
    #
    # @option options [Integer] id
    # @option options [Integer] uid
    # @option options [DateTime] date
    # @option options [Integer] sum
    # @option options [String, nil] msg
    # @option options [Boolean] anon
    # @option options [Boolean] visible
    def initialize(options)
      @id = options[:id].to_i

      @uid = options[:uid].to_i

      @date = options[:date]
      raise unless DateTime === @date

      @sum = options[:sum].to_i

      @msg = options[:msg].to_s
      @msg = nil if @msg.empty?

      @anon = !!options[:anon]

      @visible = !!options[:visible]
    end

    ##
    # Parse from JSON hash.
    #
    # @param hash [Hash] parsed JSON hash.
    #
    # @return [Donate]
    def self.from_json(hash)
      self.new(
        id: hash["id"].to_i,
        uid: hash["uid"].to_i,
        date: DateTime.parse(hash["date"] + " #{TIME_OFFSET}"),
        sum: hash["sum"].to_i,
        msg: hash["msg"].empty? ? nil : hash["msg"],
        anon: !hash["anon"].to_i.zero?,
        visible: !hash["visible"].to_i.zero?
      )
    end

  end

  ##
  # Client which saves API key.
  class Client

    ##
    # New client to work with API.
    #
    # @param api_key [String]
    def initialize(api_key)
      @api_key = api_key
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
