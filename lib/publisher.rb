require 'bunny'

class Publisher
  def initialize(fetcher)
    @fetcher = fetcher
  end

  def publish
    fanout.publish(currency_hash.to_json)
  end

  private

  def currency_hash
    currency = @fetcher.fetch_currencies
    {
      uuid: currency.uuid,
      rates: currency.rates,
      base: currency.base
    }
  end

  # rabbit stuff

  def connection
    @connection ||= Bunny.new.tap do |c|
      c.start
    end
  end

  def channel
    @channel ||= connection.create_channel
  end

  def fanout
    @fanout ||= channel.fanout('currencies.fanout', durable: true)
  end
end
