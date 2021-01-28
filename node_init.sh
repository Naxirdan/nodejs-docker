#!/bin/bash

home="/home/node/"
app_dir="${home}app/"

source ${home}.bashrc

nvm install --lts && nvm use node

cd $app_dir

npm install

/usr/bin/node index.js