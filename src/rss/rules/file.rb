# frozen_string_literal: true

require 'fileutils'
module RSS
  module Rules
    module File
      class << self
        def load_file(file_path = 'rss.json')
          if file_path == 'rss.json'
            FileUtils.cp 'rss.example.json', 'rss.json' unless ::File.exist?('rss.json')
          end
          @file_path = file_path
          JSON.parse(::File.read(file_path))
        end


        def save(hash)
          ::File.write(@file_path, JSON.pretty_generate(hash))
        end
      end
    end
  end
end
