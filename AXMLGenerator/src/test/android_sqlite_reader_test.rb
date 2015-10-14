require_relative '../main/android_sqlite_reader.rb'

sql = ASqliteReader.new
input_file = ARGV[0]
if input_file.length < 1 then
	puts 'No Input File provided.'
else
	sql.read_dml_file input_file
	sql.print_debug
end