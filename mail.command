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
ALTDIR=""

# List of known locations for the apple mail signatures, as of Feb, 2017
DONE="NO"
CLOUDDIR="~/Library/Mobile\ Documents/com~apple~mail/data/V4/Signatures/ ~/Library/Mobile\ Documents/com~apple~mail/data/V3/MailData/Signatures/ ~/Library/Mobile\ Documents/com~apple~Mail/Data/MailData/Signatures/ ~/Library/Mobile\ Documents/Mail/Data/MailData/Signatures/"
LOCALDIR="~/Library/Mail/V4/MailData/Signatures/ ~/Library/Mail/V3/MailData/Signatures/ ~/Library/Mail/V2/MailData/Signatures/"
function testDirs {
  echo $1
  for TESTDIR in "$1"
    do
    if [ -d "$TESTDIR" ]; then
      cd "$TESTDIR"
      echo "Moving to $TESTDIR"

      #Adding a new signature to the registry file
      UNIQUEID=$(cat /dev/urandom | env LC_CTYPE=C tr -dc 'A-Z0-9' | fold -w 32 | head -n 1)
      UNIQUEID=$(echo ${UNIQUEID:0:8}-${UNIQUEID:8:4}-${UNIQUEID:12:4}-${UNIQUEID:16:4}-${UNIQUEID:20:12})
      echo "Our unique ID is" $UNIQUEID
      FORMAT=$(echo "<dict>    <key>SignatureIsRich<\/key><true\/>      <key>SignatureName<\/key><string>$NAME<\/string>      <key>SignatureUniqueId<\/key><string>$UNIQUEID<\/string>    <\/dict>")
      sed -i '.backup' "/<array>/ a\\
      $FORMAT" ./*.plist

      #Now to create the signature file
      UNIQUEID2=$(cat /dev/urandom | env LC_CTYPE=C tr -dc 'A-Z0-9' | fold -w 32 | head -n 1)
      UNIQUEID2=$(echo ${UNIQUEID2:0:8}-${UNIQUEID2:8:4}-${UNIQUEID2:12:4}-${UNIQUEID2:16:4}-${UNIQUEID2:20:12})
      touch "ubiquitous_$UNIQUEID.mailsignature"
      echo 'Content-Transfer-Encoding: 7bit' >> "ubiquitous_$UNIQUEID.mailsignature"
      echo 'Content-Type: text/html;' >> "ubiquitous_$UNIQUEID.mailsignature"
      echo '	charset=us-ascii' >> "ubiquitous_$UNIQUEID.mailsignature"
      echo "Message-Id: <$UNIQUEID2>" >> "ubiquitous_$UNIQUEID.mailsignature"
      echo 'Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))' >> "ubiquitous_$UNIQUEID.mailsignature"
      echo '' >> "ubiquitous_$UNIQUEID.mailsignature"
      echo $NEWSIG >> "ubiquitous_$UNIQUEID.mailsignature"
      DONE="YES"
    fi
  done
}
echo "Checking cloud directories"
testDirs $CLOUDDIR
if [ "$DONE" == "NO" ]; then
  echo "No cloud directories found, checking local directories."
  testDirs "LOCALDIR"
fi
if [ "$DONE" == "NO" ]; then
  echo "No directories matched, sad times."
fi

echo "-------------"
echo "All done, feel free to quit."
echo "-------------"
read BYE
