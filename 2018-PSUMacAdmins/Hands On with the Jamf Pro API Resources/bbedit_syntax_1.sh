#!/bin/sh

while IFS= read aLine
do
	logFileName=$( /usr/bin/basename "$aLine" )
	/bin/rm "$aLine"
	logresult "Deleting old log file: $logFileName."
done <<< "$deleteOldLogs

# creating a list of computers without asset tags
logresult "Gathering list of computers without asset tags."

# human-readable POST XML for a new search
TEHxml="<advanced_mobile_device_search>
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
	</advanced_mobile_device_search>"

# this strips the returns before POSTing the XML
POSTxml=$( stripreturns "$TEHxml" )

# create a temporary advanced computer search in the JSS using the criteria in the POST XML above		
CREATESEARCH=$( /usr/bin/curl -k -s 0 $URL/JSSResource/advancedmobiledevicesearches/id/0 --user "$USERNAME:$PASSWORD" -H "Content-Type: text/xml" -X POST -d "$POSTxml" )

# log the result
logresult "Created temporary Advanced Mobile Device Search in JSS at $URL." "Failed creating temporary Advanced Mobile Device Search in JSS at $URL."

exit 0
