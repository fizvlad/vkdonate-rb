# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Vkdonate::Donate do
  describe '.from_json' do
    let(:hash) do
      {
        'id' => 1, 'uid' => 2, 'sum' => 3, 'msg' => 'msg', 'date' => '2020-09-08 23:01:09',
        'ts' => 1599595269, 'anon' => 0, 'visible' => 1
      }
    end
    let(:result) { described_class.from_json(hash) }

    it :aggregate_failures do
      expect(result).to be_a(described_class)
      expect(result.id).to eq(1)
      expect(result.uid).to eq(2)
      expect(result.sum).to eq(3)
      expect(result.msg).to eq('msg')
      expect(result.date).to eq(DateTime.new(2020, 9, 8, 23, 1, 9, '+3'))
      expect(result.anon).to be(false)
      expect(result.visible).to be(true)
    end
  end

  describe '#to_s' do
    let(:donate) do
      described_class.new(id: 1, uid: 2, date: DateTime.new(2020, 9, 8, 23, 1, 9, '+3'), sum: 3,
                          msg: 'msg', anon: true, visible: false)
    end
    let(:result) { donate.to_s }

    it { expect(result).to eq('Donation #1 by @2 for 3RUR (at 2020-09-08T23:01:09+03:00)') }
  end
end
