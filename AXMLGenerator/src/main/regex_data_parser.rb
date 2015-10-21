require_relative 'ini_reader.rb'

# Designed to take in a regex pattern with named capture groups and an input file, 
# parse the data based on the regex, and output the data as an xml file.
#TODO Fix parsing issue. Doesn't work with ddl file
class RegexParser

	#Initializes the RegexParser
	def initialize
		@regex_mappings = {}
	end
	
	#Ini file constructor
	def initialize(ini_file)
		read_ini ini_file
	end
	
	def add_regex(key, regex)
		#-1 If invalid key or value provided
		if key.nil? || regex.nil? then
			return -1
		end
		
		@regex_mappings[key] = regex
	end
	
	#Removes the regex mapping and returns the value if it exists. Returns -1 otherwise.
	def remove_regex(key)
		return @regex_mappings.delete(key) { |e| -1 }
	end
	
	#Loads regex mappings from an ini file
	def read_ini(ini_file)
		ini = IniReader.new ini_file
		section_data = ini.get_section_data 'regex'
		@regex_mappings = {}

		section_data.each do |name, regex|
			@regex_mappings[name] = Regexp.new(regex)
		end
	end
	
	#Parses file for data based on the provided regex.
	def parse_file(file)
	
		#Exit the method with an error code of -1 if the regex is null
		if @regex_mappings.nil? || @regex_mappings.empty? then
			return -1
		end
		
		begin
			#Traverses the file, scanning for data
			@data_mappings = {}
			File.foreach(file) do |line|
				#Assembles matchdata
				@regex_mappings.each do |obj_name, regex|
					matchdata = regex.match line.strip		#FIXME Crashing here
					if !matchdata.nil? then
						#Retrieves names of matched capture groups
						keys = matchdata.names
						if !keys.nil? then
							#Initializes mappings for this key
							if !@data_mappings.key? obj_name then
								@data_mappings[obj_name] = []
							end
						
							#Initializes the line data array
							line_data = []
							keys.each do |key|
								#Finds the value of each matched capture group on this line.
								value = matchdata[key]
								#Adds the mapping to the line data array
								line_data << [key, value]
							end
						
							#Maps the line data to the name of the regex being used
							@data_mappings[obj_name] << line_data
						end
					end
				end
			end
		rescue StandardError => e
			puts e.to_s
			return 1
		end
		
		return 0
	end
	
	#Writes the parsed data to an xml file given the provided filename and write type ('a' for append, 'w' for write).
	#Returns 0 if the write was successful.
	#Returns -1 if no data is available to write.
	#Returns 1 if an IO exception occurred while writing.
	def write_data_to_xml_file(filename, write_mode)
		
		#Exits prematurely if no data_mappings are found
		if @data_mappings.nil? || @data_mappings.size < 1 then
			return -1
		end
		
		#Initializes tags for template object root node
		template_data_open_str = "<template_data>\n"
		template_data_close_str = "</template_data>\n"
		
		#Initializes tags for template object
		template_object_open_str = "\t\t<template_object>\n"
		template_object_close_str = "\t\t</template_object>\n\n"
		
		#Initializes the template object xml close tag
		template_objects_close_str = "\t</template_object_set>\n\n"
		
		#Safely writes data to a file
		begin
			file = File.open(filename, write_mode)
			#Writes the template objects open tag
			file.write template_data_open_str
			
			#Iterates over object types
			@data_mappings.each do |object_type, object_array|
				#Initializes the template objects xml open tag
				template_objects_open_str = "\t<template_object_set name=\"#{object_type}\">\n"
				file.write template_objects_open_str
				#Iterates over each object
				object_array.each do |object|
					
					#Writes the object to the file
					file.write template_object_open_str
					#Iterates over each attribute
					object.each do |attribute_name, attribute_value|
						#Initializes the attribute xml tag
						#attribute_str = "\t\t\t<string name=\"#{attribute_name}\">#{attribute_value}</string>\n"
						attribute_str = "\t\t\t<string name=\"#{attribute_name}\" value=\"#{attribute_value}\">\n"
						#Writes the object attribute to the file
						file.write attribute_str
					end
					#Close the object being written
					file.write template_object_close_str
				end
				
				file.write template_objects_close_str
			end
			
			#Writes the template objects close tag
			file.write template_data_close_str
		rescue IOError => e
			puts e.to_s
			return 1
		end

		return 0
	end
	
	def print_debug
		puts 'Regex Mappings: '
		@regex_mappings.each do |object_name, object_regex|
			puts 'Object Name: ' + object_name
			puts 'Object Pattern: ' + object_regex.source
		end
		
		puts 'Parsed Data: '
		@data_mappings.each do |object_type, object_array|
			puts "-" + object_type + ":"
			puts ''
			object_array.each do |object|
				object.each do |attribute_name, attribute_value|
						puts "--" + attribute_name
						puts "---" + attribute_value
				end
				puts ''
			end
		end
	end
end