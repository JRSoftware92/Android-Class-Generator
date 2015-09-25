require_relative 'template_generator.rb'
require_relative 'android_xml_reader.rb'

#Class for Generating Android Activity class files from Android XML Layouts
#FIXME Regex Capture Group not behaving as expected.
class ActivityGenerator < TemplateGenerator

	PLACEHOLDER_REGEX="~#~?(.+)~#~"
	FILENAME_REGEX="\w+_\w+\.xml"
	CONTROL_FILE="res/android_controls.txt"

	def initialize
		super(PLACEHOLDER_REGEX)
		@success = 0
	end
	
	#Loads the layout file to generate the class from
	def load_input_file(filename)
	
		puts "Loading input file: " + filename
	
		#Returns if filename if invalid
		if filename.nil? then
			puts "Invalid filename provided."
			return 0
		end

		puts "Matching class name and layout name..."
		#Extracts the name of the class from the filename
		arr = filename.split "_"
		if !arr.nil? && arr.size > 1 then
			@class_name = arr[0]
			if @class_name.include?("/") then
				temp = @class_name.split("/")
				@class_name = temp[1].capitalize
			end
			@layout_name = arr[1].gsub("_", "").gsub(".xml", "")
			
			puts "Class name: " + @class_name
			puts "Layout name: " + @layout_name
		else
			puts "Invalid layout file name: " + filename
		end
		
		puts "Reading input file: " + filename
		#Reads the xml of the input file
		reader = AXMLReader.new CONTROL_FILE
		reader.read filename
		
		puts "Retrieving ID Mappings..."
		#Retrieves a map of element ids to their corresponding class
		@id_map = reader.id_type_map
		@event_list = reader.event_list
		
		@success = 1
		
		puts "Input File Loaded."
	end
	
	#Generates an output with the desired filename
	def generate_output_file(filename = 'output.java')
		if @success > 0 then
			puts "Creating Substitution Mappings"
			put('HEADER', build_header)
			put('CLASS_NAME', @class_name)
			put('VARIABLES', build_variables)
			put('LAYOUT_NAME', @layout_name)
			put('INITIALIZATION', build_initialization)
			put('EVENT_METHODS', build_event_methods)
		end
		
		puts "Generating Output File: " + filename
		
		#Writes the adjusted contents to a file
		write_contents filename
		
		puts "File generated: " + filename
	end
	
	#Builds string for header import statements
	def build_header
		output = ""
		usedTypes = []
		@id_map.each do |id, type|
			#Avoids redundant import statements
			if !usedTypes.include? type then
				output += "import android.view." + type + ";\n"
				usedTypes.push type
			end
		end
		
		return output
	end
	
	#Builds string for instance variable declaration
	def build_variables
		output = ""
		@id_map.each do |id, type|
			output += "\t" + type + " " + id + " = null;\n"
		end
		
		return output
	end
	
	#Builds string for instance variable initialization
	def build_initialization
		output = ""
		
		#Exit prematurely if id map is not properly initialized
		if @id_map.nil? || !@id_map.is_a?(Hash) then
			return output
		end
		
		@id_map.each do |id, type|
			output += "\t\t" + id + " = (" + type + ") findViewById(R.id." + id + ");\n"
		end
		
		return output
	end
	
	#Build string for control event method generation
	def build_event_methods
		output = ""
		
		#Exit prematurely if id map is not properly initialized
		if @event_list.nil? then
			return output
		end
		
		@event_list.each do |name|
			output += "\tpublic void " + name + "(View v){\n\t\t/* TODO */\n\t}\n"
		end
		
		return output
	end
end