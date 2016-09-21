class Repository

  REPO_URL = 'https://github.com/diegoversiani/underskeleton.git'

  def self.get_file(theme)
    self.generate_file(new_theme_name)
  end

  private

    def self.generate_file(theme)
      puts 'Generating theme file...'

      @new_theme_name = new_theme_name
      # todo: sanitize
      @new_theme_id = theme.theme_slug || theme.theme_nam

      @theme_dir = Rails.public_path.to_s + "/download/#{@new_theme_id}"

      # Delete and create directory
      if Dir.exists?(@theme_dir)
        FileUtils.rm_rf("#{@theme_dir}/.", secure: true)
        Dir.rmdir(@theme_dir)
      end
      Dir.mkdir(@theme_dir)

      # clone underskeleton repo and remove git references
      Git.export(REPO_URL, @theme_dir)
      
      # replace underskeleton references
      self.replace_in_files
      self.rename_language_files

      puts 'Generating theme file complete.'

      "#{@new_theme_id}.zip"
    end

    def self.replace_in_files
      puts 'Replacing underskeleton references...'

      files = Dir.glob(@theme_dir + '/**/*.*')

      files.each do |f|
        text = File.read(f)

        replace = text.gsub!('underskeleton', @new_theme_id)
        replace = text.gsub!('Underskeleton', @new_theme_name)

        File.open(f, "w") { |file| file.puts replace }
      end

      puts 'Replacing complete.'
    end

    def self.rename_language_files
      puts 'Renaming files in /languages...'

      files = Dir.glob(@theme_dir + '/languages/underskeleton*')

      files.each do |f|
        filename = File.basename(f)
        new_filename = filename.gsub!('underskeleton', @new_theme_id)
        File.rename(f, @theme_dir + "/languages/#{new_filename}")
      end

      puts 'Renaming complete.'
    end

end