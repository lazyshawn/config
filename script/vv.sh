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
  exit
else
  echo "using defalut configuration: '$path'"
  cd "$path" || exit
fi

# try to connect to Surfshark
timeout_duration=3
for file in *.ovpn; do
  echo "sdfd"
  output=$(sudo openvpn --config "$file" --auth-user-pass $HOME/Documents/openvpn/pass.txt &)
  desired="Initialization"
  cmd_pid=$!

  # wait for the desired output
  while true; do
    # check if the desired output is found
    if grep -q "$desired" <<< "$output"; then
      echo "Matched at: $file" && exit
    else
      echo "sdfd"
    fi

    # check if the timeout is reached
    if [ $SECONDS -ge $timeout_duration ]; then
      echo "Matched failed to: $file"
      kill cmd_pid
    fi
    sleep 1
  done
done

# try to open clash
# cd $HOME/clash
# ./clash -d .

