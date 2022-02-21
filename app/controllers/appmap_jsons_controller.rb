class AppmapJsonsController < ApplicationController
  before_action :find_appmap, only: %i[show edit update destroy update]

  def index
    @jsons = AppmapJson.all.order! 'created_at DESC'
  end

  def show
    json = JsonFileParcer.new(@appmap_json.path)
    visualizer = Visualizer.new(json.events)

    @count_controllers = visualizer.controllers.count
    @count_helpers = visualizer.helpers.count
    @count_models = visualizer.models.count
    @one_procent = (@count_controllers + @count_helpers + @count_models).to_f / 100
  end

  def new
  end

  def edit

  end

  def update
    JsonOptimaizer.new({proc: params[:proc], path: @appmap_json.path, appmap_json: @appmap_json}).call
    redirect_to root_path
  end

  def destroy
    @appmap_json.destroy
    redirect_to root_path
  end

  def create
    if (params[:path].ends_with?(".json"))
      AppmapJson.create(path: params[:path], name: File.basename(params[:path], ".appmap.json"))
      redirect_to root_path
    else
      create_from_folder
      redirect_to root_path
    end
  end

  private

  def find_appmap
    @appmap_json = AppmapJson.find_by(id: params[:id])
  end

  def create_from_folder
    files_list = Dir.entries(params[:path]).select { |f| File.file? File.join(params[:path], f) }

    files_list.each do |file|
      AppmapJson.create(path: "#{params[:path]}/#{file}", name: File.basename(file, ".appmap.json"))
    end
  end
end
