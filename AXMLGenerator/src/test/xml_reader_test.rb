require_relative '../main/xml_reader.rb'

xml = XMLReader.new
layout_file = ARGV[0]
if layout_file.length < 1 then
	puts 'No Layout File provided.'
else
	xml.read layout_file
	xml.print_debug
end