#!/bin/sh

/usr/bin/curl \
--user "api-write:jamf1234" \
--header "Content-Type: text/xml" \
--request POST \
--data "<category><name>Old Operating Systems</name></category>" \
https://psumacadmins.kc9wwh.net:8443/JSSResource/categories

exit 0