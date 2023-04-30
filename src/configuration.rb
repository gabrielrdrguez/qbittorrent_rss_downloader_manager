# frozen_string_literal: true

require 'fileutils'
require 'yaml'

class Configuration
  def initialize
    unless File.exist?('config/configuration.yml')
      FileUtils.cp 'config/configuration.example.yml', 'config/configuration.yml'
    end

    @configuration ||= File.read('config/configuration.yml')
                           .then { |string| YAML.safe_load(string) }
  end

  attr_reader :configuration

  %w[rss_feeds category].each do |method|
    define_method(method) { configuration[method] }
  end

  def downloads_directory
    @downloads_directory ||= standardize_path(configuration['downloads_directory'])
  end

  def all = configuration

  private

  def standardize_path(path)
    path[-1] == '/' ? path : path << '/'
  end
end
