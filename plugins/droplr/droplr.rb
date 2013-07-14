#!/usr/bin/env ruby
#
# droplr
# Fabio Fernandes | http://fabiofl.me
#
# Use Droplr from the comand line to upload files and shorten links.
#
# Examples:
# 
# droplr ./path/to/file/
# droplr http://example.com
#
# This needs Droplr.app to be installed and loged in.
# Also, Mac only.

if ARGV[0].nil?
   puts "You need to specify a parameter."
   exit!(1)
end

if ARGV[0][%r{^http[|s]://}i]
	`osascript -e 'tell app "Droplr" to shorten "#{ARGV[0]}"'`
else
	`open -ga /Applications/Droplr.app "#{ARGV[0]}"`
end