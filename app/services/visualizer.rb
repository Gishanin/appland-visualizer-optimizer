class Visualizer

  def initialize(events)
    @events = events
  end

  def helpers
    filter_hash("app/helpers")
  end

  def controllers
    filter_hash("app/controllers")
  end

  def models
    filter_hash("app/models")
  end

  private

  def filtred_json
    @filtred_json ||= @events.filter do |event|
      event[:path].present? && event[:path].ends_with?(".rb") && event[:path].starts_with?("app/")
    end
  end

  def filter_hash(name)
    filtred_json.filter do |event|
      event[:path].starts_with?(name)
    end
  end
end
