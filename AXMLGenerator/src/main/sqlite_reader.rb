require 'rubygems'
require 'sql-parser'

# Used for parsing sqlite data from a file
# Create method to detect any parametric args (x=?)
class SqliteParser

	REGEX_PARAMETRIC_ARG = /([a-zA-Z0-9_]+)\s*(?:[!=<>]{1,2}|IN{1}|in{1})\s*[?]{1}/

	def initialize
		@parser = SQLParser::Parser.new
		@root = nil
	end
	
	#Retrieves all parametric statements from the sql query string
	def extract_parameters_from(str)
		if str.nil? || str.length < 1 then
			return []
		end
		
		matchdata = str.scan REGEX_PARAMETRIC_ARG
		if matchdata.nil? then
			return []
		else
			list = []
			matchdata.each do |arr|
				list += arr
			end
			return list
		end
	end
	
	#Parses a given line into a sql syntax tree
	def parse_sql_tree(str)
		if str.nil? || str.size < 1 then
			return nil
		else
			@root = @parser.scan_str str
			return @root
		end
	end
	
	#Parses a file for the first sql expression
	def parse_input_file(file)
		if file.nil? || file.size < 1 then
			return nil
		else
			query = nil
			File.foreach(file) do |line|
				if query.nil? then
					query = line.strip
				else
					query += ' ' + line.strip
				end
			end
			
			@query = query
			
			return parse_sql_tree query
		end
	end
	
	#Retrieve query expression object
	def query_expression_of(ast)
		if ast.nil? || ast.query_expression.nil? then
			return nil
		else
			return ast.query_expression
		end
	end
	
	#Retrieve table expression object
	def table_expression_of(ast)
		query = query_expression_of ast
		if query.nil? then
			return nil
		else
			return query.table_expression
		end
	end
	
	#Returns the selected arguments of the provided sql ast
	def selected_columns_of(ast)
		query = query_expression_of ast
		if query.nil? then
			return nil
		else
			output = query.list
			return output.nil? ? nil : output.to_sql.gsub('`', '')
		end
	end
	
	#Returns the where clause of the provided sql ast
	def where_clause_of(ast)
		query = table_expression_of ast
		if query.nil? then
			return nil
		else
			output = query.where_clause
			return output.nil? ? nil : output.to_sql.gsub('`', '')
		end
	end
	
	#Returns the from clause of the provided sql ast
	def from_clause_of(ast)
		query = table_expression_of ast
		if query.nil? then
			return nil
		else
			output = query.from_clause
			return output.nil? ? nil : output.to_sql.gsub('`', '')
		end
	end
	
	#Returns the string group by clause of the provided sql ast
	def group_by_clause_of(ast)
		query = table_expression_of ast
		if query.nil? then
			return nil
		else
			output = query.group_by_clause
			return output.nil? ? nil : output.to_sql.gsub('`', '')
		end
	end
	
	#Returns the string having clause of the provided sql ast
	def having_clause_of(ast)
		query = table_expression_of ast
		if query.nil? then
			return nil
		else
			output = query.having_clause
			return output.nil? ? '' : output.to_sql.gsub('`', '')
		end
	end
	
	#Returns the string order by clause of the provided sql ast
	def order_by_clause_of(ast)
		if ast.nil? then
			return nil
		else
			output = ast.order_by
			return output.nil? ? '' : output.to_sql.gsub('`', '')
		end
	end
	
	#Convert sql ast to sql query string
	def tree_to_str(ast)
		query = table_expression_of ast
		if query.nil? then
			return nil
		else
			return query.to_sql.gsub('`', '')
		end
	end
	
	#Returns all search conditions found in belonging a sql string.
	def all_search_conditions_of(str)
		list = []
		
		begin
			#puts 'Extracting from: ' + str
			#Scan string for ast
			ast = @parser.scan_str str
		
			#puts 'Getting table expression of: ' + ast.to_sql
			#Get table Expression of ast
			query = table_expression_of ast
		
			#Node is null, return an empty list
			if query.nil? then
				return list
			else
				where = query.where_clause
				having = query.having_clause
			end
		
			list += search_conditions_of where
			list += search_conditions_of having
			
			#TODO Add Join functionality
			
		rescue Exception => e
			puts 'An error has occurred: ' + e.to_s
		end
		
		return list
	end
	
	#Return left and right search conditions of a given join, where, or having clause node
	#FIXME Does not retrieve more than two conditions
	#Could be achieved by creating sub parser specifically for conditional sql clauses (only needs to handle parenthesis, commas, identifiers, values, and operators)
	def search_conditions_of(node)
		if node.nil? || node.search_condition.nil? then
			return []
		end
		list = []
		
		search = node.search_condition
		begin
			puts 'Extracting from: ' + search.to_sql
			
			#Get Left and Right conditions
			left = search.left.to_sql
			right = search.right.to_sql
			
			#Extract Operator
			temp = search.to_sql.chomp(right)
			temp = temp.sub(left, '').gsub(/\s+/,'')
			op = temp
			
			list << left.gsub('`','')
			list << op
			list << right.gsub('`','')
		rescue ScanError => e
			#Scan Error
			puts 'Scan Error Caught: ' + e.to_s
		end
		
		return list
	end
	
	#Print debug information for this parser
	def print_debug
		begin
			temp = @query
			debug_print 'Query: ', temp
	
			temp = @root.to_sql
			debug_print 'Root: ', temp
		
			temp = selected_columns_of @root
			debug_print 'Columns: ', temp

			temp = from_clause_of @root
			debug_print 'From: ', temp
		
			temp = where_clause_of @root
			debug_print 'Where: ', temp
		
			temp = group_by_clause_of @root
			debug_print 'Group By: ', temp
		
			temp = having_clause_of @root
			debug_print 'Having: ', temp
		
			temp = order_by_clause_of @root
			debug_print 'Order By: ', temp
		
			temp = all_search_conditions_of @query
			debug_print 'Search Conditions: ', temp
		
		#Rescue any exceptions
		rescue Exception => e
			puts 'Error has occurred: ' + e.to_s
		end
	end
	
	def debug_print(name, object)
		puts name
		puts object.nil? ? '' : object.to_s
		puts '-------------------------------------------------------------------'
	end
end

