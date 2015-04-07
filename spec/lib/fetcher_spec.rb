require 'rails_helper'
require 'fetcher'

describe Fetcher do
  subject { described_class.new(currency_rates_provider) }

  let(:currency_rates_provider) do
    double(:currency_rates_provider, fetch: new_results)
  end

  let(:old_rates) { {'EUR' => 1} }
  let(:new_rates) { {'EUR' => 2} }
  let(:old_results) { {base: 'USD', rates: old_rates} }
  let(:new_results) { {base: 'USD', rates: new_rates} }

  describe '#fetch_currencies' do
    context 'there are no saved results' do
      it 'calls provider' do
        expect(currency_rates_provider).to receive(:fetch)
        subject.fetch_currencies
      end

      it 'returns newly fetched currency record' do
        expect(subject.fetch_currencies.rates).to eq(new_rates)
      end
    end

    context 'there are saved results' do
      before(:each) do
        Currency.create(old_results)
      end

      context 'results are outdated' do
        before(:each) do
          Timecop.travel(1.hour.from_now)
        end

        it 'calls provider' do
          expect(currency_rates_provider).to receive(:fetch)
          subject.fetch_currencies
        end

        it 'returns newly fetched currency record' do
          expect(subject.fetch_currencies.rates).to eq(new_rates)
        end
      end

      context 'results are up to date' do
        it "doesn't call provider" do
          expect(currency_rates_provider).not_to receive(:fetch)
          subject.fetch_currencies
        end

        it 'returns cached currency record' do
          expect(subject.fetch_currencies.rates).to eq(old_rates)
        end
      end
    end
  end
end
