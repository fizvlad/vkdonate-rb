# frozen_string_literal: true

module Vkdonate
  # Single donation
  class Donate
    # @return [Integer] Unique payment ID
    attr_reader :id

    # @return [Integer] Donator VK ID
    attr_reader :uid

    # @return [DateTime] Date and time of donation
    attr_reader :date

    # @return [Integer] Size of donation
    attr_reader :sum

    # @return [String] User message or +nil+ if empty
    attr_reader :msg
    alias message msg

    # @return [Boolean] Whether donation is anonymous
    attr_reader :anon
    alias anon? anon

    # @return [Boolean] Whether donate is visible in group
    attr_reader :visible
    alias visible? visible

    # Save data about donation.
    # @param options [Hash]
    # @option options [Integer] id
    # @option options [Integer] uid
    # @option options [DateTime] date
    # @option options [Integer] sum
    # @option options [String] msg
    # @option options [Boolean] anon
    # @option options [Boolean] visible
    def initialize(id:, uid:, date:, sum:, msg:, anon:, visible:)
      @id = id
      @uid = uid
      @date = date
      @sum = sum
      @msg = msg
      @anon = anon
      @visible = visible
    end

    # Parse from JSON hash.
    # @param hash [Hash] parsed JSON hash.
    # @return [Donate]
    def self.from_json(hash)
      new(
        id: hash['id'],
        uid: hash['uid'],
        date: DateTime.parse(hash['date'] + " #{TIME_OFFSET}"),
        sum: hash['sum'],
        msg: hash['msg'].to_s,
        anon: Integer(hash['anon'].to_s, 10) != 0,
        visible: Integer(hash['visible'].to_s, 10) != 0
      )
    end

    # @return [String] Human readable information
    def to_s
      "Donation ##{id} by @#{uid} for #{sum}RUR (at #{date})"
    end
  end
end
