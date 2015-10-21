require_relative '../main/regex_data_parser.rb'

num_args = ARGV.length

if num_args < 1 then
  puts 'No Input File provided.'
else
	parser = RegexParser.new 'config.ini'
	
	input_file = ARGV[0].strip
	puts 'Parsing input file: ' + input_file
	
  error_code = parser.parse_file input_file
	if error_code == 0 then
		puts input_file + ' successfully parsed for data.'
	else
		puts 'Error Code: ' + error_code.to_s
		if error_code == -1 then
			puts 'No Regex Patterns found to match.'
		end
		
		if error_code == 1 then
			puts 'Exception occurred during file parsing.'
		end
	end
  parser.print_debug
	
	if num_args > 2 then
		puts 'Generating Output File...' + output_file
		output_file = ARGV[1]
		write_mode = ARGV[2].gsub('-','')
		error_code = parser.write_data_to_xml_file output_file, write_mode
		
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
end