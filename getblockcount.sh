#!/bin/bash

cd /root

number=$(ls | grep darkpaycoin | wc -l)
number=$(($number-1))

echo "N0"
darkpaycoin-cli -datadir=/root/.darkpaycoin getblockcount

i=1
while [ "$i" -lt "$number" ]; do
    echo "N$i"
    darkpaycoin-cli -datadir=/root/.darkpaycoin$i getblockcount
    i=$(($i + 1))
done
