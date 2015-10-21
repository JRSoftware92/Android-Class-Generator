require_relative 'android_xml_reader.rb'
require_relative 'ini_reader.rb'

if ARGV.nil? || ARGV.count < 2 then
	puts "Insufficient arguments provided."
	exit
else
	ini = IniReader.new 'config.ini'
	
	control_file = ini.get('application', 'ANDROID_CONTROL_FILE')
	if control_file.nil? || control_file == '' then
		puts 'Android Control File not found.'
		exit
	else
		puts 'Android control file: ' + control_file	
	end
	
	input_file = ARGV[0]
	output_file = ARGV[1]
	
	xml = AXMLReader.new control_file
	
	puts 'Reading: ' + input_file
	xml.read input_file
	
	puts 'Generating layout output file...'
	xml.generate_layout_map_file output_file
	
	puts 'Generated: ' + output_file
end