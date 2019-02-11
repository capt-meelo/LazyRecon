# LazyRecon
[![Version](https://img.shields.io/badge/Version-v1.0-green.svg)]()
[![License](https://img.shields.io/badge/License-MIT-red.svg)](https://github.com/capt-meelo/LazyRecon/blob/master/LICENSE)

LazyRecon is a wrapper for various scripts that can automate the tedious process of reconnaissance of a target domain. 

LazyRecon utilizes the following tools:
- Subdomain Enumeration Tools:
  - [Amass](https://github.com/OWASP/Amass)
  - [Subfinder](https://github.com/subfinder/subfinder)
  - [Massdns](https://github.com/blechschmidt/massdns)
  - [subjack](https://github.com/haccer/subjack)
- IP Discovery Tools:
  - [Massdns](https://github.com/blechschmidt/massdns)
  - [IPOsint](https://github.com/j3ssie/IPOsint)
- Port Scanner:
  - [Masscan](https://github.com/robertdavidgraham/masscan)
- Visual Recon Tools:
  - [Aquatone](https://github.com/michenriksen/aquatone)
- Content Discovery Tools:
  - [Gobuster](https://github.com/OJ/gobuster)
  - [Dirsearch](https://github.com/maurosoria/dirsearch)

## Workflow
![Flow](LazyRecon.png)


## Installation
:warning: _**NOTE:** Before executing `install.sh`, modify first the `subEnumTools()` function by placing your API keys for Virustotal, Passivetotal, SecurityTrails, Censys, Riddler, and Shodan. This will give more results during the subdomain enumeration._
```
git clone https://github.com/capt-meelo/LazyRecon.git
cd LazyRecon
chmod +x install.sh
./install.sh
```

## How to Use
```
cd LazyRecon
chmod +x LazyRecon.sh
./LazyRecon.sh <target_domain>
```

## Contribute

If you have any problems or ideas, feel free to create an issue, or pull a request.


## Disclaimer
All of the tools being used by LazyRecon are developed by others. I just put all the pieces together and automate the boring stuff.

This tool is written for educational purposes only. You are responsible for your own actions. If you mess something up or break any laws while using this software, it's your fault, and your fault only.
