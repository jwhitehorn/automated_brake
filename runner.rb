#!/usr/bin/env ruby
require 'yaml'

directories = YAML.load_file 'settings.yml'

loop do
  directories.each do |config|
    dir = config[:path]
    out_path = config[:out_path]
    command = config[:command]
    Dir.entries(dir).each do |file|
      next if file[0] == "."[0]
      filename = "#{dir}/#{file}"
      first_size = File.size?(filename)
      sleep 30
      if first_size == File.size?(filename)
        #the file has not changed in size in 30 seconds, go ahead and begin processing it
        task = command.gsub(/\$0/, dir).gsub(/\$1/, file).gsub(/\$2/, out_path)
        puts task
        puts system task
        File.unlink(dir + "/" + file) if config[:delete]
      end
    end
  end
  sleep 10
end
