require 'json'

class Fetcher
  def initialize(provider)
    @provider = provider
  end

  def fetch_currencies
    reset_last_value
    if up_to_date?
      cached_rates
    else
      new_rates
    end
  end

  private

  def reset_last_value
    @cached_rates = nil
  end

  def cached_rates
    @cached_rates ||= Currency.last
  end

  def new_rates
    Currency.create(results_from_provider)
  end

  def results_from_provider
    @provider.fetch.with_indifferent_access.slice(:base, :rates, :timestamp).tap do |h|
      h[:uuid] = h.delete(:timestamp)
    end
  end

  def up_to_date?
    cached_rates && created_less_than_hour_ago?
  end

  def created_less_than_hour_ago?
    Time.now - cached_rates.created_at < 1.hour
  end
end
