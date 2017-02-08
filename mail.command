#!/bin/bash
# Will replace an email signature with the template provided in the adjacent new.html file
# Echo's being used for readability
here="`dirname \"$0\"`"
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
echo "Checking directories"
echo "-------------"
DIRECTORIES=''
for TESTDIR in ~/Library/Mobile\ Documents/com~apple~mail/data/V3/MailData/Signatures/ ~/Library/Mobile\ Documents/com~apple~mail/data/V4/Signatures/ ~/Library/Mobile\ Documents/Mail/Data/MailData/Signatures/ ~/Library/Mail/V2/MailData/Signatures/ ~/Library/Mail/V3/MailData/Signatures/ ~/Library/Mail/V4/MailData/Signatures/
  do
  if [ -d "$TESTDIR" ]; then
    DIRECTORIES="$DIRECTORIES \"$TESTDIR\""
  fi
done
# can't use SED here, should use shell script raw
DIRECTORIES=$(sed 's/\bMobile/&\\/' "$DIRECTORIES")
echo $DIRECTORIES
echo "-------------"
echo "Looking for signature"
echo "-------------"
FILES=$(grep -l "REPLACE" $DIRECTORIES)
echo $FILES
echo "-------------"
echo "Inserting new signature"
echo "-------------"
# sed -i '' 's/<body.*//' "$FILES"
# cat new.html >> "$FILES"
# echo "All done now, you can quit me!"
