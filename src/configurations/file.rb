require 'fileutils'
require 'yaml'

module Configurations
  module File
    class << self
      FILE_PATH = 'config/configuration.yml'
      EXAMPLE_FILE_PATH = 'config/configuration.yml'

      def load_file
        ::FileUtils.cp EXAMPLE_FILE_PATH, FILE_PATH unless ::File.exist?(FILE_PATH)

        ::File.read(FILE_PATH).then { |string| YAML.safe_load(string) }
      end


      def save(configuration)
        ::File.write(FILE_PATH, configuration.to_yaml)
      end
    end
  end
end