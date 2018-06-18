#!/bin/bash

#Run this at your own peril.  Some of this is a little heavy to run on a Raspberry Pi,
#but can be useful in certain circumstances...

cd /root/scripts

echo "Installing Discover Script..."
git clone https://github.com/leebaird/discover.git
bash `pwd`/discover/update.sh

echo "Installing Lazy Script..."
git clone https://github.com/arismelachroinos/lscript
chmod +x `pwd`/lscript/install.sh
bash `pwd`/lscript/install.sh
