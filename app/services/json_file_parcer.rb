class JsonFileParcer
  attr_reader :hash
  def initialize(path)
    file = File.read(path)
    @hash = JSON.parse(file).deep_symbolize_keys!
  end

  def events
    hash[:events]
  end
end