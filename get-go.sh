#!/bin/bash

RED="\033[1;31m"
RESET="\033[0m"

echo -e "${RED}[+] Installing the latest version of Go...${RESET}"
LATEST_GO=$(wget -qO- https://golang.org/dl/ | grep -oP 'go([0-9\.]+)\.linux-amd64\.tar\.gz' | head -n 1 | grep -oP 'go[0-9\.]+' | grep -oP '[0-9\.]+' | head -c -2)
wget https://dl.google.com/go/go$LATEST_GO.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go$LATEST_GO.linux-amd64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.profile
source ~/.profile
rm -rf go$LATEST_GO*
