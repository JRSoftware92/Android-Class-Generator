#!/usr/bin/env ruby

require_relative '../main/ini_reader.rb'

ini = IniReader.new
ini_file = ARGV[0]
if ini_file.length < 1 then
	puts 'No Layout File provided.'
else
	ini.read_file ini_file
	ini.print_debug
end