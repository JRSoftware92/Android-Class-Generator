require_relative '../main/regex_data_parser.rb'

parser = RegexParser.new
parser.add_regex('Sqlite_Table', /(?<name>[a-zA-Z0-9_]+)\((?<parameters>(?:[\s,]*[a-zA-Z_]+\s*)+)(?:\);)/)

num_args = ARGV.length

if num_args < 1 then
  puts 'No Input File provided.'
else
	ddl_file = ARGV[0]
  parser.parse_file ddl_file
  parser.print_debug
	
	if num_args > 2 then
		output_file = ARGV[1]
		write_mode = ARGV[2].gsub('-','')
		parser.write_data_to_xml_file output_file, write_mode
	end
end