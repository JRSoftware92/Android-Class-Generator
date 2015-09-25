require_relative 'xml_reader.rb'

#Class for reading Android XML Layout files
class AXMLReader < XMLReader
	
	def initialize(filename)
		super()
		
		@valid_controls = parse_android_control_file filename
	end	

	#Determines if the given type is a valid android type
	def valid_type(type)
		return @valid_controls.include? type
	end
	
	#Returns all of the android controls found in the xml document
	def android_controls
		return get_all_xpath @valid_controls
	end
	
	#Returns the android id of a given node
	def id_of(node = @current_node)
		id_value = attribute_value('id', node)
		
		if id_value.include?('/') then
			return attribute_value('id', node).split('/')[1]
		else
			return id_value
		end
	end
	
	#Returns the Android Element Type of the given node
	def android_type_of(node = @current_node)
		str = node.to_s
		if str.include? ' ' then
			str = str.split(' ')[0];
			str.delete! '<'
			str.delete! " "
			
			return str;
		else
			return nil
		end
	end
	
	#Returns a hash of element ids to their element type.
	def id_type_map
		#Exit prematurely if not valid
		if !is_valid then
			return Hash.new
		end
	
		controls = android_controls
		map = Hash.new
		
		if controls.nil? then
			return map
		end
		
		controls.each do |control|
			varId = id_of control
			varType = android_type_of control
			
			if varId != nil && varId != "" && varType != nil && varType != nil
				map[varId] = varType
			end
		end
		
		return map
	end
	
	#Returns a list of control events to be handled by the the class
	def event_list
		return attributes_by_name 'android:onClick'
	end
	
	
	#Parses a text file for android xml element names (to determine the names of valid controls)
	def parse_android_control_file(filename)
		#If the file name is invalid, exit prematurely
		if filename == nil || filename == "" then
			puts "Invalid filename provided."
			return 0
		end
		
		contents = []
		begin
			puts "Loading: " + filename
			if File.exists? filename then
				puts "File exists"
				file = File.open(filename, "r").each_line do |line|
					contents += line.gsub(/\s+/, "").split(",")
				end
			end
		ensure
			puts "Closing File: " + filename
			file.close unless file.nil?
		end
		
		puts "Done Reading file."
		return contents
	end
	
	#Print debug information for this class based on the current document
	def print_debug_android
	
		print_divider
		puts "Valid Control Types: "
		puts @valid_controls.to_s
	
		print_divider
		elements = android_controls
		puts "Android Controls: \n"
		
		if !elements.nil? then
			elements.each do |element|
				if !element.nil? then 
					puts 'Id: ' + id_of(element)
					puts 'Attributes: '
					puts element.keys.to_s
					#puts control.to_s
					puts ' '
				end
			end
		end
		
		print_divider 
		puts "Control by type test (return all buttons): "
		button = elements_by_type "Button"
		puts button.to_s
		
		print_divider 
		puts "Control Type test (should say button): "
		puts android_type_of button
		
		print_divider
		puts "Type Map Test (id => type): "
		puts id_type_map
		
		print_divider
		puts "On Click Event Test: "
		temp = event_list
		puts temp.to_s
		
		print_divider
		puts "Parent Validity: "
		puts is_valid
	end
	
end