# frozen_string_literal: true

require 'fileutils'
require 'yaml'
require_relative 'configurations/file'
class Configuration
  def initialize
    @configuration ||= ::Configurations::File.load_file
  end

  attr_reader :configuration

  %w[rss_feeds category downloads_directory last_file].each do |method|
    define_method(method) { configuration[method] }
    define_method("#{method}=") { |value| configuration[method] = value }
  end

  def downloads_directory=(path)
    configuration['downloads_directory'] = standardize_path(path)
  end

  def all = configuration

  def save = ::Configurations::File.save(@configuration)

  private

  def standardize_path(path)
    path[-1] == '\\' ? path : path << '\\'
  end
end
