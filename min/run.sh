#!/usr/bin/with-contenv bashio

echo "Starting..."



echo "Reading config..."

CONFIG_PATH=/data/options.json

UPLINK_INTERFACE=$(jq --raw-output ".uplink_interface" $CONFIG_PATH)
AP_INTERFACE=$(jq --raw-output ".ap_interface" $CONFIG_PATH)
SSID=$(jq --raw-output ".ssid" $CONFIG_PATH)
WPA_PASSPHRASE=$(jq --raw-output ".wpa_passphrase" $CONFIG_PATH)
CHANNEL=$(jq --raw-output ".channel" $CONFIG_PATH)


# Enforces required env variables
required_vars=(UPLINK_INTERFACE AP_INTERFACE SSID WPA_PASSPHRASE CHANNEL)
error=0
for required_var in "${required_vars[@]}"; do
    if [[ -z ${!required_var} ]]; then
        error=1
        echo >&2 "Error: $required_var env variable not set."
    fi
done

if [[ $error -ne 0 ]]; then
    exit 1
fi


echo "Config seems valid."




echo "Creating shutdown handler..."

# SIGTERM-handler this funciton will be executed when the container receives the SIGTERM signal (when stopping)
term_handler(){
	echo "Stopping Access Point..."
    sleep 5
    create_ap --stop $AP_INTERFACE
    sleep 5

    echo "Cleaning up..."
    sleep 5
    ip link delete veth-ap
    sleep 5

    echo "Done."
	exit 0
}
# Setup signal handlers
trap 'term_handler' SIGTERM






echo "Removing $AP_INTERFACE from networkmanager"
nmcli dev set $AP_INTERFACE managed no





# Setup hostapd.conf
echo "Setting hostapd config..."
echo "ssid=$SSID"$'\n' >> /hostapd.conf
echo "wpa_passphrase=$WPA_PASSPHRASE"$'\n' >> /hostapd.conf
echo "channel=$CHANNEL"$'\n' >> /hostapd.conf




# Setup virtual interface
echo "Downloading create_ap script ..."

cd /
git clone https://github.com/oblique/create_ap

echo "Making create_ap script ..."
cd create_ap
make install




#echo "Creating virtual interface..."
#ip link add link \
#$UPLINK_INTERFACE \
#name veth-ap \
#addr 00:01:02:aa:bb:cc \
#type veth

#ip link set veth-ap up


echo "Starting Access Point..."

create_ap \
-m bridge \
-c $CHANNEL \
--no-haveged \
--hostapd-debug 2 \
--fix-unmanaged \
$AP_INTERFACE \
$UPLINK_INTERFACE \
$SSID \
$WPA_PASSPHRASE 
#--no-virt \
# --daemon --logfile log.txt 
#--driver nl80211 \