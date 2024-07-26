#!/usr/bin/env ruby
# https://github.com/larskanis/fxruby/blob/1.6/examples/table.rb
require 'date'
require 'json'
require 'irb/cmd/debug'
require_relative 'src/configuration'
require_relative 'src/rss/rules/repository'
require_relative 'src/rss/rules/file'
require_relative 'src/gui/main_window'

# Start the whole thing
# Make application
application = FXApp.new("RSS Download Manager", "Gabriel Rodriguez")

repository = RSS::Rules::Repository.new
configuration = Configuration.new
rules_json = RSS::Rules::File.load_file(configuration.last_file)
repository.load(rules_json)
# Make window
MainWindow.new(application, repository, configuration)

# Create app
application.create

# Run
application.run
