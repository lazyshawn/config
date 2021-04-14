## 安装 NVIDIA 显卡驱动
[参考教程](https://blog.csdn.net/Thanlon/article/details/106125738)

System Settings -> About -> Software Updates -> Additional Drivers
-> Using NVIDIA driver metapackge from nvidia-driver-xxx

If not success, I prefer to reinstall Ubuntu. :)


## 更新软件源
[参考教程](https://www.cnblogs.com/vipstone/p/9038023.html)
1. Ubuntu apt-repository
```shell
sudo apt update && sudo apt upgrade -y
```
2. Python repository
```shell
mkdir ~/.pip
vi ~/.pip/pip.conf
# Write these
[global]
index-url = https://pypi.tuna.tsinghua.edu.cn/simple
trusted-host = pypi.tuna.tsinghua.edu.cn
```


## 搜狗输入法(优麒麟)
 1. [安装搜狗输入法](https://www.cnblogs.com/cocode/p/12875555.html)
```shell
sudo apt install fcitx-bin curl    # Install fcitx, curl
curl -sL 'https://keyserver.ubuntu.com/pks/lookup?&op=get&search=0x73BC8FBCF5DE40C6ADFCFFFA9C949F2093F565FF' | sudo apt-key add
sudo apt-add-repository 'deb http://archive.ubuntukylin.com/ukui focal main'
sudo apt update
sudo apt install sogouimebs
# 禁用IBus
sudo dpkg-divert --package im-config --rename /usr/bin/ibus-daemon
```

2. 设置默认输入法

System Settings -> Region & Language -> Manage Installed Languages
-> Keyboard input method system: fcitx -> Apply System-Wide

Reboot or logout.

Input icon -> Configure -> +(add) -> uncheck "Only Show Current Langage" -> sogouimebs.


## Git
[参考教程](https://www.cnblogs.com/superGG1990/p/6844952.html)
1. 安装Git
```shell
sudo apt install git
 # Configure file at ~/.gitconfig
git config --global user.name "yours@name"
git config --global user.email "your@email.com"
```

2. 配置ssh密钥
```shell
ssh-keygen -t rsa -C "your@email.com"
cat ~/.ssh/id_rsa.pub
```
Add SSH-key to github. Use command `ssh -T git@github.com` to test.


## Ranger
[参考教程](https://github.com/ranger/ranger)
```shell
sudo apt install ranger
```


## Neovim
1.[安装Neovim](https://blog.csdn.net/henryhu712/article/details/80458753)
```shell
sudo apt install neovim
sudo rm /usr/bin/vi
sudo ln -s /usr/bin/nvim /usr/bin/vi
```

2. [插件管理器 vim-plug](https://github.com/junegunn/vim-plug)

[域名污染问题](https://blog.csdn.net/sscc_learning/article/details/105574354)

[参考教程](https://github.com/junegunn/vim-plug)
```shell
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
```

3. 配置Nvim
```shell
cd ~/.config
git clone git@github.com:lazyshawn/config.git shawn_config
mkdir ~/.config/nvim
ln -s /home/shawn/.config/shawn_config/nvim/init.vim /home/shawn/.config/nvim/init.vim
```

4. [安装Ctags](https://github.com/universal-ctags/ctags/blob/master/docs/autotools.rst)
```shell
sudo apt install gcc make pkg-config autoconf automake python3-docutils \
    libseccomp-dev libjansson-dev libyaml-dev libxml2-dev
git clone https://github.com/universal-ctags/ctags.git
cd ctags
./autogen.sh
./configure --prefix=/where/you/want/ctags  # defaults to /usr/local
make
sudo make install
sudo ln -s $prefix/bin/ctags /usr/bin/ctags
```

5. [安装nodejs](https://www.cnblogs.com/feiquan/p/11223487.html)
[参考教程](https://my.oschina.net/u/4271220/blog/4328656)
```shell
# Ubuntu 16.04
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt install -y nodejs
# Ubuntu 20.04
sudo apt install nodejs
```

6. [ccls](https://github.com/MaskRay/ccls/wiki/Build)

[参考教程](https://www.lazyshawn.cn/2020/04/10/coc-cls-install/)
```shell
# Ubuntu 20.04
sudo apt install ccls
```

7. [多用户共享NVIM配置](https://bbs.csdn.net/topics/390509468)

Run `:version` in nvim to find the $VIM and sysinit.vim.
Then copy your vimrc to other's home path.
```shell
sudo ln -s ~/.config/nvim $VIM/sysinit.vim
sudo ln -s ~/.config/nvim /root/.config/nvim
sudo ln -s ~/.config/coc /root/.config/coc
```


## ZSH
[参考教程](https://www.jianshu.com/p/ba782b57ae96)
1. 安装ZSH
```shell
sudo apt install zsh
chsh -s /bin/zsh    # Set zsh as the default terminator
```

2. [Zinit](https://github.com/zdharma/zinit)
```shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"
```

1. 复制`zsh/path_bk.zsh`到`zsh/path.zsh`并按照个人配置修改，
定义各种软件需要的环境变量和别名(alias)。

## Chromium
[参考教程](https://blog.csdn.net/dongchongyang/article/details/72758513)
```shell
sudo apt install libcanberra-gtk-module
# sudo add-apt-repository ppa:chromium-daily
sudo apt update
sudo apt install chromium-browser
```


## Latex
[参考教程](https://blog.csdn.net/williamyi96/article/details/90732304)
1. 安装Texlive 2019
```shell
sudo mount -o loop texlive2019.iso /mnt
cd /mnt
sudo ./install-tl
cd /
sudo umount /mnt
```

2. 添加环境变量
在 ~/.bashrc 和 ~/.profile 中均添加如下变量：
```shell
export MANPATH=/usr/local/texlive/2019/texmf-dist/doc/man:${MANPATH}
export INFOPATH=/usr/local/texlive/2019/texmf-dist/doc/info:${INFOPATH}
export PATH=/usr/local/texlive/2019/bin/x86_64-linux:${PATH}
```
全局变量配置 /etc/manpath.config 下添加：
```shell
MANPATH_MAP /usr/local/texlive/2019/bin/x86_64-linux /usr/local/texlive/2019/texmf-dist/doc/man
```


## 字体配置
1. 字体安装方法
* Move this font folder to your fonts path, which could be:
```shell
/usr/local/share/fonts    # This is your personal font_path
/usr/share/fonts          # User's default fonts
/etc/fonts                # System default fonts
```
* Then run these command:
```Shell
cd /FontsPath/FontsFolder
sudo mkfontscale     # 生成核心字体信息
sudo mkfontdir       # 生成字体文件夹
sudo fc-cache -fv    # 刷新系统字体缓存
```
* Reboot or relogin.
* Change your terminal fonts. That's all.

2. [`SauceCodePro Nerd Font`](https://github.com/ryanoasis/nerd-fonts)

**Usage:** 
ranger -- [ranger_devicons](https://github.com/alexanderjeurissen/ranger_devicons<Paste>);
vim    -- [Vista.vim](https://github.com/liuchengxu/vista.vim);
vim    -- [vim-devicons](https://github.com/ryanoasis/vim-devicons);
```shell
# ragner_devicons
git clone https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons
echo "default_linemode devicons" >> $HOME/.config/ranger/rc.conf
```
设置终端字体为`SauceCodePro Nerd Font`以更改Vim等终端软件的字体。

3. WinFonts

**Usage:** Latex


## 桌面管理器(i3wm)
[参考教程](https://github.com/levinit/i3wm-config)
1. 安装
```shell
sudo apt install i3
```
2. 配套软件
* `feh`: 壁纸管理；
* `compton`: 实现终端透明效果；
* `thunar`: 图形界面文件管理器；
* `flameshot`: 截图软件(使用快捷键调用此工具)；
* `blueman`: 蓝牙，其附带的托盘工具名为`blueman-applet`；
* `mate-power-manager`: 电源管理；
* `acpi`: 电源配置接口工具，用于显示电池信息；

3. [i3-gaps](https://github.com/Airblader/i3)(Opt)

[参考教程](https://github.com/Airblader/i3/wiki/Building-from-source)

```shell
# Dependencies
libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev \
libxcb-util0-dev libxcb-icccm4-dev libyajl-dev \
libstartup-notification0-dev libxcb-randr0-dev \
libev-dev libxcb-cursor-dev libxcb-xinerama0-dev \
libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev \
autoconf libxcb-xrm0 libxcb-xrm-dev automake libxcb-shape0-dev

# Install
cd /path/where/you/want/the/repository
# Clone the repository
git clone https://www.github.com/Airblader/i3 i3-gaps
cd i3-gaps
# Compile & install
autoreconf --force --install
rm -rf build/
mkdir -p build && cd build/
# Disabling sanitizers is important for release versions!
# The prefix and sysconfdir are, obviously, dependent on the distribution.
../configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers
make
sudo make install
```

4. [Polybar](https://github.com/polybar/polybar)

[参考教程](https://github.com/polybar/polybar/wiki/Compiling)
```shell
# Dependencies
sudo apt install build-essential git cmake cmake-data pkg-config python3-sphinx libcairo2-dev libxcb1-dev libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev python3-xcbgen xcb-proto libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev
sudo apt install libxcb-xkb-dev libxcb-xrm-dev libxcb-cursor-dev libasound2-dev libpulse-dev i3-wm libjsoncpp-dev libmpdclient-dev libcurl4-openssl-dev libnl-genl-3-dev

# Install
cd ~/Downloads
git clone --recursive https://github.com/polybar/polybar
mkdir -p polybar/build
cd polybar/build
cmake ..
make -j$(nproc)
# Optional. This will install the polybar executable in /usr/local/bin
sudo make install

# Configure
# config path: ~/.config/polybar/config
```

## 其他软件
1. 7zip
```bash
sudo apt install p7zip-full p7zip-rar
```

