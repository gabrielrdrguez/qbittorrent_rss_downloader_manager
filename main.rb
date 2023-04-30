# frozen_string_literal: true

require 'json'
require 'irb/cmd/debug'
require_relative 'src/configuration'
require_relative 'src/rss_rule_repository'
require_relative 'src/rules_file'

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
    RulesFile.save(repository.repo)
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

repo = RSSRuleRepository.new
rules_json = RulesFile.load_file
configuration = Configuration.new
repo.load(rules_json)

main = Main.new(repository: repo, config: configuration)
main.console
