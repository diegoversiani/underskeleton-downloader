require 'rubygems'
require 'zip'

class Theme

  attr_accessor :name, :slug, :author, :author_uri, :description, :branch

  REPO_URL = 'https://github.com/diegoversiani/underskeleton.git'

  def initialize(params={})
    @name = params[:name]
    @slug = params[:slug].present? ?  Theme.convert_to_slug(params[:slug]) : Theme.convert_to_slug(@name)
    @author = params[:author]
    @author_uri = params[:author_uri]
    @description = params[:description]
    @branch = params[:branch]
  end

  def get_file
    generate_file if @name.present? and @slug.present?
  end

  def destroy
    set_paths

    FileUtils.rm(@archive, force: true)

    if Dir.exists?(@theme_root_dir)
      FileUtils.rm_rf("#{@theme_root_dir}/.", secure: true)
      Dir.rmdir @theme_root_dir
    end
  end



  private

    def generate_file
      set_paths

      # todo: sanitize theme id
      @slug = @slug || @name

      # create generate-themes directory
      Dir.mkdir Rails.root.join('tmp/generated-themes') unless Dir.exists?(Rails.root.join('tmp/generated-themes'))
      
      # clone repo and replace underskeleton references
      destroy
      clone_repo
      replace_in_files
      rename_language_files
      compress

      @archive
    end



    def set_paths
      @theme_root_dir = Rails.root.join('tmp/generated-themes', "#{@slug}").to_s
      @theme_dir = Rails.root.join('tmp/generated-themes', "#{@slug}/#{@slug}").to_s
      @archive = Rails.root.join('tmp/generated-themes', "#{@slug}.zip").to_s
    end



    def clone_repo
      Dir.mkdir @theme_root_dir
      Dir.mkdir @theme_dir

      # clone underskeleton repo
      g = Git.clone REPO_URL, @theme_dir

      # checkout branch or last release
      if !@branch.nil? && !@branch.empty?
        raise 'Branch do not exist' if g.branches['origin/' + @branch].nil?
        g.checkout(g.branches['origin/' + @branch])
      else
        g.checkout g.tags.last
      end

      # clean git references
      if Dir.exists?("#{@theme_dir}/.git")
        FileUtils.rm_rf("#{@theme_dir}/.git/.", secure: true)
        Dir.rmdir "#{@theme_dir}/.git"
      end
    end



    def replace_in_files
      files = Dir.glob(@theme_dir + '/**/*.*')

      files.each do |f|
        next if File.basename(f) == 'README.md'

        text = File.read(f)
        if File.basename(f) == 'style.css'
          text = text.gsub(/^Author\: (.+)\n/, "Author: #{@author}\n")
          text = text.gsub(/^Author URI\: (.+)\n/, "Author URI: #{@author_uri}\n")
          text = text.gsub(/^Description\: (.+)\n/, "Description: #{@description}\n")
        end

        # text theme name and slug
        text = text.gsub('Underskeleton_', Theme.convert_to_slug_titleize(@name) + '_')
        text = text.gsub('underskeleton', @slug)
        text = text.gsub('Underskeleton', @name)

        # recover underskeleton website/github url
        text = text.gsub("get#{@slug}", "getunderskeleton")
        text = text.gsub("diegoversiani/#{@slug}", "diegoversiani/underskeleton")

        File.open(f, "w") { |file| file.puts text }
      end

    end



    def rename_language_files
      files = Dir.glob(@theme_dir + '/languages/underskeleton*')

      files.each do |f|
        filename = File.basename(f)
        new_filename = filename.gsub!('underskeleton', @slug)
        File.rename(f, @theme_dir + "/languages/#{new_filename}")
      end
    end



    def compress
      Zip::File.open(@archive, 'w') do |zipfile|
        Dir["#{@theme_root_dir}/**/**"].each do |file|
          zipfile.add(file.sub(@theme_root_dir+'/',''),file)
        end
      end
    end



    def self.convert_to_slug(str)
      str.to_s.gsub(/[^A-Za-z0-9_]+/, '_').downcase
    end



    def self.convert_to_slug_titleize(str)
      str.to_s.gsub(/[^A-Za-z0-9_]+/, ' ').titleize.gsub(' ', '_')
    end

end