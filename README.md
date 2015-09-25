# Android Xml to Java Class Generator

## Summary

This is a command line based Ruby utility which allows the user to specify their own Android template class file, and have it populated based on a corresponding XML layout file.
It utilizes regular expression capture groups to allow the user to specify custom placeholder formats for key-based value assignment.

## Command Line Format

ruby src/main/run_generation.rb [-f|-b] [INPUT_FILE] [OUTPUT_FILE] [TEMPLATE_FILE]
