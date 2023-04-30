# frozen_string_literal: true

require 'fileutils'
require 'singleton'
require 'yaml'

class Configuration
  include Singleton

  unless File.exist?('config/configuration.yml')
    FileUtils.cp 'config/configuration.example.yml',
                 'config/configuration.yml'
  end
  %w[rss_feeds category].each do |method|
    define_singleton_method(method) { configuration[method] }
  end

  class << self
    def downloads_directory
      @downloads_directory ||= standardize_path(configuration['downloads_directory'])
    end

    def all
      configuration
    end

    private

    def configuration
      @configuration ||= File.read('config/configuration.yml')
                             .then { |string| YAML.safe_load(string) }
    end

    def standardize_path(path)
      path[-1] == '/' ? path : path << '/'
    end
  end
end
