require_relative 'regex_data_parser.rb'
require_relative 'ini_reader.rb'

if ARGV.nil? || ARGV.count < 2 then
	puts "Insufficient arguments provided."
	exit
else
	config_file = 'config.ini'
	input_file = ARGV[0].strip
	output_file = ARGV[1].strip
	
	parser = RegexParser.new config_file
	
	puts 'Reading Regex Parsable Input File: ' + input_file
	errorcode = parser.parse_file input_file
	
	if errorcode == 0 then
		puts 'Generated: ' + output_file
	else
		puts 'Error Code: ' + errorcode.to_s
		if errorcode == -1 then
			puts 'No Regex Patterns Found.'
		end
		
		if errorcode == 1 then
			puts 'Error occurred during file read.'
		end
		
		exit
	end
	
	puts 'Generating XML Template Data File...'
	errorcode = parser.write_data_to_xml_file(output_file, 'w')
	
	if errorcode == 0 then
		puts 'Generated: ' + output_file
	else
		puts 'Error Code: ' + errorcode.to_s
		if errorcode == -1 then
			puts 'No Data Mappings Found.'
		end
		
		if errorcode == 1 then
			puts 'IO Error occurred during file write.'
		end
	end
end