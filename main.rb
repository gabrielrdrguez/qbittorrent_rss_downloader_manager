require 'json'
require 'yaml'
require 'irb/cmd/debug'
require 'ostruct'
require 'fileutils'
require_relative 'configuration'
require_relative 'rss'

def standardize_path(path)
  path[-1] == '/' ? path : path << '/'
end

def add(title)
  irb_context.echo = false

  RSS.add!(
    title: title,
    feeds: Configuration.rss_feeds,
    category: Configuration.category,
    save_path: Configuration.downloads_directory + title
  )

  irb_context.echo = true
  true
end

def list
  puts RSS.json.keys
end

def save
  irb_context.echo = true
  RSS.save
end

def show(title)
  puts JSON.pretty_generate RSS.json[title]
end

def remove(title)
  irb_context.echo = false
  RSS.delete(title)
  irb_context.echo = true
  true
end

def count
  RSS.json.count
end

def change_dir(path)
  irb_context.echo = false
  RSS.json.each_pair do |_key, value|
    folder = value['savePath'].split('/').last
    standardize_path(path)
    value['savePath'] = path + folder
  end
  RSS.json.each_value { |value| puts value['savePath'] }
end

binding.irb
