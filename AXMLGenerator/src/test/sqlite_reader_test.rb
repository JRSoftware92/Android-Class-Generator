require_relative '../main/sqlite_reader.rb'

sql = SqliteParser.new
query_file = ARGV[0]
if query_file.nil? || query_file.length < 1 then
	puts 'No Query File Provided.'
else
	query = nil
	File.foreach(query_file) do |line|
		if query.nil? then
			query = line.strip
		else
			query += ' ' + line.strip
		end
	end
	
	if !query.nil? then
		temp = sql.extract_parameters_from query
		puts 'Query: '
		puts query
		puts ''
		
		puts 'Parameters: '
		puts temp.to_s
	end
end