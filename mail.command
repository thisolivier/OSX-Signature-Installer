#!/bin/bash
# Will replace an email signature with the template provided in the adjacent new.html file
# Echo's being used for readability
pwd
here="`dirname \"$0\"`"
echo "cd-ing to $here"
cd "$here" || exit 1
echo "-------------"
echo "Welcome to Olivier's email signature installer for OSX with iCloud"
echo "Tested on OSX 10.11 and 10.12"
echo "-------------"
echo "-------------"
echo "Please make sure you've made a new signature in the Mail app"
echo "The signature must contain only the word REPLACE (all caps)"
echo "Confirm you're ready to go by typing REPLACE below and pressing enter"
read CONFIRM
echo "-------------"
FILES=$(grep -l "REPLACE" ~/Library/Mobile\ Documents/com~apple~mail/data/V3/MailData/Signatures/* ~/Library/Mobile\ Documents/com~apple~mail/data/V4/Signatures/*)
echo $FILES
echo "-------------"
sed -i '' 's/<body.*//' "$FILES"
cat new.html >> "$FILES"
echo "All done now, you can quit me!"
