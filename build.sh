#!/bin/bash
<<README
    The purpose of this script is to call the other scripts, thus making this a
    singularly contained application - the goal is to just be able to run
    something like `bash my_script` to set up as much as possible and run all
    the scripts required for this application to finish its task.
README
<<vardump
    As the name suggests, the variable `vardump` is not actually intended to 
    be referenced. For the most part, at least right now, it is just satisfying
    the requirement for the `read` command to have a destination var for STDIN
vardump

# Walk the user through setting things up that have not yet been automated 
cat os-setup-steps.txt
echo \
"============================================================================="
read "Follow the instructions above to set up the operating system"  vardump
cat git-setup-steps2.txt
echo \
"============================================================================="
read -p "Follow the instructions above to set up Git" vardump
cat os-setup-steps.txt
echo \
"============================================================================="
read "Follow the instructions above to set up Git"

