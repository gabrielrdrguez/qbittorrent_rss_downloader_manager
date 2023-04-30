# frozen_string_literal: true

require 'fileutils'
module RSS
  module Rules
    module File
      EXAMPLE_FILE_PATH = 'rss.example.json'
      FILE_PATH         = 'rss.json'

      class << self
        def load
          FileUtils.cp(EXAMPLE_FILE_PATH, FILE_PATH) unless ::File.exist?(FILE_PATH)
          JSON.parse(::File.read(FILE_PATH))
        end

        def save(hash)
          ::File.write(FILE_PATH, JSON.pretty_generate(hash))
        end
      end
    end
  end
end
