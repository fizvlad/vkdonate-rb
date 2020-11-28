# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Vkdonate::Client do
  let(:client) { described_class.new(api_key_stub) }
  let(:api_key_stub) { 'stub' }

  describe '#request' do
    let(:call) { client.request(action_stub, **options_stub) }
    let(:action_stub) { 'stub' }
    let(:options_stub) { {} }

    it do
      expect(Vkdonate).to receive(:request).with(api_key_stub, action_stub, **options_stub)
      call
    end
  end

  describe '#donates' do
    let(:call) { client.donates(**options_stub) }
    let(:options_stub) { {} }

    it do
      expect(Vkdonate).to receive(:donates).with(api_key_stub, **options_stub)
      call
    end
  end
end
