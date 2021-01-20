#!/usr/bin
# =================================================
# Program:
#     deploy.sh
#     Ubuntu装机脚本
# =================================================

# ===== Principal Variables =====
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin

# ===== Update & Upgrade =====
sudo apt update && sudo apt upgrade -y

# ===== Change pip source =====
if [ ! -e ~/.pip ]; then
  mkdir ~/.pip
  echo -e "[global]
  index-url = https://pypi.tuna.tsinghua.edu.cn/simple
  trusted-host = pypi.tuna.tsinghua.edu.cn"\
  >> $HOME/.pip/pip.conf
else
  echo "===>> ~/.pip exist."
fi

# ===== Sogouimebs || 搜狗拼音 =====
sudo apt install fcitx-bin curl
curl -sL 'https://keyserver.ubuntu.com/pks/lookup?&op=get&search=0x73BC8FBCF5DE40C6ADFCFFFA9C949F2093F565FF' | sudo apt-key add
sudo apt-add-repository 'deb http://archive.ubuntukylin.com/ukui focal main'
sudo apt update
sudo apt-get install sogouimebs
# 禁用IBus
sudo dpkg-divert --package im-config --rename /usr/bin/ibus-daemon

# ===== Git =====
name=lazyshawn
email=hitszshaohu@gmail.com
sudo apt-get install git -y
echo -e "[user]
  name = ${name}
  email = ${email}"\
>> $HOME/.gitconfig
# 生成 ssh 密钥
echo -e "=== Generate ssh, press Enter:"
ssh-keygen -t rsa -C "${email}"
cat ~/.ssh/id_rsa.pub
ssh -T git@github.com

# ===== Ranger =====
sudo apt install ranger -y

# ===== Neovim =====
sudo apt install neovim
sudo rm /usr/bin/vi
sudo ln -s /usr/bin/nvim /usr/bin/vi
firefox "https://blog.csdn.net/sscc_learning/article/details/105574354"
read -p "=== Edit /etc/hosts: (Press any key to continue)"
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim\
  --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
ln -s ${HOME}/.config/shawn_config/nvim ${HOME}/.config/nvim
# ctags, nodejs, ccls
sudo apt install ctags nodejs ccls -y
# zathura
sudo apt install zathura xdotool -y


# ===== ZSH =====
sudo apt install zsh -y
chsh -s /bin/zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"

# ===== Chromium =====
sudo apt install libcanberra-gtk-module
sudo apt update
sudo apt install chromium-browser

# ===== i3wm =====
sudo apt install i3
sudo apt install feh compton thunar scrot blueman -y

