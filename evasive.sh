#!/bin/sh

echo $1 >> /var/log/evasive.log
sudo pfctl -q -t attackers -T add $1
