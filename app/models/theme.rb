require 'rubygems'
require 'zip'

class Theme

  REPO_URL = 'https://github.com/diegoversiani/underskeleton.git'

  attr_accessor :name, :slug, :author, :author_uri, :description

  def get_file
    generate_file
  end



  private

    def generate_file
      puts 'Generating theme file...'
      @theme_root_dir = Rails.public_path.to_s + "/download/#{@slug}"
      @theme_dir = Rails.public_path.to_s + "/download/#{@slug}/#{@slug}"
      @archive = Rails.public_path.to_s + "/download/#{@slug}.zip"
      # todo: sanitize theme id
      # @slug ||= @name.downcase

      # Delete and create directory
      if Dir.exists?(@theme_root_dir)
        FileUtils.rm_rf("#{@theme_root_dir}/.", secure: true)
        Dir.rmdir @theme_root_dir
      end
      Dir.mkdir @theme_root_dir
      Dir.mkdir @theme_dir

      # clone underskeleton repo and remove git references
      Git.export REPO_URL, @theme_dir
      
      # replace underskeleton references
      replace_in_files
      rename_language_files
      compress

      puts 'Generating theme file complete.'

      @archive
    end



    def replace_in_files
      puts 'Replacing underskeleton references...'

      files = Dir.glob(@theme_dir + '/**/*.*')

      files.each do |f|
        text = File.read(f)
        if File.basename(f, '.css') == 'style'
          text = text.gsub(/^Author\: (.+)\n/, "Author: #{@author}\n")
          text = text.gsub(/^Author URI\: (.+)\n/, "Author URI: #{@author_uri}\n")
          text = text.gsub(/^Description\: (.+)\n/, "Description: #{@description}\n")
          puts '===== style.css'
        end

        # text theme name and slug
        text = text.gsub('Underskeleton', @name)
        text = text.gsub('underskeleton', @slug)

        # recover underskeleton website/github url
        text = text.gsub("get#{@slug}", "getunderskeleton")
        text = text.gsub("diegoversiani/#{@slug}", "diegoversiani/underskeleton")

        File.open(f, "w") { |file| file.puts text }
      end

      puts 'Replacing complete.'
    end



    def rename_language_files
      puts 'Renaming files in /languages...'

      files = Dir.glob(@theme_dir + '/languages/underskeleton*')

      files.each do |f|
        filename = File.basename(f)
        new_filename = filename.gsub!('underskeleton', @slug)
        File.rename(f, @theme_dir + "/languages/#{new_filename}")
      end

      puts 'Renaming complete.'
    end



    def compress
      
      FileUtils.rm(@archive, force: true)

      Zip::File.open(@archive, 'w') do |zipfile|
        Dir["#{@theme_root_dir}/**/**"].each do |file|
          zipfile.add(file.sub(@theme_root_dir+'/',''),file)
        end
      end
    end

end