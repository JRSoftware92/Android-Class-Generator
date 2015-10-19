require_relative '../main/android_sqlite_reader.rb'

sql = ASqliteReader.new
ddl_file = ARGV[0]
dml_file = ARGV[1]
if ddl_file.length < 1 then
	puts 'No Input File provided.'
else
	sql.read_ddl_file  ddl_file
	sql.read_dml_file dml_file
	sql.print_debug
end