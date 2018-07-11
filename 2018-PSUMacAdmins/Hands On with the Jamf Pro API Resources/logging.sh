#!/bin/sh

# server and api information
jamfUser="api-write"
jamfPass="jamf1234"
jamfURL="https://psumacadmins.kc9wwh.net:8443/JSSResource"

# define log file location
logFile="$HOME/Library/Logs/api.log"

function logresult()	{
	if [ $? = 0 ] ; then
	  /bin/date "+%Y-%m-%d %H:%M:%S	$1" >> "$logFile"
	else
	  /bin/date "+%Y-%m-%d %H:%M:%S	$2" >> "$logFile"
	fi
}

# get XML for all categories
categoryXML=$( /usr/bin/curl \
--user "$jamfUser:$jamfPass" \
--header "Accept: text/xml" \
$jamfURL/categories )

# get list of categories from XML
categoryList=$(/usr/bin/xmllint --format - <<< "$categoryXML" | awk -F "<name>|</name>" 'NF>1 { print $2 }' )

# test each category to see if it matches "Music"
while IFS= read aCategory
do
	echo "Testing $aCategory"
	[[ "$aCategory" = "Music" ]]
	logresult "Category matched Music" "Category DID NOT MATCH Music"
done <<< "$categoryList"

exit 0