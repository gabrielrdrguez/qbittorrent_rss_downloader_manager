# frozen_string_literal: true

require 'fileutils'
require 'singleton'

class RulesFile
  include Singleton

  class << self
    def load_file
      FileUtils.cp 'rss.example.json', 'rss.json' unless File.exist?('rss.json')
      JSON.parse(File.read('rss.json'))
    end

    def save(hash)
      File.write('rss.json', JSON.pretty_generate(hash))
    end
  end
end
