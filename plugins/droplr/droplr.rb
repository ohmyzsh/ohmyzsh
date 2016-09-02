#!/usr/bin/env ruby

if ARGV[0].nil?
   puts "You need to specify a parameter."
   exit!(1)
end

if ARGV[0][%r{^http[|s]://}i]
	`osascript -e 'tell app "Droplr" to shorten "#{ARGV[0]}"'`
else
	`open -ga /Applications/Droplr.app "#{ARGV[0]}"`
end
