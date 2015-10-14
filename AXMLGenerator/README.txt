This application is used to take android xml layout files and generate the appropriate Android Java classes for them.

The application works in both single file and batch mode. Single file mode will generate a class based on a single
Android xml layout file. Batch mode will check the designated batch file for triplets of input layout files, output class
files, and template files (of the format input:output:template). Each triplet must have its own line.

The syntax for non batch mode is ruby src/run_generation.rb -f [input file path] [output file path] [template file path]
	- This can also be accessed via the run_generation.sh script
The syntax for batch mode is ruby src/run_generation.rb -b [batch file]
	- This can also be accessed via the run_batch.sh script

CURRENTLY ONLY WORKS IN SINGLE FILE MODE. NO WORKING SHELL SCRIPTS.

MOST RECENT ADDITION: SQLite Adapter Generation