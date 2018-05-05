#!/bin/bash

echo "switching to correct node version"
echo

# nvm setup

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm


# switch node setup with nvm
nvm install v4.0.0

echo "---------------"
echo "installing bitcore dependencies"
echo

# use
nvm use v4.0.0

# install node
sudo apt-get -y install nodejs-legacy

# install zeromq
sudo apt-get -y install libzmq3-dev

echo "---------------"
echo "installing zelcash patched bitcore"
echo 
npm install zelcash/bitcore-node-zelcash

echo "---------------"
echo "setting up bitcore"
echo

# setup bitcore
./node_modules/bitcore-node-zelcash/bin/bitcore-node create zelcash-explorer

cd zelcash-explorer


echo "---------------"
echo "installing insight UI"
echo

../node_modules/bitcore-node-zelcash/bin/bitcore-node install zelcash/insight-api-zelcash zelcash/insight-ui-zelcash


echo "---------------"
echo "creating config files"
echo

# point safecoin at mainnet
cat << EOF > bitcore-node.json
{
  "network": "mainnet",
  "port": 3001,
  "services": [
    "bitcoind",
    "insight-api-zelcash",
    "insight-ui-zelcash",
    "web"
  ],
  "servicesConfig": {
    "bitcoind": {
      "spawn": {
        "datadir": "$HOME/.zelcash",
        "exec": "zelcashd"
      }
    },
     "insight-ui-zelcash": {
      "apiPrefix": "api"
     },
    "insight-api-zelcash": {
      "routePrefix": "api"
    }
  }
}
EOF

# create safecoin.conf
cd ~
mkdir .zelcash
touch .zelcash/zelcash.conf

cat << EOF > $HOME/.zelcash/zelcash.conf
server=1
whitelist=127.0.0.1
txindex=1
addressindex=1
timestampindex=1
spentindex=1
zmqpubrawtx=tcp://127.0.0.1:28769
zmqpubhashblock=tcp://127.0.0.1:28769
rpcallowip=127.0.0.1
rpcport=7201
rpcuser=User_name
rpcpassword=You_pass
uacomment=bitcore
showmetrics=0
maxconnections=1000
addnode=node.zel.cash
addnode=45.63.86.148
addnode=199.247.8.181
addnode=45.76.128.62
addnode=45.76.186.252

EOF


echo "---------------"
# start block explorer
echo "To start the block explorer, from within the zelcash-explorer directory issue the command:"
echo " nvm use v4; ./zelcash-explorer/node_modules/bitcore-node-zelcash/bin/bitcore-node start"