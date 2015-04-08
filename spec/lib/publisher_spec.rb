require 'rails_helper'
require 'publisher'

describe Publisher do
  subject { described_class.new(fetcher) }

  let(:fetcher) { double(:fetcher, fetch_currencies: currency) }
  let(:currency) { Currency.new(uuid: '123', rates: {'EUR' => 1}, base: 'USD') }

  describe '#publish' do
    it 'uses fetcher' do
      expect(fetcher).to receive(:fetch_currencies)
      subject.publish
    end
  end
end
