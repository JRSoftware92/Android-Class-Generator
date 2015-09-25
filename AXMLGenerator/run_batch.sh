#!/bin/bash
#This program will generate a batch of android layout classes 
#based on their xml layout files and java class templates.
#Requires a batch file where each line has the syntax input:output:template
BATCH_FILE=/input/test_activity_batch.txt
ruby src/main/run_generation.rb -b $BATCH_FILE