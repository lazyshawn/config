#!/usr/bin
# =================================================
# Program:
#     deploy.sh
#     部署配置文件
# =================================================

# ===== Principal Variables =====
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
CONFIG="$HOME/.config/shawn_config"

# ===== git =====
ln -s $CONFIG/git/.gitconfig $HOME/.gitconfig 

# ===== i3 =====
ln -s $CONFIG/i3 $HOME/.config/i3

# ===== nvim =====
ln -s $CONFIG/nvim/* $HOME/.config/nvim

# ===== ranger =====
ln -s $CONFIG/ranger $HOME/.config/ranger

# ===== rofi =====
ln -s $CONFIG/rofi/* $HOME/.config/rofi

# ===== zsh =====
ln -s $CONFIG/zsh/.zshrc $HOME/.zshrc


