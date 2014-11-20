adb shell < adb_tcpdump.sh &
sleep 1
adb forward tcp:11233 tcp:11233
sleep 1
mkfifo /tmp/sharkfin
wireshark -k -i /tmp/sharkfin &
nc 127.0.0.1 11233 > /tmp/sharkfin
