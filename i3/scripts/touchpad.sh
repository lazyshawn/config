#!/bin/bash

# 命令 `xinput list` 可以查看已连接的外设及其对应的id。
# 命令 `xinput list-props <id>` 可以列出触摸板的当前信息，
# 其中的Device Enabled (197): (用xinput list-props 14命令确定设备id)
# 1显示设备是否启用，数字1表示启用，0表示禁用。
# 命令 `xinput --disable <id>` 可以停用设备(enable 启用设备)。
declare -i ID
ID=`xinput list | grep -Eo 'TouchPad\s*id\=[0-9]{1,2}' | grep -Eo '[0-9]{1,2}'`
declare -i STATE
STATE=`xinput list-props $ID|grep 'Device Enabled'|awk '{print $4}'`
if [ $STATE -eq 1 ]
then
    xinput disable $ID
    echo "Touchpad disabled."
else
    xinput enable $ID
    echo "Touchpad enabled."
fi

