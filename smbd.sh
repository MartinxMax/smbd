#!/bin/bash

echo -e "\033[32m   .-'''-. ,---.    ,---. _______    ______      \033[0m";
echo -e "\033[32m  / _     \|    \  /    |\  ____  \ |    _ \`''.  \033[0m";
echo -e "\033[34m (\`' )/\`--'|  ,  \/  ,  || |    \ | | _ | ) _  \ \033[0m";
echo -e "\033[33m(_ o _).   |  |\_   /|  || |____/ / |( ''_'  ) | \033[0m";
echo -e "\033[36m (_,_). '. |  _( )_/ |  ||   _ _ '. | . (_) \`. | \033[0m";
echo -e "\033[35m.---.  \  :| (_ o _) |  ||  ( ' )  \|(_    ._) ' \033[0m";
echo -e "\033[37m\    \`-'  ||  (_,_)  |  || (_{;}_) ||  (_.\.' /  \033[0m";
echo -e "\033[31m \       / |  |      |  ||  (_,_)  /|       .'   \033[0m";
echo -e "\033[32m  \`-...-'  '--'      '--'/_______.' '-----'\`     \033[0m";
echo -e "\033[34m   Maptnh@S-H4CK13 SMB-Downloader https://github.com/MartinxMax/ \033[0m";


check_smbclient() {
    if ! command -v smbclient &> /dev/null; then
        echo -e "\033[31m[-] smbclient is not installed! Please install smbclient to continue.\033[0m"
        exit 1
    fi
}

check_smbclient

if [ $# -lt 4 ]; then
    echo -e "\033[33m[!] Usage: $0 <IP> <username> <password> <share1,share2,...>\033[0m"
    exit 1
fi

IP=$1
USERNAME=$2
PASSWORD=$3
SHARES=$4

TARGET_DIR="/tmp/$IP"
mkdir -p "$TARGET_DIR"
echo -e "\033[32m[+] All files will be downloaded under: $TARGET_DIR\033[0m"

IFS=',' read -r -a shares_array <<< "$SHARES"

for share in "${shares_array[@]}"; do
    echo
    echo -e "\033[34m[+] Starting download of share: $share\033[0m"

    local_dir="$TARGET_DIR/$share"
    mkdir -p "$local_dir"
    pushd "$local_dir" >/dev/null

    smbclient "//${IP}/${share}" \
      -U "${USERNAME}%${PASSWORD}" \
      -c "recurse on; prompt off; mget *; exit"

    popd >/dev/null

    echo -e "\033[32m[+] Completed download of share: $share\033[0m"
    echo -e "\033[32m[+] Files for $share are in: $local_dir\033[0m"
done

echo
echo -e "\033[32m[+] ALL DOWNLOADS FINISHED.\033[0m"
