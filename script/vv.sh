#!/bin/bash
#------------------------------------------------------
#@author: lazyshawn
#@file  : vv.sh
#@brief : setup openvpn automatically
#------------------------------------------------------

# check if path exist
path=$HOME/Documents/openvpn/config
if [[ ! -d "$path" ]]; then
  echo "openvpn/config not exist."
else
  cd "$path" || exit
fi

# try to connect to Surfshark
for file in *.ovpn; do
  # Ref: https://stackoverflow.com/a/16931282
  sudo openvpn --config "$file" --auth-user-pass $HOME/Documents/openvpn/pass.txt | grep "Initialization" &> /dev/null &
  sleep 2
  if [ $? == 0 ]; then
    echo "Matched at: $file" && exit
  else
    # Ref: https://superuser.com/a/593029
    pidsave=$!
    kill $pidsave
  fi
done

# try to open clash
cd $HOME/clash
./clash -d .

