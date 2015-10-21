require_relative 'xml_reader.rb'
require_relative 'template_generator.rb'

module XMLTemplateGeneration

	#Parses data from XML Template Data and Template File
	class TemplateConverter < XMLReader
		
		def initialize(template_file)
			super
			
			@template = TemplateGenerator.new 
		end	
		
		def read_data_file(file)
			read file
		
			object_sets = template_object_sets
			object_sets.each do |set|
				template_objects = extract_children_from set
				template_objects.each do |object|
					attributes = extract_children_from object
				end
			end
		end
	
		#Returns an array of all 'template_objects' nodes in the file
		def template_object_sets
			output = []
			set = xpath '//template_object_set'
			set.each do |node|
				output << node
			end
		
			return output
		end
	
		def print_debug
			object_sets = template_object_sets
			object_sets.each do |set|
				puts "\n\n"
				puts '------------------------------------------------------'
				puts 'Set: ' + attribute_value('name', set)
				template_objects = extract_children_from set
			
				puts '=================================='
				template_objects.each do |object|
					attributes = extract_children_from object
				
					if !attributes.nil? && attributes.length > 0 then
						puts '|||||||||||||||||||||||||||||||||||||||||||||||||||||||'
						puts 'Attributes: '
						attributes.each do |attr|
							if !attr.nil? && attr.to_xml.gsub(/\s+/, '') != '' then
								puts 'Attribute Name: ' + attribute_value('name', attr)
								puts 'Attribute Value: ' + attribute_value('value', attr)
							end
						end
						puts '|||||||||||||||||||||||||||||||||||||||||||||||||||||||'
					end

				end
				puts '=================================='
			end
			puts '-------------------------------------------------------------'
		end
	end
end