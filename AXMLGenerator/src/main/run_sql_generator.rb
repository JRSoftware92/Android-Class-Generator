require_relative 'android_sqlite_generator.rb'

#Indicates if insufficient arguments have been provided
if ARGV.nil? || ARGV.count < 4 then
	puts "Insufficient arguments provided."
	exit
else
	dml_input = ''
	ddl_input = ''
	output = ''
	template = ''
	numArgs = ARGV.count
	
	for i in 0..numArgs - 1
		case i
			when 0
				ddl_input = ARGV[i]
			when 1
				dml_input = ARGV[i]
			when 2
				output = ARGV[i]
			when 3
				template = ARGV[i]
		end
	end
	
	generator = SqlClassGenerator.new
	
	puts "DDL file: " + ddl_input
	puts "DML file: " + dml_input
	puts "Output File: " + output
	puts "Template File: " + template
	puts ''
	
	puts 'Loading Resource Template File...'
	generator.load_template template
	puts 'Loading DDL File...'
	generator.load_ddl_file ddl_input
	puts 'Loading DML File...'
	generator.load_dml_file dml_input
	puts 'Generating XML Output File...'
	generator.generate_xml_query_file output
	
	puts 'Finished.'
end