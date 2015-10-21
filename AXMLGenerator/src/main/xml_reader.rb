require 'rubygems'
require 'nokogiri'

#Class for reading an xml file
class XMLReader

	XPATH_JOIN=' | //'

	#Standard Constructor
	def initialize
		@doc = nil
		@current_node = nil
	end
	
	#Reads a file for an xml document
	def read(file)
		f = File.open file
		@doc = Nokogiri::XML(f)
		@current_node = @doc.root;
		f.close
	end
	
	#Returns true if the given node is valid
	def is_valid(node = @current_node)
		return node != nil
	end
	
	#Sets the current node.
	def set_current(node)
		@current_node = node
	end
	
	#Returns a set of nodes based on the provided xpath query
	def xpath(query)
		return is_valid ? @doc.xpath(query) : nil
	end
	
	#Returns a set of nodes with a type included in the provided array
	def get_all_xpath(values)
		if values.nil? then
			return []
		end
		return xpath('//' + values.join(XPATH_JOIN))
	end	
	
	#Returns a set of nodes based on the provided css query
	def css(query)
		return is_valid ? @doc.css(query) : nil
	end
	
	#Returns the root node of the current xml document
	def root
		return @doc == nil ? nil : @doc.root;
	end
	
	#Returns the line of the given node
	def line(node = @current_node)
		return is_valid(node) ? node.line : nil
	end
	
	#Returns an array of children of the current node
	def children
		return children_of @current_node
	end
	
	#Returns an array of children of the given parent node
	def children_of(node)
		return is_valid(node) ? node.children : nil
	end
	
	#Extract children from an object into an array. Intended for use with Node and NodeSet objects
	def extract_children_from(obj)
		if obj.nil? then
			return []
		end
		
		output = []
		set = obj.children
		set.each do |node|
			output << node
		end
		
		return output
	end
	
	#Returns the attribute keys of the current node
	def attr_keys
		return attr_keys_in @current_node
	end
	
	#Returns the attribute keys of the given node
	def attr_keys_in(node)
		return is_valid(node) ? node.keys : nil
	end
	
	#Returns a hash of attributes for the current node
	def attributes
		return attributes_of @current_node
	end
	
	#Returns a hash of attributes for a given node
	def attributes_of(node)
		map = Hash.new
		
		if !is_valid node then
			return map
		end
		
		varKeys = attr_keys_in node
		if !varKeys.nil? then
			varKeys.each do |key|
				map[key] = node[key]
			end
		end
		return map
	end
	
	#Returns the value of the given node attribute
	def attribute_value(key, node = @current_node)
		if is_valid(node) && node.key?(key) then
			return node.attribute(key).to_s
		else
			return ''
		end
	end
	
	#Returns the parent of the current node
	def parent
		return parent_of @current_node
	end
	
	#Returns the parent of the given node
	def parent_of node
		return is_valid(node) ? node.parent : nil
	end
	
	#Returns the previous element of the current node
	def prev_element
		return prev_element_of @current_node
	end

	#Returns the previous element of the given node
	def prev_element_of(node)
		return valid(node) ? node.previous_element : nil
	end
	
	#Returns the previous sibling of the current node
	def prev_sibling
		return prev_sibling_of @current_node
	end
	
	#Returns the previous sibling of the given node
	def prev_sibling_of(node)
		return valid(node) ? node.previous_sibling : nil
	end
	
	#Returns the next element of the current node
	def next_element
		return next_element_of @current_node
	end
	
	#Returns the next element of the given node
	def next_element_of(node)
		return valid(node) ? node.next_element : nil
	end
	
	#Returns the next sibling of the current node
	def next_sibling
		return next_sibling_of @current_node
	end
	
	#Returns the next sibling of the current node.
	def next_sibling_of(node)
		return valid(node) ? node.next_sibling : nil
	end
	
	#Yields current node and all children of the current node to block.
	def traverse(&block)
		traverse(@current_node, &block)
	end
	
	#Yields current node and all children of the current node to block.
	def traverse(node, &block)
		if valid(node)	then
			node.traverse(&block)
		end
	end
	
	#Returns set of elements by type
	def elements_by_type(type)
		return xpath('//' + type)
	end
	
	#Returns set of attributes by name
	def attributes_by_name(name)
		return xpath('//@' + name)
	end
	
	#Tests all of the data for the current node
	def print_debug
		print_divider
		puts "Root Node: \n" + root.to_s
		print_divider
		
		puts "Current Node: \n" + @current_node.to_s
		print_divider
		
		puts "Attributes: \n" + attributes.to_s
		print_divider
		
		puts "Children: \n" + children.to_xml
		print_divider
	end
	
	#Prints a horizontal line of '-' characters
	def print_divider
		puts "------------------------------------------------------------"
	end
end