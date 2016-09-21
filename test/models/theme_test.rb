require 'test_helper'

class ThemeTest < ActiveSupport::TestCase
  

  def setup
    @theme = Theme.new(
      name: 'New Theme',
      slug: 'newslug',
      author: 'John Doe',
      author_uri: 'http://johndoe.com',
      description: 'Description of the new theme.')

    @download_dir = Rails.root.join('tmp/generated-themes').to_s
  end

  test "should create theme folder and compressed file" do
    @theme.get_file

    assert Dir.exists?(@download_dir + "/#{@theme.slug}/#{@theme.slug}")
    assert File.exists?(@download_dir + "/#{@theme.slug}.zip")
  end

  test "should create theme folder and compressed file when only name is present" do
    @theme = Theme.new(name: 'Theme Name')

    # should convert name to slug
    assert_equal "theme-name", @theme.slug

    @theme.get_file

    assert Dir.exists?(@download_dir + "/#{@theme.slug}/#{@theme.slug}")
    assert File.exists?(@download_dir + "/#{@theme.slug}.zip")
  end

  test "should change theme identification in style.css file" do
    @theme.get_file

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

  test "should delete folder and compressed file" do
    @theme.get_file

    assert @theme.respond_to? :destroy

    @theme.destroy

    assert_not Dir.exists?(@download_dir + "/#{@theme.slug}/#{@theme.slug}")
    assert_not File.exists?(@download_dir + "/#{@theme.slug}.zip")
  end

  test "should not generate if name and slug are not present" do
    @theme = Theme.new
    assert_not @theme.get_file

    @theme.name = 'Something'
    @theme.slug = nil
    assert_not @theme.get_file

    @theme.slug = ''
    assert_not @theme.get_file
  end

end
