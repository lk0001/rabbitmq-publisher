require 'json'
require 'yaml'

class FileProvider
  def initialize(path=nil)
    @path = path || default_path
  end

  def fetch
    YAML.load(File.read(@path))
  end

  def default_path
    'config/currencies.yml'
  end
end
