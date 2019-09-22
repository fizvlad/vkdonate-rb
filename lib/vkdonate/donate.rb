module Vkdonate

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

end
