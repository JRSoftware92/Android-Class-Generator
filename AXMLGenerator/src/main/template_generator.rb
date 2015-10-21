
module TemplateGeneration

	TEMPLATE_DATA_KEY = 'Template_Data'
	REPEATABLE_SECTION = /\/{5,}(?<begin_or_end>begin|end):\s*(?<section_name>[a-zA-Z_]+)\<(?<section_source>[a-zA-Z_]+)\>/
	DEFAULT_PLACEHOLDER_REGEX = /~!~?(.+)~!~/
	
	#TODO FIX VALUE MAPPING (make sure to account for subsections --> Indicate data source in section tags)
	class SectionNode
	
		def initialize(section_content = [])
			@content = section_content
			
			scan_for_sub_sections
		end
		
		def content
			return @content
		end
		
		def children
			return @children
		end
		
		def leaf?
			return @children.nil? || @children.length < 1
		end
		
		def parent?
			return !@children.nil? && @children.length > 0
		end
		
		def valid?
			return !@content.nil? && @content.length > 0
		end
		
		#Generates an output array based on the data mapping provided
		def generate_from(map)
		
			if @content.nil? || @content.length < 1 then
				return []
			end
			
			if map.nil? || map.size < 1 then
				return @content
			end
			
			output = []
			
			@content.each do |line|
				#Handle subsections
				matchdata = REPEATABLE_SECTION.match line
				subsection_found = 0
				subsection_data = {}
				
				#Found a subsection marker
				if !matchdata.nil?  && matchdata.size > 0 then
					keys = matchdata.names
					if !keys.nil? && keys.length > 1 then
						begin_or_end = matchdata['begin_or_end']
						section_name = matchdata['section_name']
						section_source = matchdata['section_source']
						
						subsection_data = map[section_source]
						
						#If found a begin tag, and haven't found one previously
						if begin_or_end == 'begin' && subsection_found == 0 then
							#Retrieve the corresponding subsection data
							subsection = @children[section_name]
							subsection_found = 1
							subsection_name = section_name
						end
							
						#If found an end tag after a begin tag belonging to the correct subsection name
						if begin_or_end == 'end'  && subsection_found > 0 && subsection_name == section_name then
							#Recursively generate subsections
							output += subsection.generate_from map
							subsection_found = 0
						end
					end
				else
					#If not currently working on a subsection
					if subsection_found = 0 then
						#Handle value substitution
						matchdata = DEFAULT_PLACEHOLDER_REGEX.match line
						if matchdata.nil? then
							#Not a match --> normal template line
							output << line
						else
							#Match found --> Substitute values into the line
							temp_line = line
							keys = matchdata.names
							keys.each do |key|
								if subsection_data.key? key then
									#Substitutes each key into the line
									temp_line.sub!(DEFAULT_PLACEHOLDER_REGEX, subsection_data[key])
								end
							end
							#Output the line
							output << temp_line
						end
					end
				end
			end #content loop
			
			return output
		end
		
		#Scans the content array for subsection nodes
		def scan_for_sub_sections
			if @content.nil? || @content.size < 1 then
				return -1
			end
			
			@content.each do |line|
				matchdata = REPEATABLE_SECTION.match line
				subsection = []
				subsection_found = 0
				
				if matchdata.nil?  || matchdata.size < 1 then
					subsection << line
				else
					#Initializes children array if necessary
					if @children.nil? then
						@children = {}
					end
					
					captures = matchdata.names
					if !captures.nil? && captures.size > 1 then
						begin_or_end = matchdata['begin_or_end']
						section_name = matchdata['section_name']
						
						#If found a begin tag, and haven't found one previously
						if begin_or_end == 'begin' && subsection_found == 0 then
							subsection = []
							subsection_found = 1
							subsection_name = section_name
						else
							subsection << line
						end
							
						#If found an end tag after a begin tag belonging to the correct subsection name
						if begin_or_end == 'end'  && subsection_found > 0 && subsection_name == section_name then
							@children[section_name] = SectionNode.new(subsection)
							subsection_found = 0
						else
							subsection << line
						end
					end
				end
			end
		end
		
		def print_debug
			if !@contents.nil? then
				puts 'Section Contents: '
				@contents.each do |line|
					puts line
				end
			else
				puts 'Section Contents Empty.'
			end
			
			if !@children.nil? then
				puts 'Children: '
				@children.each do |child|
					child.print_debug
				end
			end
			else
				puts 'No Children Found.'
		end
		
	end
	
	#Tree class for Section Nodes. Used for parsing and generating sections of a template
	class SectionTree
		
		def initialize(contents)
			@root = SectionNode.new contents
			@substitutions = {TEMPLATE_DATA_KEY => {}}
			
			scan_for_valid_keys
		end
		
		#Places value at the given key mapping
		def put_static_value(key, value)
			put_section_value(TEMPLATE_DATA_KEY, key, value)
		end
		
		def put_section_value(section_key, key, value)
			if @substitutions.has_key?(section_key) && is_valid_key?(key) > 0 then
				@substitutions[section_key][key] = value
			end
		end
	
		def get_static_value(key)
			return @substitutions[TEMPLATE_DATA_KEY].has_key?(key) ? @substitutions[key] : key
		end
		
		def get_section_value(section_key, key)
			if !@substitutions.has_key? section_key || !@substitutions[section_key].has_key? key
			return @substitutions[section_key][key]
		end
		
		def is_valid_key?(key)
			return !@valid_keys.nil? && !key.nil? && @valid_keys.include? key
		end
		
		def root
			return @root
		end
		
		def scan_for_valid_keys
			lines = @root.content
			
			lines.each do |line|
				matchdata = DEFAULT_PLACEHOLDER_REGEX.match line
				if !matchdata.nil? && matchdata.size > 0 then
					keys = matchdata.names
					if !keys.nil? && keys.size > 0 then
						keys.each do |key|
							if @valid_keys.nil? then
								@valid_keys = []
							end
							@valid_keys << key
						end
					end
				end
			end
		end
		
		#Returns a flattened, writable string representing the generation of the section.
		def flatten
			return @root.generate_from(@substitutions).join('\n')
		end
		
		def print_debug
			@root.print_debug
		end
		
	end

	#Generates an output file from a given input file and regular expression placeholder format. ONLY ONE KEY PER LINE
	class TemplateGenerator

		#Initializes the generator with the filename of the template file and the regex pattern of the placeholder values in the template.
		def initialize
			#@index = 0
			#@regex = regex
		end
	
		#Places value at the given key mapping
		def put(key, value)
			#if is_valid_key(key) > 0 then
				#@replacements[key] = value
			#end
			if !@section_tree.nil? then
				@section_tree.put(key, value)
			end
		end
	
		def get(key)
			if !@section_tree.nil? then
				return @section_tree.get key
			else
				return nil
			end
		end
	
		#Sets the placeholder regex pattern
		#OBSOLETE
		#def set_placeholder_pattern(str)
		#	@regex = str
		#end
	
		#Resets the file read
		def reset
			#@index = 0
			load_template @filename
		end
	
		#The number of lines in the file
		def line_count
			return @contents.nil? ? 0 : @contents.count
		end
	
		#Determines if the referenced key is valid
		#OBSOLETE
		#def is_valid_key(key)
		#	return !@valid_keys.nil? && !key.nil? && @valid_keys.include?(key) ? 1 : 0
		#end
	
		#OBSOLETE
		#def get_line_matchdata(index)
		#  if @contents.nil? || @contents.size < 1 then
		#		return ""
		#	end
		#	return @contents[index].match @regex
		#end
	
		#Writes the contents of the generator to the given file
		def write_contents(filename = "output.txt")
			begin
				puts "Writing contents to file: " + filename
				file = File.open(filename, 'w')
				
				#TODO Load data mappings from xml file into the section tree
				if !@section_tree.nil? then
					file.puts @section_tree.flatten
				end
				#size = line_count
				
				#for i in 0..size-1
					#Retrieve the dirty key from the line
					#dirtyKey = get_line_matchdata(i).to_s
					#If the line contains a key
					#if !dirtyKey.nil? && @replacements.count > 0 then
						#puts "Dirty key: " + dirtyKey
						#if @dirty_mappings.has_key? dirtyKey then
							#Retrieve the clean key from the dirty_mappings hash
							#cleanKey = @dirty_mappings[dirtyKey]
						
							#if is_valid_key(cleanKey) > 0 then
								#puts "Clean Key: " + cleanKey
								#Retrieve the substitution value from the replacements table
								#value = get cleanKey
						
								#Substitute the new value back into the content array
								#@contents[i] = @contents[i].gsub(dirtyKey, value.to_s)
							#end
						#end
					#end
				
					#Write the line to the file
					#file.puts @contents[i]
				end
			
			ensure
				puts "Closing output file: " + filename
				file.close unless file.nil?
			end
		
			puts ''
		end
	
		#Reads the template file into an array of strings
		def load_template(filename)
			@filename = filename
			@contents = []
			#@valid_keys = []
			#@dirty_mappings = {}
			#@replacements = {}
			i=0
		
			#If the file name is invalid, exit prematurely
			if filename == nil || filename == "" then
				puts "Invalid filename provided."
				return 0
			end
		
			begin
				if File.exists? filename then
					puts "Loading Template: " + filename
					file = File.open(filename, "r").each_line do |line|
						@contents.push line
					end
				end
				
				@section_tree = SectionTree.new @contents
			
				#size = line_count
			
				#Iterates over each line, remembering the line number
				#for i in 0..size-1
					#Extracts the keys from each line
					#matchdata = get_line_matchdata i
					#if !matchdata.nil? then
						#Accounts for all keys found in the template file
					
						#keys = matchdata.captures
						#if !keys.nil? && keys.size > 0 then
							#keys.each do |key|
								#@valid_keys.push(key.strip)
								#@dirty_mappings[matchdata.to_s] = key.strip
								#@replacements[key.strip] = matchdata.to_s
							#end
						#end
					#end
				#end
			ensure
				puts "Closing Template File: " + filename
				file.close unless file.nil?
			end
		
			puts ''
		end
	
		def print_debug
			puts "Contents: "
			puts @contents.to_s
			
			if !@section_tree.nil? then
				@section_tree.print_debug
			end
		
			#puts "Valid Keys: "
			#puts @valid_keys.to_s
		
			#puts "Key Trims: "
			#puts @dirty_mappings.to_s
		
			#puts "Substitution Values: "
			#puts @replacements.to_s
		end
	end
end