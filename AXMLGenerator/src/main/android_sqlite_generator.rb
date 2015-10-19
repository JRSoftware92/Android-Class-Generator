require_relative 'template_generator.rb'
require_relative 'android_sqlite_reader.rb'

#Class for Generating Android Sqlite DB class files from SQL DML/DDL files
class SqlClassGenerator < TemplateGenerator

	PLACEHOLDER_REGEX="~#~?(.+)~#~"
	FILENAME_REGEX="\w+_\w+\.xml"
	
	def initialize
		super(PLACEHOLDER_REGEX)
		@success = 0
		set_database_name
		set_database_version
	end
	
	def set_database_name(dbName = 'app_db')
		@db_name = dbName
	end
	
	def set_database_version(dbVer = 1)
		@db_version = dbVer
	end
	
	#Loads the ddl file to generate the class from
	def load_ddl_file(filename)	
		#Returns if filename if invalid
		if filename.nil? then
			puts "Invalid filename provided."
			return 0
		end

		#Reads the sql of the input file
		@ddl_reader = ASqliteReader.new
		@ddl_reader.read_ddl_file filename
		
		@success = 1
	end
	
	#Loads the dml file to generate the class from
	def load_dml_file(filename)	
		#Returns if filename if invalid
		if filename.nil? then
			puts "Invalid filename provided."
			return 0
		end

		#Reads the sql of the input file
		@dml_reader = ASqliteReader.new
		@dml_reader.read_dml_file filename
		
		@success = 1
	end
	
	#Generates an output with the desired filename
	def generate_xml_query_file(filename = 'output.xml')
		if @success > 0 then
			puts "Creating Substitution Mappings"
			put('QUERIES', build_xml_arrays)
		end
		
		#Writes the adjusted contents to a file
		write_contents filename
		
		puts "File generated: " + filename
	end
	
	def generate_helper_class(classname = 'output')
		if @success > 0 then
			puts 'Creating Substitution Mappings'
			put('CLASS_NAME', classname)
			put('DATABASE_NAME', @db_name)
			put('DATABASE_VERSION', @db_version)
		end
		
		#Writes the adjusted contents to the appropriate files
		write_contents filename
		puts "File generated: " + filename + '.java'
		
	end
	
	def generate_adapter_class(classname = 'output')
		if @success > 0 then
			puts 'Creating Substitution Mappings'
			put('CLASS_NAME', classname)
		end
		
		#Writes the adjusted contents to the appropriate files
		write_contents filename
		puts "File generated: " + filename + '.java'
		
	end
	
	#Build String of XML Arrays
	def build_xml_arrays
		output = []
		
		tables = @ddl_reader.table_statements_xml
		if tables.size > 0 then
			output << '<array id="array_queries_table_create">'
			tables.each do |table|
				output << table
			end
			output << '</array>'
		end
		
		queries = @dml_reader.select_queries
		if queries.size > 0 then
			output << '<array id="array_queries_select">'
			queries.each do |query|
				output << query.to_xml
			end
			output << '</array>'
		end
		
		queries = @dml_reader.insert_queries
		if queries.size > 0 then
			output << '<array id="array_queries_insert">'
			queries.each do |query|
				output << query.to_xml
			end
			output << '</array>'
		end
		
		queries = @dml_reader.update_queries
		if queries.size > 0 then
			output << '<array id="array_queries_update">'
			queries.each do |query|
				output << query.to_xml
			end
			output << '</array>'
		end
		
		queries = @dml_reader.delete_queries
		if queries.size > 0 then
			output << '<array id="array_queries_delete">'
			queries.each do |query|
				output << query.to_xml
			end
			output << '</array>'
		end
		
		return output.join("\n")
	end

end