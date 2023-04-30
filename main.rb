# frozen_string_literal: true

require 'json'
require 'irb/cmd/debug'
require_relative 'src/configuration'
require_relative 'src/rss/rules/repository'
require_relative 'src/rss/rules/file'

class Main
  def initialize(repository:, config:)
    @repository = repository
    @config = config
  end

  attr_reader :repository, :config

  def console = binding.irb

  def add(title)
    irb_context.echo = false

    repository.add!(
      title:,
      feeds: config.rss_feeds,
      category: config.category,
      save_path: config.downloads_directory + title
    )

    irb_context.echo = true
    true
  end

  def list
    irb_context.echo = false
    puts repository.repo.keys
  end

  def save
    irb_context.echo = true
    RSS::Rules::File.save(repository.repo)
  end

  def show(title)
    puts JSON.pretty_generate repository.find(title)
  end

  def remove(title)
    irb_context.echo = false
    repository.delete!(title)
    irb_context.echo = true
    true
  end

  def count
    irb_context.echo = true
    repository.count
  end

  def update_all_dir(path)
    irb_context.echo = false
    repository.repo.each_pair do |key, value|
      folder = value['savePath'].split('/').last
      path[-1] == '/' ? path : path << '/'
      repository.update!(key, { 'savePath' => path + folder })
    end
    repository.repo.each_value { |value| puts value['savePath'] }
  end
end

repository = RSS::Rules::Repository.new
rules_json = RSS::Rules::File.load
configuration = Configuration.new
repository.load(rules_json)

main = Main.new(repository: repository, config: configuration)
main.console
