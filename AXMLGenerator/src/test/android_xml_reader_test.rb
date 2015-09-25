require_relative '../main/android_xml_reader.rb'

android_control_file = "res/android_controls.txt"
puts "Filename: " + android_control_file
xml = AXMLReader.new android_control_file

layout_file = ARGV[0]
if layout_file.length < 1 then
	puts 'No Layout File provided.'
else
	xml.read layout_file
	#xml.print_debug
	xml.print_debug_android
end