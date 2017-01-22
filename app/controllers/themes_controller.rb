class ThemesController < ApplicationController
  def new
  end

  def create
    @theme = Theme.new(theme_params)
    theme_file = @theme.get_file

    zip_data = File.read(theme_file)
    send_data(zip_data, :type => 'application/zip', :filename => File.basename(theme_file))

    @theme.destroy
  end

  private

    def theme_params
      params.permit(:name, :slug, :author, :author_uri, :description, :branch)
    end
end
