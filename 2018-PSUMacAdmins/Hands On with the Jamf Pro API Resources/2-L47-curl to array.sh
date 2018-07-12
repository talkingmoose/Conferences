#!/bin/bash

jamfUser="api-write"
jamfPass="jamf1234"
jamfURL="https://psumacadmins.kc9wwh.net:8443/JSSResource"

deviceIDs=( $( /usr/bin/curl \
--user "$jamfUser":"$jamfPass" \
--header "Accept: text/xml" \
--request GET \
$jamfURL/computergroups/id/1 | \
/usr/bin/xpath "/computer_group/computers" | \
/usr/bin/xmllint --format - | \
/usr/bin/grep -e "<id>" | \
/usr/bin/awk -F "<id>|</id>" '{ print $2 }' ) )

echo ${deviceIDs[@]}
echo ${deviceIDs[0]}
echo ${deviceIDs[1]}
echo ${deviceIDs[2]}
echo ${deviceIDs[3]}
echo ${deviceIDs[4]}
echo ${deviceIDs[5]}
echo ${deviceIDs[6]}
echo ${deviceIDs[7]}
echo ${deviceIDs[8]}