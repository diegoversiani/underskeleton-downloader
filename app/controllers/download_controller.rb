class DownloadController < ApplicationController

  def index
    
  end

  def show
    Repository.get_file params[:name]
  end

end