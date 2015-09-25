#!/bin/bash
#This program will generate an android layout class
#based on its xml layout file and java class template.
INPUT_FILE=/input/activity_test.xml
OUTPUT_FILE=/output/activity_test.java
TEMPLATE_FILE=/templates/ActivityTemplate.java
ruby src/main/run_generation.rb -f $INPUT_FILE $OUTPUT_FILE $TEMPLATE_FILE