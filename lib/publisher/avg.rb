module Publisher
  class AVG < Base

    def initialize(guide)
      super(guide)
      @asset_path = Rails.root.join(root_path, 'assets')
      FileUtils.mkdir_p asset_path
    end

    private

    attr_reader :asset_path

    def collect_and_sync_assets
      collect_assets
      sync_assets
    end

    def collect_assets
      render_assets if Rails.env.development?

      move_files Rails.root.join(*%w{public assets avg*.*}), asset_path
      move_files Rails.root.join(*%w{public assets avg *.*}), asset_path
      make_subpages Rails.root.join(*%w{public avg *.html})
    end

    def move_files(files, dest)
      Dir[files].each do |file|
        filename = File.basename(file)
        next if filename.include? '.gz'
        FileUtils.cp file, Rails.root.join(dest, filename.gsub(/\-.+\./, '.'))
      end
    end

    def make_subpages(subpages)
      Dir[subpages].each do |subpage|
        filename = File.basename(subpage)
        return move_files(subpage) if !filename.include?('.html') || filename.include?('index')
        dir_path = Rails.root.join(root_path, filename.split('.html').first)
        FileUtils.mkdir dir_path
        FileUtils.cp subpage, Rails.root.join(dir_path, 'index.html')
      end
    end

    def render_assets
      `bundle exec rake assets:precompile`
      `bundle exec rake render:subpages[true]`
    end

    def sync_assets
      s3.upload_directory root_path
    end

    def clean_assets
      FileUtils.remove_dir root_path
    end

    def s3
      @s3_uploader ||= S3Uploader.new bucket
    end

    def bucket
      ENV['AVG_BUCKET'] || 'preview.americanvoterguide.org'
    end

    def root_path
      Rails.root.join(*%w{tmp avg})
    end

    def generate
      collect_and_sync_assets
    end

    def clean
      clean_assets
    end
  end
end
