# frozen_string_literal: true

require 'fileutils'
module RSS
  module Rules
    class Repository
      def initialize
        @repo = {}
      end

      attr_reader :repo

      def count = repo.count
      def load(hash) = repo.merge!(hash)

      # rubocop:disable Metrics/MethodLength
      def add!(title:, feeds:, category:, save_path:)
        return 'invalid path / filename' unless validate_path(save_path)

        repo.merge!(
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
      # rubocop:enable Metrics/MethodLength

      def delete!(title)
        repo.delete(title)
      end

      def find(title)
        repo[title]
      end

      def search(title)
        repo.select { |key, _| key.downcase.include?(title.downcase) }
      end

      def update!(title, attributes)
        find(title).merge!(attributes)
      end

      private

      def validate_path(path)
        path.split('/')[1..].all? { |dir| %r{^([^<>/:|?*"\\]+)$}.match?(dir) }
      end
    end
  end
end
