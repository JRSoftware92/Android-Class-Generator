require_relative '../main/xml_template_generation.rb'

xml = XMLTemplateGeneration::TemplateConverter.new

num_args = ARGV.length

if num_args < 1 then
  puts 'No Input File provided.'
else
	xml_file = ARGV[0]
  xml.read xml_file
  xml.print_debug
end