
module Sqlite

	class Table
	
		def initialize(name, columns)
			@name = name
			@columns = columns
		end
		
		def to_s
			return to_sql
		end
	
		def to_sql
			return name + '(' + @columns.join(',') + ');'
		end
		
		def create_statement_sql
			return 'CREATE TABLE ' + to_sql
		end
		
		def create_statement_xml
			return '<string id="sql_create_' + name + '">' + create_statement_sql + '</string>'
		end
		
		def print_debug
			puts 'Name: ' + @name
			puts 'Columns: '
			puts @columns.to_s
			puts 'Statement: '
			puts to_sql
			puts 'XML: '
			puts to_xml
		end
	end
	
	class Query
	
		OPERATOR_REGEX = /[!=<>]{1,2}/
	
		def initialize(name, statement, args, query_type)
			@name = name
			@statement = statement
			@args = args
			@query_type = query_type
		end
		
		def name
			return @name
		end
		
		def parameters
			return @args
		end
		
		#TODO Need to track types --> handle this in parser.
		def java_parameters
			if @args.nil? || @args.size < 1 then
				return []
			end
			
			output = []
			@args.each do |arg|
				temp = @args.split OPERATOR_REGEX
				if !temp.nil? && temp.size > 1 then
					output << temp[0]
				end
			end
			
			return output
		end
		
		def to_s
			return @name + ': ' + @statement
		end
		
		def to_sql
			return @statement
		end
		
		def to_xml
			return '<string id="query_' + @name + '">' + @statement + '</string>'
		end
		
		def print_debug
			puts 'Name: ' + @name
			puts 'Type: ' + @query_type
			puts 'Args: '
			puts parameters.to_s
			puts 'Statement: '
			puts to_sql
			puts 'XML: '
			puts to_xml
		end
	end

end