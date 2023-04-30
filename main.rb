require 'json'
require 'yaml'
require 'irb/cmd/debug'
require 'ostruct'
require 'fileutils'

FileUtils.cp 'configuration.example.yml', 'configuration.yml' unless File.exist?('configuration.yml')
FileUtils.cp 'rss.example.json', 'rss.json' unless File.exist?('rss.json')
@json = JSON.parse(File.read('rss.json'))
@configuration = File.read('configuration.yml')
                     .then { |string| YAML.safe_load(string) }
                     .then { |hash| OpenStruct.new(hash) }
def downloads_directory
  @downloads_directory ||= standardize_path(@configuration.downloads_directory)
end

def standardize_path(path)
  path[-1] == '/' ? path : path << '/'
end

def add(title)
  return 'invalid filename' unless %r{^([^<>/:\|\?\*\"\\]{1,})$}.match? title

  irb_context.echo = false
  @json.merge!(
    {
      title => {
        'addPaused' => nil,
        'affectedFeeds' => @configuration.feeds,
        'assignedCategory' => @configuration.category,
        'enabled' => true,
        'episodeFilter' => '',
        'ignoreDays' => 0,
        'lastMatch ' => '',
        'mustContain' => title,
        'mustNotContain' => '',
        'previouslyMatchedEpisodes' => [],
        'savePath' => downloads_directory + title,
        'smartFilter' => false,
        'torrentContentLayout' => nil,
        'useRegex' => false
      }
    }
  )
  irb_context.echo = true
  true
end

def list
  puts @json.keys
end

def save
  irb_context.echo = true
  File.write('rss.json', JSON.pretty_generate(@json))
end

def show(title)
  puts JSON.pretty_generate @json[title]
end

def remove(title)
  irb_context.echo = false
  @json.delete(title)
  irb_context.echo = true
  true
end

def count
  @json.count
end

def change_dir(path)
  irb_context.echo = false
  @json.each_pair do |_key, value|
    folder = value['savePath'].split('/').last
    standardize_path(path)
    value['savePath'] = path + folder
  end
  @json.each_value { |value| puts value['savePath'] }
end

binding.irb
