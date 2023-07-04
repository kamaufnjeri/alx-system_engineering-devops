#!/usr/bin/env ruby
#search school

puts ARGV[0].scan(/(?<=from:|to:|flags:).+(?=\])/).join(',')
