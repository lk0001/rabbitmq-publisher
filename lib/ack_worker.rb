require 'sneakers'
require 'json'

class AckWorker
  include Sneakers::Worker
  from_queue 'currencies.acknowledgements', env: nil

  def work(msg)
    currency_hash = JSON.parse(msg)
    currency = currency_for(currency_hash['uuid'])
    if currency
      currency.update_attributes("c#{currency_hash['id']}_success" => true)
      ack!
    else
      reject!
    end
  end

  def currency_for(uuid)
    Currency.find_by(uuid: uuid)
  end
end
