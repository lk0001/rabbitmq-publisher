require 'json'
require 'open-uri'
require 'yaml'

class UrlProvider
  def initialize(url=nil)
    @url = url || default_url
  end

  def fetch
    JSON.load(open(@url))
  end

  def default_url
    "http://openexchangerates.org/api/latest.json?app_id=#{ENV['OPENEXCHANGE_APP_ID']}"
  end
end
