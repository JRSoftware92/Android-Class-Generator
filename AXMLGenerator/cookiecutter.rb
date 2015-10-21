#!/usr/bin/env ruby
#Ruby based Hub Program for interacting with Ruby CookieCutter Template Generation Tools.
require_relative 'src/main/ini_reader.rb'

INI_FILE = 'hub-config.ini'

def load_cmd_map(ini_file)
	ini = IniReader.new ini_file
	return ini.get_section_data 'commands'
end

#Retrieve the corresponding command line command based on the provided cookie cutter command
def get_program_from_cmd(cmd, map)
	if map.has_key? cmd then
		return map[cmd]
	else
		return ''
	end
end

#Runs the provided program with the given arguments
def run_command(cmd)
	return system cmd.strip
end

#Validates the number of arguments
num_args = ARGV.length
if num_args < 1 then
	puts 'No arguments provided. See documentation for more information on using CookieCutter.'
	exit
end

#Load the command map from the hub ini file
map = load_cmd_map INI_FILE

#Retrieves the corresponding program.
program = get_program_from_cmd ARGV[0], map

#Validates program.
if program.nil? || program.length < 1 then
	puts 'Invalid command provided: ' + ARGV[0]
	exit
end

#Validates provided arguments
args = []
if num_args > 1 then
	args = ARGV[1,num_args]
	cmd = program + ' ' + args.join(' ')
else
	cmd = program
end

#Attempts to run the command
success = false
if !cmd.nil? && cmd.length > 0 then
	success = run_command cmd
else
	puts 'Unexpected error has occurred with the provided command.'
	exit
end

#Indicates if the command ran safely
if !success then
	puts 'Error occurred while attempting to run the program: ' + cmd
end

