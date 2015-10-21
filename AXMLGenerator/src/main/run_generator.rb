require_relative 'android_activity_generator.rb'

#Indicates if insufficient arguments have been provided
if ARGV.nil? || ARGV.count < 4 then
	puts "Insufficient arguments provided."
	exit
else
	target = ''
	output = ''
	template = ''
	numArgs = ARGV.count
	
	for i in 0..numArgs - 1
		case ARGV[i]
		#when '-b'
			#Generate classes based on provided batch file
			#bBatch = 1
		when '-f'
			#Generate a class based on a single input xml file
		else
			case i
			when 1
				target = ARGV[i]
			when 2
				output = ARGV[i]
			when 3
				template = ARGV[i]
			end
		end
	end
	
	generator = ActivityGenerator.new
	
	puts "Input file: " + target
	puts "Output File: " + output
	puts "Template File: " + template
	puts ''
	
	generator.load_template template
	generator.load_input_file target
	generator.generate_output_file output
end