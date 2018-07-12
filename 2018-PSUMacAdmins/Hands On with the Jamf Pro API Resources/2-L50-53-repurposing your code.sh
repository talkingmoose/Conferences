#!/bin/bash

jamfUser="api-write"
jamfPass="jamf1234"
jamfURL="https://psumacadmins.kc9wwh.net:8443/JSSResource"
mobileGroupID="5"
lostModeMsg="Please return this device to Acme Schools ASAP"
lostModePhone="555-211-0101"

deviceIDs=( $( /usr/bin/curl --user "$jamfUser":"$jamfPass" \
--header "Accept: text/xml" \
--request GET \
$jamfURL/mobiledevicegroups/id/$mobileGroupID | \
/usr/bin/xpath "/mobile_device_group/mobile_devices" | \
/usr/bin/xmllint --format - | \
/usr/bin/grep -e "<id>" | \
/usr/bin/awk -F "<id>|</id>" '{ print $2 }' ) )

for i in ${deviceIDs[@]}; do
	xmlData="<mobile_device_command>
		<general>
			<command>EnableLostMode</command>
			<lost_mode_message>$lostModeMsg</lost_mode_message>
			<lost_mode_phone>$lostModePhone</lost_mode_phone>
		</general>
		<mobile_devices>
			<mobile_device>
				<id>$i</id>
			</mobile_device>
		</mobile_devices>
	</mobile_device_command>"
	echo "Sending EnableLostMode Command to Device ID: $i..."
	/usr/bin/curl --user "$jamfUser":"$jamfPass" \
	--header "Content-Type: text/xml" \
	--request POST \
	--data "$xmlData" \
	$jamfURL/mobiledevicecommands/command/EnableLostMode
done

echo $?