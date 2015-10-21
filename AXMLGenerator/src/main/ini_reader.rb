#Ini File Reader class
#TODO Improve --> be able to handle strings properly
class IniReader

	SECTION = /^\s*\[(?<section_name>.+)\]\s*$/
	MAPPING = /(?<key>.+?)=(?<value>.+)/
	COMMENT = /^\s*;(?<comment>.+\s*$)/
	
	def initialize(ini_file = '')
		read_file ini_file
	end
	
	def data
		return @sections
	end
	
	def sections
		return @sections.keys
	end
	
	def comments
		return @comments
	end
	
	def get(section_key, key)
		if !@sections.has_key?(section_key) || !@sections[section_key].has_key?(key) then
			return ''
		else
			return @sections[section_key][key]
		end
	end
	
	def get_section_data(section_key)
		if !@sections.has_key? section_key then
			return {}
		else
			return @sections[section_key]
		end
	end
	
	def put(section_key, key, value)
		if @sections.has_key? section_key then
			@sections[section_key][key] = value
		end
	end
	
	def put_section(section_key)
		if !@sections.has_key?(section_key) then
			@sections[section_key] = {}
		end
	end
	
	def read_line(line)
		return read line
	end
	
	def read(line)
		if line =~ SECTION then
			matchdata = SECTION.match line
			@current_section = matchdata['section_name']
			put_section @current_section
			
			return 0
		else
			if line =~ MAPPING then
				matchdata = MAPPING.match line
				key = matchdata['key']
				value = matchdata['value']
				put(@current_section, key, value)

				return 0
			else
				if line =~ COMMENT then
					matchdata = COMMENT.match line
					@comments << matchdata['comment']
					
					return 0
				else
					return -1
				end
			end
		end
	end
	
	def read_file(file)
		@sections = {}
		@comments = []
		@current_section = ''
		
		if !file.nil? && file.length > 0 then
			File.foreach(file) do |line|
				read line
			end
		end

	end
	
	def print_debug
		if !@sections.nil? && @sections.size > 0 then
			@sections.each do |section_name, section_data|
				puts 'Section: ' + section_name
				section_data.each do |key, value|
					puts '--' + key + ' = ' + value
				end
				puts ''
			end
		end
		
		if !@comments.nil? && @comments.size > 0 then
			puts 'Comments: '
			@comments.each do |comment|
				puts '; ' + comment
			end
		end
	end

end