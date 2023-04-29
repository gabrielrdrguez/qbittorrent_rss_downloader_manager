require 'json'
require 'irb/cmd/debug'

@json = JSON.parse(File.read('rss.json'))
AFFECTED_FEEDS = ['https://rss_feed_example.dev'].freeze
CATEGORY = 'Category'.freeze
def add(title)
  return 'invalid filename' unless /^([^<>\/:\|\?\*\"\\]{1,})$/.match? title

  irb_context.echo = false
  @json.merge!(
    {
      title => {
        'addPaused' => nil,
        'affectedFeeds' => AFFECTED_FEEDS,
        'assignedCategory' => CATEGORY,
        'enabled' => true,
        'episodeFilter' => '',
        'ignoreDays' => 0,
        'lastMatch ' => '',
        'mustContain' => title,
        'mustNotContain' => '',
        'previouslyMatchedEpisodes' => [],
        'savePath' => "E:/Downloads/#{title}",
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
    path[-1] == '/' ? path : path << '/'
    value['savePath'] = path + folder
  end
  @json.each_value { |value| puts value['savePath'] }
end

binding.irb
