#!/usr/bin/env ruby
require 'yaml'

directories = YAML.load_file 'settings.yml'

loop do
  directories.each do |config|
    dir = config[:path]
    command = config[:command]
    Dir.entries(dir).each do |file|
      next if file[0] == "."[0]
      task = command.gsub(/\$0/, dir).gsub(/\$1/, file)
      puts task
      system task
      File.unlink(dir + "/" + file) if config[:delete]
    end
  end
  sleep 60
end
