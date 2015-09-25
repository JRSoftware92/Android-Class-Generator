module AndroidUtils

	LAYOUT_FILE_REGEX="\w+_{1}\w+\.{1}\w+"


	#Returns the identifier portion of a layout file name string (or just the filename if it's not available)
	def layout_name(filename)
		if filename == LAYOUT_FILE_REGEX
			return filename.split('_')[1].split('.')[0]
		else
			return filename
		end
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

end