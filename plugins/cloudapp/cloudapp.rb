#!/usr/bin/env ruby
#
# cloudapp
# Zach Holman / @holman
#
# Uploads a file from the command line to CloudApp, drops it into your 
# clipboard (on a Mac, at least).
#
# Example:
#
#   cloudapp drunk-blake.png
#
# This requires Aaron Russell's cloudapp_api gem:
#
#   gem install cloudapp_api
#
# Requires you set your CloudApp credentials in ~/.cloudapp as a simple file of:
#
#   email
#   password

require 'rubygems'
begin
  require 'cloudapp_api'
rescue LoadError
  puts "You need to install cloudapp_api: gem install cloudapp_api"
  exit!(1)
end

config_file = "#{ENV['HOME']}/.cloudapp"
unless File.exist?(config_file)
  puts "You need to type your email and password (one per line) into "+
       "`~/.cloudapp`"
  exit!(1)
end

email,password = File.read(config_file).split("\n")

class HTTParty::Response
  # Apparently HTTPOK.ok? IS NOT OKAY WTFFFFFFFFFFUUUUUUUUUUUUUU
  # LETS MONKEY PATCH IT I FEEL OKAY ABOUT IT
  def ok? ; true end
end

if ARGV[0].nil?
   puts "You need to specify a file to upload."
   exit!(1)
elsif ARGV[0] == '-'
  if ARGV[1].nil?
    puts "You need to specify a filename for the input stream."
    puts "Example usage: echo \"Hello\" | cloudapp - hello.txt"
    exit!(1)
  end
  file = "/tmp/#{ARGV[1]}"
  f = open(file, File::CREAT | File::WRONLY | File::BINARY)
  f.write STDIN.read
  f.close
else
  file = ARGV[0]
end

CloudApp.authenticate(email,password)
url = CloudApp::Item.create(:upload, {:file => file}).url

# Say it for good measure.
puts "Uploaded to #{url}."

# Get the embed link.
url = "#{url}/#{file.split('/').last}"

# Copy it to your (Mac's) clipboard.
`echo '#{url}' | tr -d "\n" | pbcopy`
