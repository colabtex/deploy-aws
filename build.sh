#!/bin/bash
<<README
    The purpose of this script is to call the other scripts, thus making this a
    singularly contained application - the goal is to just be able to run
    something like {bash my_script} to set up as much as possible and run all
    the scripts required for this application to finish its task.
README
<<vardump
    As the name suggests, the variable {vardump} is not actually intended to 
    be referenced. For the most part, at least right now, it is just satisfying
    the requirement for the {read} command to have a destination var for STDIN
vardump

echo \
===============================================================================
echo ""
echo "This script will get you set up with your OS, Git, and AWS"
echo "(the entire project, including this script, is still a work in progress)"
echo ""
echo \
===============================================================================

# Walk the user through setting things up that have not yet been automated 
echo ""
cat os-setup-steps.txt
echo \
===============================================================================
echo "Follow the instructions above to set up the operating system"  
read -p "When finished, press enter" vardump
echo ""
cat git-setup-steps.txt
echo \
===============================================================================
echo "Follow the instructions above to set up Git" 
read -p "When finished, press enter" vardump
echo ""
echo "Manual setup phase complete"
echo "Running automated setup script..."
echo \
===============================================================================
# bash setup-aws.sh
echo "(uncomment line above when ready to actually run/test script)"
echo \
===============================================================================
echo "Automated setup script complete"

echo "Finally, deploying AWS"
read -p "Are you ready? Press enter to continue..." vardump
echo \
===============================================================================
# bash project.sh
echo "(uncomment line above when ready to actually run/test script)"
echo \
===============================================================================
echo "Automated deployment script complete"

echo "So... How'd we do?"