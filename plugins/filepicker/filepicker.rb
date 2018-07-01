#!/usr/bin/env ruby

require 'rubygems'

# check required gems
['json'].each do |gem|
  begin
    require gem
  rescue LoadError
    puts "You need to install #{gem}: gem install #{gem}"
    exit!(1)
  end
end

# read api key
config_file = "#{ENV['HOME']}/.filepicker"
unless File.exist?(config_file)
  puts "You need to type your API key " + config_file
  exit!(1)
end
api_key = File.read(config_file)

# checking input file
if ARGV[0].nil?
  puts "You need to specify a file to upload."
  exit!(1)
end

# upload
file_name = ARGV[0]
json_return = `curl -s -F fileUpload=@#{file_name} 'https://www.filepicker.io/api/store/S3?key=#{api_key}&filename=#{file_name}'`
url = JSON.parse(json_return)['url']

# output to consle the link
puts url

# copy to mac clipboard
`echo #{url} | pbcopy`