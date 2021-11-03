#!/bin/bash
echo "[+] Installing GO language..."

wget https://golang.org/dl/go1.17.2.linux-amd64.tar.gz
sudo tar -xvf go1.17.2.linux-amd64.tar.gz
sudo mv go /usr/local/
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
echo 'export GOROOT=/usr/local/go' >> ~/.bashrc
echo 'export GOPATH=$HOME/go'   >> ~/.bashrc
echo 'export PATH=$GOPATH/bin:$GOROOT/bin:$PATH' >> ~/.bashrc
source ~/.bashrc



set -eu -o pipefail 

sudo -n true
test $? -eq 0 || exit 1 "you should have sudo privilege to run this script"

echo installing the must-have pre-requisites
while read -r p ; do sudo apt-get install -y $p ; done < <(cat << "EOF"
    jq
    git
    python3.7
    python2.7
    sqlite3
    
EOF
)


echo "[+] Installing tools..."
export PATH=$PATH:$(go env GOPATH)/bin
mkdir -p /root/recon/tools/Turbolist3r/

go get github.com/cgboal/sonarsearch/cmd/crobat
go get github.com/tomnomnom/waybackurls
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
git clone https://github.com/fleetcaptain/Turbolist3r.git /root/recon/tools/Turbolist3r/
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
echo "[-]===================================================================[-]"

echo "[+] Creating recon.db..."
sqlite3 recon.db <<'END_SQL'
create table domains(domain NVARCHAR(100), port NVARCHAR(100),title NVARCHAR(100), webserver NVARCHAR(100),technologies NVARCHAR(100),status_code NVARCHAR(100),ip NVARCHAR(100),timestamp NVARCHAR(100),scheme NVARCHAR(100));
END_SQL

echo [++] Done
echo you have 5 seconds to proceed ...
echo or
echo hit Ctrl+C to quit
echo -e "\n"
sleep 3
clear
ls -la
