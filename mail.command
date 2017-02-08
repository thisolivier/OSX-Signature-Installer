#!/bin/bash
# Will replace an email signature with the template provided in the adjacent new.html file
# Echo's being used for readability
here="`dirname \"$0\"`"
cd "$here" || exit 1
NEWSIG=$(cat new.html)
echo "-------------"
echo "Welcome to Olivier's email signature installer for OSX"
echo "This tool will add a provided rich HTML signature to your Mail app."
echo "Please ensure your signature is stored in 'new.html' adjacent to this app."
echo "Tested on OSX 10.11 and 10.12"
echo "-------------"
echo ""
echo "-------------"
echo "Getting ready"
echo "-------------"
echo "Please type the name of your new signature, and press the return key."
read NAME
echo "-------------"
echo "Checking directories"
echo "-------------"
FILE=""
# List of known locations for the apple mail signatures, as of Feb, 2017
for TESTDIR in ~/Library/Mobile\ Documents/com~apple~mail/data/V3/MailData/Signatures/ ~/Library/Mobile\ Documents/com~apple~Mail/Data/MailData/Signatures/ ~/Library/Mobile\ Documents/com~apple~mail/data/V4/Signatures/ ~/Library/Mobile\ Documents/Mail/Data/MailData/Signatures/ ~/Library/Mail/V2/MailData/Signatures/ ~/Library/Mail/V3/MailData/Signatures/ ~/Library/Mail/V4/MailData/Signatures/
  do
  if [ -d "$TESTDIR" ]; then
    cd "$TESTDIR"
    echo "Moving to $TESTDIR"
    UNIQUEID=$(cat /dev/urandom | env LC_CTYPE=C tr -dc 'A-Z0-9' | fold -w 32 | head -n 1)

    UNIQUEID=$(echo ${UNIQUEID:0:8}-${UNIQUEID:8:4}-${UNIQUEID:12:4}-${UNIQUEID:16:4}-${UNIQUEID:20:12})
    echo $UNIQUEID
    FORMAT="    <dict>
      <key>SignatureIsRich</key>
      <true/>
      <key>SignatureName</key>
      <string>$NAME</string>
      <key>SignatureUniqueId</key>
      <string>$UNIQUEID</string>
    </dict>"
    #sed "/<array>/ a $INDEXCARD"
    break
  fi
done
if [ -z $FILE ]; then
  echo "-------------"
  echo "No signtures found, please send the record above to Olivier - olivier@olivier.uk"
  echo "-------------"
  read BYE
else
  echo "-------------"
  echo "Inserting new signature"
  echo "-------------"
  sed -i '' 's/<body.*//' "$FILE"
  echo $NEWSIG >> "$FILE"
  cat "$FILE"
  echo "-------------"
  echo "All done now, you can quit me!"
  echo "-------------"
  read BYE
fi
