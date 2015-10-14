require_relative 'sqlite_reader.rb'
require_relative 'sqlite_model.rb'

#Class for reading DDL and DML SQLite files
#TODO Implement DDL Reading functionality (Columns, Tables)
class ASqliteReader < SqliteParser
	include Sqlite
	
	DDL_REGEX = /[a-zA-Z0-9_]+\({1}(?:[\s\,]*[a-zA-Z]+\s*)+(?:\)\;){1}/

	def initialize
		super
		@select_queries = []
		@insert_queries = []
		@update_queries = []
		@delete_queries = []
		@tables = []
	end
	
	#Reads in queries
	def read_ddl_file(filename)
		File.foreach(filename) do |line|
			extract_table_from line
		end
	end
	
	#Reads in queries
	def read_dml_file(filename)
		File.foreach(filename) do |line|
			extract_query_from line
		end
	end
	
	def extract_table_from(line)
		#TODO
	end
	
	#Extracts a Sqlite Query object from the sql string
	def extract_query_from(line)
		#Remove leading and trailing whitespace
		temp = line.upcase.strip
		#Retrieve the index of the name-query delimiter
		index = temp.index(':')
		
		if !index.nil? && index > -1 then
			#Function name of the query
			name = line[0,index]
			#SQLite query
			statement = line[index + 1, temp.length]
			#Parametric arguments of the query
			args = extract_parameters_from statement
			
			if statement.include? 'SELECT' then
				@select_queries << Sqlite::Query.new(name, statement, args, 'SELECT')
			end
			
			if statement.include? 'INSERT' then
				@insert_queries << Sqlite::Query.new(name, statement, args, 'INSERT')
			end
			
			if statement.include? 'UPDATE' then
				@update_queries << Sqlite::Query.new(name, statement, args, 'UPDATE')
			end
			
			if statement.include? 'DELETE' then
				@delete_queries << Sqlite::Query.new(name, statement, args, 'DELETE')
			end
		end
	end
	
	def queries
		return select_queries + insert_queries + update_queries + delete_queries
	end
	
	def select_queries
		return @select_queries
	end
	
	def select_queries_sql
		return objects_to_sql @select_queries
	end
	
	def select_queries_xml
		return objects_to_xml @select_queries
	end
	
	def insert_queries
		return @insert_queries
	end
	
	def insert_queries_sql
		return objects_to_sql @insert_queries
	end
	
	def insert_queries_xml
		return objects_to_xml @insert_queries
	end
	
	def update_queries
		return @update_queries
	end
	
	def update_queries_sql
		return objects_to_sql @update_queries
	end
	
	def update_queries_xml
		return objects_to_xml @update_queries
	end
	
	def delete_queries
		return @delete_queries
	end
	
	def delete_queries_sql
		return objects_to_sql @delete_queries
	end
	
	def delete_queries_xml
		return objects_to_xml @delete_queries
	end
	
	def tables
		return @tables
	end
	
	def table_statements_sql
		return objects_to_sql @tables
	end
	
	def table_statements_xml
		return objects_to_xml @tables
	end
	
	#Converts an array of query objects to an array of sql strings
	def objects_to_sql(objects)
		if objects.nil? || objects.size < 1 then
			return []
		end
	
		objects.each do |object|
			output << object.to_sql
		end
		
		return output
	end
	
	#Converts an array of query objects to an array of android xml string resources
	def objects_to_xml(objects)		
		if objects.nil? || objects.size < 1 then
			return []
		end
	
		objects.each do |object|
			output << object.to_xml
		end
		
		return output
	end
	
	def print_debug
		puts 'Queries: '
		temp = queries
		if !temp.nil? then
			temp.each do |query|
				query.print_debug
			end
		end
	end
end