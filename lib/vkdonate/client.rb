# frozen_string_literal: true

module Vkdonate
  # Client which saves API key
  class Client
    # New client to work with API
    # @param api_key [String]
    def initialize(api_key)
      @api_key = api_key.to_s
      raise 'API key can not be empty' if @api_key.empty?
    end

    # @see VkDonate.request
    def request(action, **options)
      Vkdonate.request(@api_key, action, **options)
    end

    # @see VkDonate.donates
    def donates(**options)
      Vkdonate.donates(@api_key, **options)
    end
  end
end
