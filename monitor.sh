#!/bin/bash
PATH=/usr/local/bin:/usr/local/sbin:~/bin:/usr/bin:/bin:/usr/sbin:/sbin

# this script uses the Pushover app to send notifications. See https://pushover.net for more information and to get your username and token.
token="insert_your_token_here"
user="insert_your_user_id_here"

#Change according to your wishes
vps_name="MN1"
load_treshold="10"
notification_treshold="1" # when more than this nr of mn's on the same vps are offline, send Pushover notification

count=0

if  [[ $(darkpaycoin-cli -datadir=/root/.darkpaycoin masternode status 2>&1 | grep error | wc -l) != "0" ]] ; then
    count=$((count + 1))
fi

for i in {1..17}
do
    if  [[ $(darkpaycoin-cli -datadir=/root/.darkpaycoin$i masternode status 2>&1 | grep error | wc -l) != "0" ]] ; then
        count=$((count + 1))
    fi
done

load=$(cat /proc/loadavg | awk '{$1=$1};1' | cut -d " " -f 2)
load_int=$(echo $load | cut -d . -f 1)
message=""

if [[ "$load_int" -gt "$load_treshold" ]]; then
	message="VPS $vps_name has had an average load of $load for the last 5 minutes"
fi

if [[ "$count" -gt "$notification_treshold" ]]; then
    message="$message
VPS $vps_name has $count activated mn's offline"
fi

if [[ -n "$message" ]]; then
    curl -s --form-string "token=$token" --form-string "user=$user" --form-string "message=$message" https://api.pushover.net/1/messages.json
fi
