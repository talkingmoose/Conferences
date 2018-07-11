#!/bin/sh

jamfUser="api-write"
jamfPass="jamf1234"
jamfURL="https://psumacadmins.kc9wwh.net:8443/JSSResource"

# get XML and status code
result=$( /usr/bin/curl \
--write-out "%{http_code}" \
--user "$jamfUser:$jamfPass" \
--header "Accept: text/xml" \
$jamfURL/buildings )

# get just the status code
resultStatus=${result: -3}

# get just the XML
resultXML=${result%???}

exit 0

