
#Generates an output file from a given input file and regular expression placeholder format. ONLY ONE KEY PER LINE
class TemplateGenerator

	#Initializes the generator with the filename of the template file and the regex pattern of the placeholder values in the template.
	def initialize(regex)
		@index = 0
		@regex = regex
	end
	
	#Places value at the given key mapping
	def put(key, value)
		if is_valid_key(key) > 0 then
			@replacements[key] = value
		end
	end
	
	def get(key)
		return @replacements.has_key?(key) ? @replacements[key] : key
	end
	
	#Sets the placeholder regex pattern
	def set_placeholder_pattern(str)
		@regex = str
	end
	
	#Resets the file read
	def reset
		@index = 0
		load_template @filename
	end
	
	#The number of lines in the file
	def line_count
		return @contents.nil? ? 0 : @contents.count
	end
	
	#Determines if the referenced key is valid
	def is_valid_key(key)
		return !@valid_keys.nil? && !key.nil? && @valid_keys.include?(key) ? 1 : 0
	end
	
	def get_line_matchdata(index)
		if @contents.nil? || @contents.size < 1 then
			return ""
		end
		return @contents[index].match @regex
	end
	
	#Writes the contents of the generator to the given file
	def write_contents(filename = "output.txt")
		puts "Writing file: " + filename
		begin
			file = File.open(filename, 'w')
			size = line_count
				
			for i in 0..size-1
				#Retrieve the dirty key from the line
				dirtyKey = get_line_matchdata(i).to_s
				#If the line contains a key
				if !dirtyKey.nil? && @replacements.count > 0 then
					#puts "Dirty key: " + dirtyKey
					if @dirty_mappings.has_key? dirtyKey then
						#Retrieve the clean key from the dirty_mappings hash
						cleanKey = @dirty_mappings[dirtyKey]
						
						if is_valid_key(cleanKey) > 0 then
							#puts "Clean Key: " + cleanKey
							#Retrieve the substitution value from the replacements table
							value = get cleanKey
						
							#Substitute the new value back into the content array
							@contents[i] = @contents[i].gsub(dirtyKey, value.to_s)
						end
					end
				end
				
				#Write the line to the file
				file.puts @contents[i]
			end
			
			puts "Contents written to file: " + filename
		ensure
			puts "Closing output file: " + filename
			file.close unless file.nil?
		end
		
		puts "Done Writing Output File."
	end
	
	#Reads the template file into an array of strings
	def load_template(filename)
		@filename = filename
		@contents = []
		@valid_keys = []
		@dirty_mappings = {}
		@replacements = {}
		i=0
		
		#If the file name is invalid, exit prematurely
		if filename == nil || filename == "" then
			puts "Invalid filename provided."
			return 0
		end
		
		begin
			puts "Loading: " + filename
			if File.exists? filename then
				file = File.open(filename, "r").each_line do |line|
					@contents.push line
				end
			end
			
			size = line_count
			
			puts "Detecting keys..."
			#Iterates over each line, remembering the line number
			for i in 0..size-1
				#Extracts the keys from each line
				matchdata = get_line_matchdata i
				if !matchdata.nil? then
					#Accounts for all keys found in the template file
					
					keys = matchdata.captures
					if !keys.nil? && keys.size > 0 then
						keys.each do |key|
							@valid_keys.push(key.strip)
							@dirty_mappings[matchdata.to_s] = key.strip
							@replacements[key.strip] = matchdata.to_s
						end
					end
				end
			end
		ensure
			puts "Closing Template File: " + filename
			file.close unless file.nil?
		end
		
		puts "Done Loading Template file."
	end
	
	def print_debug
		puts "Contents: "
		puts @contents.to_s
		
		puts "Valid Keys: "
		puts @valid_keys.to_s
		
		puts "Key Trims: "
		puts @dirty_mappings.to_s
		
		puts "Substitution Values: "
		puts @replacements.to_s
	end
end