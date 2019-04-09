#!/bin/bash

number=$(ls | grep darkpaycoin |wc -l)
number=$(($number-1))

cd /root

wget https://darkpaycoin.io/utils/dpc_fastsync.zip

echo "Updating N0"
service darkpaycoin stop
rm -R .darkpaycoin/blocks/ .darkpaycoin/chainstate/
rm .darkpaycoin/peers.dat
unzip dpc_fastsync.zip -d .darkpaycoin/

sed -i 's/addnode=136.243.185.4:6667/addnode=46.101.231.40:6667/' .darkpaycoin/darkpaycoin.conf
sed -i 's/addnode=46.101.231.40:6667/addnode=128.199.198.131:6667/' .darkpaycoin/darkpaycoin.conf
sed -i 's/addnode=67.99.220.116:6667/addnode=206.189.173.84:6667/' .darkpaycoin/darkpaycoin.conf
sed -i 's/addnode=206.189.173.84:6667/addnode=138.68.108.10:6667/' .darkpaycoin/darkpaycoin.conf

service darkpaycoin start

i=1
while [ "$i" -lt "$number" ]; do
    echo "Updating N$i"
    service darkpaycoin$i stop
    rm -R .darkpaycoin$i/blocks/ .darkpaycoin$i/chainstate/
    rm .darkpaycoin$i/peers.dat
    unzip dpc_fastsync.zip -d .darkpaycoin$i/

    sed -i 's/addnode=136.243.185.4:6667/addnode=46.101.231.40:6667/' .darkpaycoin$i/darkpaycoin.conf
    sed -i 's/addnode=46.101.231.40:6667/addnode=128.199.198.131:6667/' .darkpaycoin$i/darkpaycoin.conf
    sed -i 's/addnode=67.99.220.116:6667/addnode=206.189.173.84:6667/' .darkpaycoin$i/darkpaycoin.conf
    sed -i 's/addnode=206.189.173.84:6667/addnode=138.68.108.10:6667/' .darkpaycoin$i/darkpaycoin.conf

    service darkpaycoin$i start
    sleep 120
    i=$(($i + 1))
done
