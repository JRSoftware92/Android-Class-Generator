require_relative 'android_activity_generator.rb'

#Reads the given batch file if possible and returns a multidimensional array (Nx3 where N is the number of Rows) of input, output, and template triplets.
def read_batch_file(filename)		
	#If the file name is invalid, exit prematurely
	if filename == nil || filename == "" then
		puts "Invalid filename provided."
		return []
	end
	begin
		puts "Loading: " + filename
		contents = []
		if File.exists? filename then
			file = File.open(filename, "r").each_line do |line|
				contents.push(line.split(":"))
			end
		end
	ensure
		puts "Closing Batch File: " + filename
		file.close unless file.nil?
	end
	
	puts "Done Loading Batch file."
	return contents
end

#Indicates if insufficient arguments have been provided
if ARGV.nil? || ARGV.count < 4 then
	puts "Insufficient arguments provided."
	exit
else
	target = ''
	output = ''
	template = ''
	numArgs = ARGV.count
	bBatch = 1
	
	for i in 0..numArgs - 1
		case ARGV[i]
		when '-b'
			#Generate classes based on provided batch file
			bBatch = 1
		when '-f'
			#Generate a class based on a single input xml file
			bBatch = 0
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
	
	#Reads directories for files
	if bBatch > 0 then
		batches = read_batch_file target
		batches.each do |batch|
			generator.load_template batch[2]
			generator.load_input_file batch[0]
			generator.generate_output_file batch[1]
		end
	else
		generator.load_template template
		generator.load_input_file target
		generator.generate_output_file output
	end
end