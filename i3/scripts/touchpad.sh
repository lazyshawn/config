#!/bin/bash

# 命令xinput list-props 14可以列出触摸板的当前信息，
# 其中的Device Enabled (197): (用xinput list-props 14命令确定设备id)
# 1显示设备是否启用，数字1表示启用，0表示禁用。
# 这里可以用正则简单地判断触摸板是否在启用状态以执行不同的命令。
output=$(xinput list-props 14)

if [[ "$output" =~ Device.Enabled.\(197\):.1 ]]
then
    xinput disable 14
else
    xinput enable 14
fi

# 禁用鼠标加速
xset m 00

