class JsonAnalyzer
  attr_reader :params

  COEFFICIENT = 0.3.freeze

  def initialize(params)
    @params = params
    @events_count = params[:events].size
  end

  def call
    events = @params[:events].each_with_object(Hash.new(0)) {|event, res| res["#{event['defined_class']}##{event['method_id']}"] += 1 }
    sorted_evets = Hash[events.sort_by {|k,v| v}.reverse]
    delete_list(sorted_evets)
  end

  private

  def remove_size
    @remove_count ||= @events_count * (@params[:size_reduce].to_f / 100 || COEFFICIENT)
  end

  def delete_list(sorted_evets)
    limit = 0
    array = []
    sorted_evets.each do |k,v|
      limit += v
      break if limit >= remove_size
      array << k
    end
    return array
  end
end