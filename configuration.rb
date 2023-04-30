require 'fileutils'
require 'singleton'

class Configuration
  include Singleton

  FileUtils.cp 'configuration.example.yml', 'configuration.yml' unless File.exist?('configuration.yml')
  @@configuration ||= File.read('configuration.yml')
                          .then { |string| YAML.safe_load(string) }
                          .then { |hash| OpenStruct.new(hash) }

  %i[rss_feeds category].each do |method|
    define_singleton_method(method) { @@configuration.send(method) }
  end

  class << self
    def downloads_directory
      @downloads_directory ||= standardize_path(@@configuration.downloads_directory)
    end

    def all
      @@configuration
    end

    private

    def standardize_path(path)
      path[-1] == '/' ? path : path << '/'
    end
  end
end
