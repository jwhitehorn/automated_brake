#!/usr/bin/env ruby
require 'yaml'

directories = YAML.load_file 'settings.yml'
command_base = "nice -n 15 HandBrakeCLI -i $0/$1 -o /tmp/$4 $3 && mv /tmp/$4 $2/$4"

loop do
  directories.each do |config|
    dir = config[:path]
    out_path = config[:out_path]
    options = config[:options]
    Dir.entries(dir).each do |file|
      next if file[0] == "."[0]
      filename = "#{dir}/#{file}"
      first_size = File.size?(filename)
      sleep 30
      if first_size == File.size?(filename)
        #the file has not changed in size in 30 seconds, go ahead and begin processing it
        out_file = file.gsub(/\.[^.]*$/, '') + config[:final_extension]
        task = command_base.gsub(/\$0/, dir).gsub(/\$1/, file)
        task = task.gsub(/\$2/, out_path).gsub(/\$3/, options)
        task = task.gsub(/\$4/, out_file)
        puts task
        puts system task
        File.unlink(filename) if config[:delete]
      end
    end
  end
  sleep 10
end
