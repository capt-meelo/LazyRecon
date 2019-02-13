#!/bin/bash

WORKING_DIR=$(pwd)
TOOLS_PATH="$WORKING_DIR/tools"
WORDLIST_PATH="$WORKING_DIR/wordlists"
RED="\033[1;31m"
GREEN="\033[1;32m"
BLUE="\033[1;36m"
RESET="\033[0m"


installBanner(){
    name=$1
    echo -e "${RED}[+] Installing $name...${RESET}"
}


update(){
    echo -e "${GREEN}\n--==[ Setting things up ]==--${RESET}"
    echo -e "${RED}[+] Updating...${RESET}"
    sudo apt-get update -y
    sudo apt-get upgrade -y
    sudo apt-get autoremove -y
    sudo apt clean
}


createDir(){
    echo -e "${RED}[+] Creating directories...${RESET}"
    mkdir -p $TOOLS_PATH $WORDLIST_PATH
    echo -e "${BLUE}[*] $TOOLS_PATH${RESET}"
    echo -e "${BLUE}[*] $WORDLIST_PATH\n${RESET}"
}


setupTools(){
    installBanner "setup tools"
    sudo add-apt-repository ppa:canonical-chromium-builds/stage -y
    sudo apt update

    INSTALL_PKGS="golang git python python-pip python3 python3-pip libldns-dev gcc make libpcap-dev xsltproc curl chromium-browser chromium"
    for i in $INSTALL_PKGS; do
        sudo apt-get install -y $i
    done
}


subEnumTools(){
    echo -e "${GREEN}\n--==[ Installing subdomains enum tools ]==--${RESET}"
    installBanner "amass"
    if [ -e ~/go/bin/amass ]; then
        echo -e "${BLUE}[!] Amass already exists...\n${RESET}"
    else 
        go get -u -v github.com/OWASP/Amass/...
    fi
    
    installBanner "subfinder"
    if [ -e ~/go/bin/subfinder ]; then
        echo -e "${BLUE}[!] Subfinder already exists...\n${RESET}"
    else 
        go get -u -v github.com/subfinder/subfinder
        echo -e "${RED}[+] Setting API keys for subfinder...${RESET}"
        # Set your API keys here
        ~/go/bin/subfinder --set-config VirustotalAPIKey=
        ~/go/bin/subfinder --set-config PassivetotalUsername=,PassivetotalKey=
        ~/go/bin/subfinder --set-config SecurityTrailsKey=
        ~/go/bin/subfinder --set-config RiddlerEmail=,RiddlerPassword=
        ~/go/bin/subfinder --set-config CensysUsername=,CensysSecret=
        ~/go/bin/subfinder --set-config ShodanAPIKey=
    fi

    installBanner "subjack"
    if [ -e ~/go/bin/subjack ]; then
        echo -e "${BLUE}[!] Subjack already exists...${RESET}"
    else 
        go get -u -v github.com/haccer/subjack
    fi
}


ipEnumTools(){ 
    echo -e "${GREEN}\n--==[ Installing IP enum tools ]==--${RESET}"
    installBanner "massdns"
    cd $TOOLS_PATH
    git clone https://github.com/blechschmidt/massdns
    cd massdns
    make -j
    cd $WORKING_DIR
}


portScanTools(){
    echo -e "${GREEN}\n--==[ Installing port scanners ]==--${RESET}"
    installBanner "masscan"
    cd $TOOLS_PATH
    git clone https://github.com/robertdavidgraham/masscan
    cd masscan
    make -j
    cd $WORKING_DIR

    installBanner "nmap"
    LATEST_VERSION="7.70"
    wget https://nmap.org/dist/nmap-$LATEST_VERSION.tar.bz2
    bzip2 -cd nmap-$LATEST_VERSION.tar.bz2 | tar xvf -
    cd nmap-$LATEST_VERSION
    ./configure
    make -j
    sudo make install
    cd $WORKING_DIR
    rm -rf nmap-$LATEST_VERSION*
}


visualReconTools(){
    echo -e "${GREEN}\n--==[ Installing visual recon tools ]==--${RESET}"
    installBanner "aquatone"
    if [ -e ~/go/bin/aquatone ]; then
        echo -e "${BLUE}[!] Aquatone already exists...\n${RESET}"
    else 
        go get -u -v github.com/michenriksen/aquatone
    fi
}


dirBruteTools(){
    echo -e "${GREEN}\n--==[ Installing content discovery tools ]==--${RESET}"
    installBanner "gobuster"
    if [ -e ~/go/bin/gobuster ]; then
        echo -e "${BLUE}[!] Gobuster already exists...\n${RESET}"
    else 
        go get -u -v github.com/OJ/gobuster
    fi
    
    installBanner "dirsearch"
    cd $TOOLS_PATH
    git clone https://github.com/maurosoria/dirsearch
    cd $WORKING_DIR
}


otherTools(){
    echo -e "${GREEN}\n--==[ Downloading wordlists & other tools]==--${RESET}"
    echo -e "${RED}[+] Donwloading jhaddix's all.txt, content_discovery_all.txt & raft-large-words.txt...${RESET}"
    wget -O $WORDLIST_PATH/dns_all.txt https://gist.githubusercontent.com/jhaddix/86a06c5dc309d08580a018c66354a056/raw/96f4e51d96b2203f19f6381c8c545b278eaa0837/all.txt
    wget -O $WORDLIST_PATH/dir_all.txt https://gist.githubusercontent.com/jhaddix/b80ea67d85c13206125806f0828f4d10/raw/c81a34fe84731430741e0463eb6076129c20c4c0/content_discovery_all.txt
    wget -O $WORDLIST_PATH/raft-large-words.txt https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/raft-large-words.txt
    echo -e "${RED}[+] Donwloading honze-net's nmap-bootstrap-xsl...${RESET}"
    wget -O $TOOLS_PATH/nmap-bootstrap.xsl https://github.com/honze-net/nmap-bootstrap-xsl/raw/master/nmap-bootstrap.xsl
}


# Main function
update
createDir
setupTools
subEnumTools
ipEnumTools
portScanTools
visualReconTools
dirBruteTools
otherTools

echo -e "${GREEN}--==[ DONE ]==--${RESET}"
