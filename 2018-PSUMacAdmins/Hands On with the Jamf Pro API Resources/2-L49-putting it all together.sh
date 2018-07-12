#!/bin/bash

jamfUser="api-write"
jamfPass="jamf1234"
jamfURL="https://psumacadmins.kc9wwh.net:8443/JSSResource"

deviceIDs=( $( /usr/bin/curl --user "$jamfUser":"$jamfPass" \
--header "Accept: text/xml" --request GET \
$jamfURL/computergroups/id/1 | \
/usr/bin/xpath "/computer_group/computers" | \
/usr/bin/xmllint --format - | /usr/bin/grep -e “<id>" | \
/usr/bin/awk -F "<id>|</id>" '{ print $2 }' ) )

for i in ${deviceIDs[@]}; do
echo "Deleting Computer ID: $i..."
/usr/bin/curl --user "$jamfUser":"$jamfPass" \
--header "Accept: text/xml" --request DELETE \
$jamfURL/computers/id/$i
done

exit
