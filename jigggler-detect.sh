!/bin/bash 
# Mouse jiggler detector 
# Usage: jigggler-detect.sh <USB bus> <USB device address> 
# 
# Created by Dr. Phil Polstra for DEFCON 24 
usage (){ 
	echo "Usage: $0 <USB bus> <USB device address>" 
	echo "This script will attempt to detect a mouse" 
	echo "jiggler based on behavior." 
	exit 1 
}

if [ $# -lt 2 ]; then 
	usage 
fi

# mouse jigglers are normally 2-button mice 
# w/3-byte reports 
# use usbhid-dump to intercept reports and 
# check for 3 bytes 
# and no mouse clicks in two minutes 
# first check for the small report 

deviceaddress=$(printf "%03d:%03d" $1 $2) 
shortreport=$(timeout 1s usbhid-dump -a $deviceaddress -es \ | egrep "^ 00 00 00$" )

if [! -z "$shortreport" ]; then 
	echo "Found a possible mouse jiggler!" 
	# collect reports for 2 minutes 
	declare -a mousereports; declare -a notnullreports 
	mousereports=($(timeout 2m usbhid-dump -a $deviceaddress -es \ | egrep -v "^$deviceaddress" | egrep -v "^Terminated")) 
	# now check for clicks and small movement 
	count=0; notnullcount=0 
	while [ "x${mousereports[count]}"!= "x" ] 
	do 
	# if there was a single mouse click it is not a jiggler 
	if [ "x${mousereports[count]}"!= "x00" ]; then 
	echo "Not a jiggler after all" ; exit 0 
	fi 
	
	if [ "${mousereports[count+1]}"!= "00" ] || \ 
		[ "${mousereports[count+2]}"!= "00" ]; then 
		notnullreports[notnullcount]="${mousereports[count]}:" 
		notnullreports[notnullcount]+="${mousereports[count+1]}:" 
		notnullreports[notnullcount]+="${mousereports[count+2]}" 
	
		echo ${notnullreports[notnullcount]} 
		notnullcount=$(( $notnullcount + 1 )) 
	
	fi 
	
	count=$(( $count + 3 )) 
	
done 

echo "Found $notnullcount non-null mouse reports" 
# create a unique array 

declare -a uniquereports 
uniquereports=$(echo "${notNullReports[@]}" | \tr ' ' '\n' | sort -u | tr '\n' ' ') 

echo ${uniqueReports[@]}

# if any of these are exactly the same this is a jiggler 

if [ ${#uniqueReports[@]} -ne $notNullCount ];  
then 
	echo "We have a jiggler!" 
	exit 2
	
fi

else 
# check for the fancier MJ-3 which has 
# a 5-button 3-axis mouse and not a lot of noise 

shortreport=$(timeout 1m \ usbhid-dump -a $deviceaddress -es \ | egrep "^ 00 ([0-9A-F]{2} ){2}[0-9A-F]{2}$" ) 

if [! -z "$shortreport" ]; 
then 
	echo "Found possible MJ-3"
	declare -a mousereports 
	# we need to collect reports a bit longer since 
	# this one is not as chatty 
	mouseReports=($(timeout 4m \usbhid-dump -a $deviceAddress -es \| egrep -v "^$deviceAddress" | \egrep -v "^Terminated")) 
	
	count=0 
	
	while [ "x${mousereports[count]}"!= "x" ] 
	do 
	# if there was a single mouse click it is not a jiggler
	if [ "x${mousereports[count]}"!= "x00" ]; then 
	echo "Not a jiggler after all" 
	exit 0 
	
fi 

count=$(( $count + 4 )) 
done 

# if we made it this far this is definitely a jiggler 

echo "Fancy mouse jiggler found" 

else echo "No mouse jigglers here" 
exit 0 
fi 

fi

























