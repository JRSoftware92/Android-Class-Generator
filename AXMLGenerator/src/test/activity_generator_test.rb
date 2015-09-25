require_relative '../main/android_activity_generator.rb'

generator = ActivityGenerator.new
input_file = ARGV[0]
output_file = ARGV[1]
template_file = ARGV[2]

if ARGV.length < 3 then
	puts 'Not enough arguments provided.'
else
	generator.load_template template_file
	generator.load_input_file input_file
	generator.generate_output_file output_file
	generator.print_debug
end