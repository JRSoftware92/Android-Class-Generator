#!/usr/bin/env ruby
#Hub Program for interacting with CookieCutter

#Map of Cookie Cutter commands to program commands
CMD_PROG_MAP = { 'ini_test' => 'ruby ini_reader_test.rb'}

#Retrieve the corresponding command line command based on the provided cookie cutter command
def get_program_from_cmd(cmd)
	if CMD_PROG_MAP.has_key? cmd then
		return CMD_PROG_MAP[cmd]
	else
		return ''
	end
end

#Runs the provided program with the given arguments
def run_program(exe_file, args = [])
	str = exe_file + args.join(' ')
	return system str.strip
end

#Validates the number of arguments
num_args = ARGV.length
if num_args < 1 then
	puts 'No arguments provided. See documentation for more information on using CookieCutter.'
	exit
end

program = get_program_from_cmd ARGV[0]

if program.nil? || program.length < 1 then
	puts 'Invalid command provided: ' + ARGV[0]
	exit
end

args = []
success = false
if num_args > 1 then
	args = ARGV[1,num_args-1]
	success = run_program(program, args)
else
	success = run_program(program)
end

if !success then
	puts 'Error occurred while attempting to run the program: ' + program
end

