require 'bunny'

namespace :rabbit do
  desc 'creates queues and exchanges for publisher and clients'
  task :setup do
    conn = Bunny.new
    conn.start

    ch = conn.create_channel
    fanout = ch.fanout('currencies.fanout', durable: true)
    (1..3).each do |i|
      ch.queue("currencies.queue_#{i}", durable: true).bind(fanout)
    end
    direct = ch.direct('currencies.direct', durable: true)
    ch.queue('currencies.acknowledgements', durable: true).bind(direct, routing_key: 'acknowledgements')

    conn.close
  end
end
