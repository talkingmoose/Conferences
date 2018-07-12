#!/bin/sh

# server information
jamfUser="api-write"
jamfPass="jamf1234"
jamfURL="https://psumacadmins.kc9wwh.net:8443/JSSResource"

# human-readable POST XML for a new search
theXML="<advanced_computer_search>
		<name>Mobile Devices with no asset tags as of $( /bin/date )</name>
		<criteria>
			<criterion>
				<name>Asset Tag</name>
				<priority>0</priority>
				<and_or>and</and_or>
				<search_type>is</search_type>
				<value></value>
			</criterion>
		</criteria>
		<display_fields>
			<display_field>
				<name>Serial Number</name>
			</display_field>
		</display_fields>
	</advanced_computer_search>"

# this strips the returns before POSTing the XML
postXML=$( /usr/bin/xmllint --noblanks - <<< "$theXML" )

# create a temporary advanced computer search in Jamf Pro using the criteria in the POST XML above
createSearch=$( /usr/bin/curl \
--silent \
--user "$jamfUser:$jamfPass" \
--header "Content-Type: text/xml" \
--request POST \
--data "$postXML" \
"$jamfURL/advancedcomputersearches/id/0" )

# get temporary advanced computer search ID
searchID=$( /bin/echo $createSearch | /usr/bin/awk -F "<id>|</id>" '{ print $2 }' )

# run the search and return serial numbers
runSearch=$( /usr/bin/curl \
--silent \
--user "$jamfUser:$jamfPass" \
--header "Accept: text/xml" \
"$jamfURL/advancedcomputersearches/id/$searchID" )

computerList=$( /usr/bin/xmllint --format - <<< "$runSearch" | awk -F "<Computer_Name>|</Computer_Name>" 'NF > 1 { print $2 }' )

echo "$computerList"

# delete the temporary advanced computer search
result=$( /usr/bin/curl \
--silent \
--user "$jamfUser:$jamfPass" \
--request DELETE \
"$jamfURL/advancedcomputersearches/id/$searchID" )

exit 0