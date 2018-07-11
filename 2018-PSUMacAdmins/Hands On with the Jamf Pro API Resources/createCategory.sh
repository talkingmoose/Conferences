#!/bin/sh

/usr/bin/curl \
--user "api-write:jamf1234" \
--header "Accept: text/xml" \
https://psumacadmins.kc9wwh.net:8443/JSSResource/buildings

exit 0
