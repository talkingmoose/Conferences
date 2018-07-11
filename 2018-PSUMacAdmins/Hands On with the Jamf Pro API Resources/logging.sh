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
result=$( /usr/bin/curl \
--write-out "%{http_code}" \
--user "$jamfUser:$jamfPass" \
--header "Accept: text/xml" \
"$jamfURL/categories" )

# get just the status code
resultStatus=${result: -3}

# get just the XML
resultXML=${result%???}

# get list of categories from XML
categoryXML=$( /usr/bin/xmllint --format - <<< "$resultXML" | awk -F "<name>|</name>" 'NF>1 { print $2 }' )

# test each category to see if it matches "Music"
while IFS= read aCategory
do
	[[ "$aCategory" = "Music" ]]
	logresult "Category matched Music" "Category DID NOT MATCH Music"
done <<< "$categoryXML"

exit 0