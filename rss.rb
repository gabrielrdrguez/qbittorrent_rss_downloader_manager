require 'fileutils'
require 'singleton'

class RSS
  include Singleton
  extend Forwardable

  class << self
    def json
      FileUtils.cp 'rss.example.json', 'rss.json' unless File.exist?('rss.json')
      @@json ||= JSON.parse(File.read('rss.json'))
    end

    def add!(title:, feeds:, category:, save_path:)
      return 'invalid path / filename' unless validate_path(save_path)

      json.merge!(
        {
          title => {
            'addPaused' => nil,
            'affectedFeeds' => feeds,
            'assignedCategory' => category,
            'enabled' => true,
            'episodeFilter' => '',
            'ignoreDays' => 0,
            'lastMatch ' => '',
            'mustContain' => title,
            'mustNotContain' => '',
            'previouslyMatchedEpisodes' => [],
            'savePath' => save_path,
            'smartFilter' => false,
            'torrentContentLayout' => nil,
            'useRegex' => false
          }
        }
      )
    end

    def delete(title)
      json.delete(title)
    end

    def save
      File.write('rss.json', JSON.pretty_generate(json))
    end

    private

    def validate_path(path)
      path.split('/')[1..-1].all? { |dir| %r{^([^<>/:\|\?\*\"\\]{1,})$}.match?(dir) }
    end
  end
end
