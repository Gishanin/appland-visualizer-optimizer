class JsonOptimaizer
  def initialize(params)
    @appmap_json = params[:appmap_json]
    @filepath = params[:path]
    @size_reduce = params[:proc]
  end

  def call
    parce_json_file
    @analyzed_json = JsonAnalyzer.new({events: @hash['events'], size_reduce: @size_reduce}).call
    optimize_json
    create_optimized_file
  end
  

  private

  def optimize_json
    @analyzed_json.each do |v|
      defined_class, method_id = v.split('#')
      @hash['events'].delete_if do |e|
        e['defined_class'] == defined_class && e['method_id'] == method_id
      end
    end
  end

  def create_optimized_file
    FileUtils.mkdir("#{Rails.root}/tmp/appland_optimized") unless File.directory?("#{Rails.root}/tmp/appland_optimized")
    new_path = "./tmp/appland_optimized/#{File.basename(@filepath, ".appmap.json")}_optimized.appmap.json"
    File.write(new_path, JSON.dump(@hash))
    @appmap_json.update(path: new_path, name: File.basename(new_path, ".appmap.json"), status: 1)
  end

  def parce_json_file
    file = File.read(@filepath)
    @hash = JSON.parse(file)
  end
end