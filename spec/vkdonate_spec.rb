# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Vkdonate, :vcr do
  describe 'VERSION' do
    let(:result) { Vkdonate::VERSION }

    it { expect(result).to be_a(String) }
  end

  describe '.request' do
    let(:result) { Vkdonate.request(api_key, action, **options) }
    let(:action) { :donates }
    let(:options) { { count: 5, offset: 0, sort: :date, order: :desc } }

    it :aggregate_failures do
      expect(result).to be_a(Array)
      expect(result.size).to eq(5)
      expect { result.first.date > result.last.date }
    end

    context 'when ascending date' do
      let(:options) { { count: 5, offset: 0, sort: :date, order: :asc } }

      it :aggregate_failures do
        expect(result).to be_a(Array)
        expect(result).to all(be_a(Vkdonate::Donate))
        expect(result.size).to eq(5)
        expect { result.first.date < result.last.date }
      end
    end

    context 'when wrong action' do
      let(:action) { 'unknown' }

      it { expect { result }.to raise_error(RuntimeError) }
    end

    context 'when wrong sort' do
      let(:options) { { count: 5, offset: 0, sort: :a, order: :asc } }

      it { expect { result }.to raise_error(RuntimeError) }
    end

    context 'when wrong order' do
      let(:options) { { count: 5, offset: 0, sort: :date, order: :a } }

      it { expect { result }.to raise_error(RuntimeError) }
    end

    context 'when wrong api key' do
      let(:api_key) { 'aaa' }

      it { expect { result }.to raise_error(RuntimeError) }
    end
  end

  describe '.donates' do
    let(:call) { Vkdonate.donates(api_key_stub, **options_stub) }
    let(:api_key_stub) { 'stub' }
    let(:options_stub) { { count: 1 } }

    it do
      expect(Vkdonate).to receive(:request).with(api_key_stub, :donates, **options_stub)
      call
    end

    context 'when no options' do
      let(:call) { Vkdonate.donates(api_key_stub) }

      it do
        expect(Vkdonate).to receive(:request).with(api_key_stub, :donates)
        call
      end
    end
  end
end
