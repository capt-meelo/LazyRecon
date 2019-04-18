# LazyRecon
[![release](https://img.shields.io/github/release/capt-meelo/LazyRecon.svg?label=version&style=flat)](https://github.com/capt-meelo/LazyRecon/releases)
[![license](https://img.shields.io/github/license/capt-meelo/LazyRecon.svg?style=flat)](https://github.com/capt-meelo/LazyRecon/blob/master/LICENSE)
[![open issues](https://img.shields.io/github/issues-raw/capt-meelo/LazyRecon.svg?style=flat)](https://github.com/capt-meelo/LazyRecon/issues?q=is:issue+is:open)
[![closed issues](https://img.shields.io/github/issues-closed-raw/capt-meelo/LazyRecon.svg)](https://github.com/capt-meelo/LazyRecon/issues?q=is:issue+is:closed)

LazyRecon is a wrapper of various scripts that automates the tedious and redundant process of reconnaissance of a target domain. 

LazyRecon utilizes the following tools:
- Subdomain Enumeration:
  - [Amass](https://github.com/OWASP/Amass)
  - [Subfinder](https://github.com/subfinder/subfinder)
  - [Goaltdns](https://github.com/subfinder/goaltdns)
- Subdomain Takeover:
  - [subjack](https://github.com/haccer/subjack)
- CORS Configuration:
  - [CORScanner](https://github.com/chenjj/CORScanner) 
- IP Discovery:
  - [Massdns](https://github.com/blechschmidt/massdns)
- Port Scanning:
  - [Masscan](https://github.com/robertdavidgraham/masscan)
  - [Nmap](https://nmap.org/)
  - [Nmap Bootstrap Stylesheet](https://github.com/honze-net/nmap-bootstrap-xsl/)
- Visual Recon:
  - [Aquatone](https://github.com/michenriksen/aquatone)
- Content Discovery:
  - [Dirsearch](https://github.com/maurosoria/dirsearch)
- Wordlists:
  - [JHaddix's all.txt](https://gist.github.com/jhaddix/f64c97d0863a78454e44c2f7119c2a6a)
  - [SecLists' raft-large-words.txt](https://github.com/danielmiessler/SecLists/blob/master/Discovery/Web-Content/raft-large-words.txt)
  - [Commonspeak2 wordlists](https://raw.githubusercontent.com/assetnote/commonspeak2-wordlists/master/subdomains/subdomains.txt)


## Workflow
![Flow](workflow.png)


## Installation
First, run the following commands to install the latest version of **Go**.
```
git clone https://github.com/capt-meelo/LazyRecon.git
cd LazyRecon
source get-go.sh
```

Then, modify the `subEnumTools()` function of `install.sh` by placing your **Virustotal**, **Passivetotal**, **SecurityTrails**, **Censys**, **Riddler**, and **Shodan API keys**. This will give better results during the subdomain enumeration.
```
~/go/bin/subfinder --set-config VirustotalAPIKey=<API-KEY-HERE>
~/go/bin/subfinder --set-config PassivetotalUsername=<API-KEY-HERE>,PassivetotalKey=<API-KEY-HERE>
~/go/bin/subfinder --set-config SecurityTrailsKey=<API-KEY-HERE>
~/go/bin/subfinder --set-config RiddlerEmail=<API-KEY-HERE>,RiddlerPassword=<API-KEY-HERE>
~/go/bin/subfinder --set-config CensysUsername=<API-KEY-HERE>,CensysSecret=<API-KEY-HERE>
~/go/bin/subfinder --set-config ShodanAPIKey=<API-KEY-HERE>
```
Finally, run the following to install the required tools.
```
chmod +x install.sh
./install.sh
```


## How to Use
```
cd LazyRecon
chmod +x LazyRecon.sh
./LazyRecon.sh <target_domain>
```


## Notes
- It's suggested to run this tool in a VPS, such as [DigitalOcean](https://www.digitalocean.com/?refcode=f7f86614e1b3), for better speed & accuracy.
- Running this tool takes time, thus it's recommended to run it under a **screen** or **tmux** session.
- The tool runs **masscan** with the option `--rate 10000` for more accurate results. Based on experiments, **masscan** misses some open ports when scanning large port ranges. Depending on your environment, you could do the following to have a good balance between speed and accuracy:
  - Increase the rate, and/or reduce the number of ports. For example, use the options `--top-ports 1000` & `--rate 100000`.
  - If you feel **masscan** and **nmap** are slow, you can run them in the background by changing the command `portScan` to `portScan > /dev/null 2>&1 &`.



## Tested On
- Ubuntu 18.10 (64-bit)
- Debian 9.8 (64-bit)
- Kali 2019.1 (64-bit)


## Contribute

If you have any problem or new idea, feel free to create an issue, or pull a request.


## Credits

All of the tools being used by LazyRecon are developed by others, so big thanks to them!


## Disclaimer

This tool is written for educational purposes only. You are responsible for your own actions. If you mess something up or break any law while using this tool, it's your fault and your fault only.
