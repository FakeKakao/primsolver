#!/usr/bin/ruby

require 'logger'
require 'optparse'
require_relative 'graph'

# FATAL, ERROR, WARN, INFO, DEBUG
$log.level = Logger::WARN
OptionParser.new do |opt|
    opt.on('-d', '--debug', 'Debug') {|o| $log.level = Logger::DEBUG}
end.parse!


puts "Graph algorithms. Ver.0.1"

input_content = $<.read

g = Graph.new(input_content)

puts "\nMinimum Spanning Tree:\n"
puts g.prim
