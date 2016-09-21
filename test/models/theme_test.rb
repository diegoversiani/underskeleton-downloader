require 'test_helper'

class ThemeTest < ActiveSupport::TestCase
  

  def setup
    @theme = Theme.new
    @theme.name = 'New Theme'
    @theme.slug = 'newslug'
    @theme.author = 'John Doe'
    @theme.author_uri = 'http://johndoe.com'
    @theme.description = 'Description of the new theme.'

    @download_dir = Rails.public_path.to_s + "/download"

    @theme.get_file
  end

  test "theme folder and zip file created" do
    assert Dir.exists?(@download_dir + "/#{@theme.slug}/#{@theme.slug}")
    assert File.exists?(@download_dir + "/#{@theme.slug}.zip")
  end

  test "theme identification changed" do
    filename = @download_dir + "/#{@theme.slug}/#{@theme.slug}/style.css"

    assert File.exists?(filename)

    file_contents = File.read(filename)

    assert_not file_contents.nil?
    assert file_contents.include?("Theme Name: #{@theme.name}")
    assert file_contents.include?("Author: #{@theme.author}")
    assert file_contents.include?("Author URI: #{@theme.author_uri}")
    assert file_contents.include?("Description: #{@theme.description}")
    assert file_contents.include?("Text Domain: #{@theme.slug}")
  end
end
