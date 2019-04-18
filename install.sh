#!/bin/bash

WORKING_DIR="$(cd "$(dirname "$0")" ; pwd -P)"
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
    INSTALL_PKGS="git python python-pip python3 python3-pip libldns-dev gcc g++ make libpcap-dev xsltproc curl"
    for i in $INSTALL_PKGS; do
        sudo apt-get install -y $i
    done

    if [ "ubuntu" == "$(cat /etc/os-release | grep ^ID= | cut -d '=' -f2)" ]; then
        sudo add-apt-repository ppa:canonical-chromium-builds/stage -y
        sudo apt update -y
        sudo apt install -y chromium-browser
    else
        sudo apt install -y chromium
    fi
}


subEnumTools(){
    echo -e "${GREEN}\n--==[ Installing subdomain enum tools ]==--${RESET}"
    installBanner "Amass"
    if [ -e ~/go/bin/amass ]; then
        echo -e "${BLUE}[!] Amass already exists...\n${RESET}"
    else 
        go get -u github.com/OWASP/Amass/...
    fi
    
    installBanner "subfinder"
    if [ -e ~/go/bin/subfinder ]; then
        echo -e "${BLUE}[!] Subfinder already exists...\n${RESET}"
    else 
        go get -u github.com/subfinder/subfinder
        echo -e "${RED}[+] Setting up API keys for subfinder...${RESET}"
        # Set your API keys here
        ~/go/bin/subfinder --set-config VirustotalAPIKey=<API-KEY-HERE>
        ~/go/bin/subfinder --set-config PassivetotalUsername=<API-KEY-HERE>,PassivetotalKey=<API-KEY-HERE>
        ~/go/bin/subfinder --set-config SecurityTrailsKey=<API-KEY-HERE>
        ~/go/bin/subfinder --set-config RiddlerEmail=<API-KEY-HERE>,RiddlerPassword=<API-KEY-HERE>
        ~/go/bin/subfinder --set-config CensysUsername=<API-KEY-HERE>,CensysSecret=<API-KEY-HERE>
        ~/go/bin/subfinder --set-config ShodanAPIKey=<API-KEY-HERE>
    fi

    installBanner "subjack"
    if [ -e ~/go/bin/subjack ]; then
        echo -e "${BLUE}[!] Subjack already exists...\n${RESET}"
    else 
        go get -u github.com/haccer/subjack
    fi
    
    installBanner "goaltdns"
    if [ -e ~/go/bin/goaltdns ]; then
        echo -e "${BLUE}[!] Goaltns already exists...${RESET}"
    else
        go get github.com/subfinder/goaltdns
    fi
}


corsTools(){
    echo -e "${GREEN}\n--==[ Installing CORS config checker ]==--${RESET}"
    installBanner "CORScanner"
    if [ "$(ls -A $TOOLS_PATH/CORScanner 2>/dev/null)" ]; then
        echo -e "${BLUE}[!] CORScanner already exists...\n${RESET}"
    else
        cd $TOOLS_PATH
        git clone https://github.com/chenjj/CORScanner.git
        cd CORScanner
        sudo pip install -r requirements.txt
        cd $WORKING_DIR
    fi
}


ipEnumTools(){ 
    echo -e "${GREEN}\n--==[ Installing IP enum tools ]==--${RESET}"
    installBanner "massdns"
    if [ -e $TOOLS_PATH/massdns/bin/massdns 2>/dev/null ]; then
        echo -e "${BLUE}[!] Massdns already installed...\n${RESET}"
    else
        cd $TOOLS_PATH
        git clone https://github.com/blechschmidt/massdns
        cd massdns
        make -j
        cd $WORKING_DIR
    fi
}


portScanTools(){
    echo -e "${GREEN}\n--==[ Installing port scanners ]==--${RESET}"
    
    installBanner "nmap"
    apt-get install nmap -y
        
    installBanner "masscan"
    if [ -e $TOOLS_PATH/masscan/bin/masscan 2>/dev/null ]; then
        echo -e "${BLUE}[!] Masscan already installed...\n${RESET}"
    else
        cd $TOOLS_PATH
        git clone https://github.com/robertdavidgraham/masscan
        cd masscan
        make -j
        cd $WORKING_DIR
    fi

}


visualReconTools(){
    echo -e "${GREEN}\n--==[ Installing visual recon tools ]==--${RESET}"
    installBanner "aquatone"
    if [ -e ~/go/bin/aquatone ]; then
        echo -e "${BLUE}[!] Aquatone already exists...\n${RESET}"
    else 
        go get -u github.com/michenriksen/aquatone
    fi
}


dirBruteTools(){
    echo -e "${GREEN}\n--==[ Installing content discovery tools ]==--${RESET}"
    installBanner "dirsearch"
    if [ "$(ls -A $TOOLS_PATH/dirsearch 2>/dev/null)" ]; then
        echo -e "${BLUE}[!] Dirsearch already exists...\n${RESET}"
    else
        cd $TOOLS_PATH
        git clone https://github.com/maurosoria/dirsearch
        cd $WORKING_DIR
    fi
}


otherTools(){
    echo -e "${GREEN}\n--==[ Downloading wordlists & other tools]==--${RESET}"
    if [ -e $WORDLIST_PATH/dns_all.txt 2>/dev/null ] && [ -e $WORDLIST_PATH/raft-large-words.txt 2>/dev/null ]; then
        echo -e "${BLUE}[!] Wordlists already downloaded...\n${RESET}"
    else
        echo -e "${RED}[+] Downloading wordlists...${RESET}"
        wget -O $WORDLIST_PATH/dns_all.txt https://gist.githubusercontent.com/jhaddix/86a06c5dc309d08580a018c66354a056/raw/96f4e51d96b2203f19f6381c8c545b278eaa0837/all.txt
        wget -O $WORDLIST_PATH/raft-large-words.txt https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/raft-large-words.txt
        wget -O $WORDLIST_PATH/comonspeak-subdomains.txt https://raw.githubusercontent.com/assetnote/commonspeak2-wordlists/master/subdomains/subdomains.txt
    fi

    if [ -e $TOOLS_PATH/nmap-bootstrap.xsl 2>/dev/null ]; then
        echo -e "${BLUE}[!] Nmap-bootstrap.xsl already downloaded...\n${RESET}"
    else
        echo -e "${RED}[+] Downloading nmap-bootstrap-xsl...${RESET}"
        wget -O $TOOLS_PATH/nmap-bootstrap.xsl https://github.com/honze-net/nmap-bootstrap-xsl/raw/master/nmap-bootstrap.xsl
    fi
}


# Main function
update
createDir
setupTools
subEnumTools
corsTools
ipEnumTools
portScanTools
visualReconTools
dirBruteTools
otherTools

echo -e "${GREEN}--==[ DONE ]==--${RESET}"
