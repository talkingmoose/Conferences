#!/bin/bash

jamfUser="api-write"
jamfPass="jamf1234"
jamfURL="https://psumacadmins.kc9wwh.net:8443/JSSResource"

apiData=$( /usr/bin/curl --user "$jamfUser":"$jamfPass" \
--header "Accept: text/xml" \
--request GET \
$jamfURL/computergroups/id/1 )

/bin/echo $apiData
#/bin/echo $apiData | /usr/bin/xmllint --format -
#/bin/echo $apiData | /usr/bin/xmllint --format - | /usr/bin/xpath "/computer_group/computers"