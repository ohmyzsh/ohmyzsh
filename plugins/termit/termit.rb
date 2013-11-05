#!/usr/bin/env ruby
#
# termit
# Pawel Urbanek / @pawurb
#
# Termit is an easy way to use Google Translate in your terminal.
#
# Usage:
# termit 'source_language' 'target_language' 'text'
#
# Example:
# termit en fr 'hey cowboy where is your horse?'
# => 'hey cow-boy ou est votre cheval?'
#
# Options:
# -t - speech synthesis
# -s - synonyms list
#
# Check docs at: github.com/pawurb/termit

require 'rubygems'

begin
  require 'termit'
rescue LoadError
  puts "You need to install termit: gem install termit"
  exit!(1)
end

begin
  options = Termit::UserInputParser.new(ARGV).options
  Termit::Main.new(options).translate
rescue Interrupt
  STDERR.puts "\nTermit: exiting due to user request"
  exit 130
end

