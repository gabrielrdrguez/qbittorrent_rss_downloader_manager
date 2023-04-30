# frozen_string_literal: true

require 'json'
require 'irb/cmd/debug'
require_relative 'src/configuration'
require_relative 'src/rss_rule_repository'
require_relative 'src/rules_file'

class Main
  def initialize
    rules_json = RulesFile.load_file
    RSSRuleRepository.load(rules_json)
  end

  def console
    binding.irb
  end

  def add(title)
    irb_context.echo = false

    RSSRuleRepository.add!(
      title:,
      feeds: Configuration.rss_feeds,
      category: Configuration.category,
      save_path: Configuration.downloads_directory + title
    )

    irb_context.echo = true
    true
  end

  def list
    irb_context.echo = false
    puts RSSRuleRepository.repo.keys
  end

  def save
    irb_context.echo = true
    RulesFile.save(RSSRuleRepository.repo)
  end

  def show(title)
    puts JSON.pretty_generate RSSRuleRepository.find(title)
  end

  def remove(title)
    irb_context.echo = false
    RSSRuleRepository.delete!(title)
    irb_context.echo = true
    true
  end

  def count
    irb_context.echo = true
    RSSRuleRepository.count
  end

  def update_all_dir(path)
    irb_context.echo = false
    RSSRuleRepository.repo.each_pair do |key, value|
      folder = value['savePath'].split('/').last
      path[-1] == '/' ? path : path << '/'
      RSSRuleRepository.update!(key, { 'savePath' => path + folder })
    end
    RSSRuleRepository.repo.each_value { |value| puts value['savePath'] }
  end
end

main = Main.new
main.console
