## 安装 NVIDIA 显卡驱动
[参考教程](https://blog.csdn.net/Thanlon/article/details/106125738)
System Settings -> About -> Software Updates -> Additional Drivers
-> Using NVIDIA driver metapackge from nvidia-driver-xxx

If not success, I prefer to reinstall Ubuntu. :)

## 搜狗输入法(优麒麟)
 1. [安装搜狗输入法](https://www.cnblogs.com/cocode/p/12875555.html)
```shell
sudo apt-get install fcitx-bin    # Install fcitx
sudo apt-get install curl     # Install curl
curl -sL 'https://keyserver.ubuntu.com/pks/lookup?&op=get&search=0x73BC8FBCF5DE40C6ADFCFFFA9C949F2093F565FF' | sudo apt-key add
sudo apt-add-repository 'deb http://archive.ubuntukylin.com/ukui focal main'
sudo apt-get upgrade
sudo apt-get install sogouimebs
```

2. 设置默认输入法
System Settings -> Region & Language -> Manage Installed Languages
-> Keyboard input method system: fcitx -> Apply System-Wide

Reboot or logout.

Input icon -> Configure -> +(add) -> uncheck "Only Show Current Langage" -> sogouimebs.


## Git
1. [安装Git](https://www.cnblogs.com/superGG1990/p/6844952.html)
```shell
sudo apt-get install git
 # Configure file at ~/.gitconfig
git config --global usr.name "yours@name"
git config --global usr.email "your@email.com"
```

2. 配置ssh密钥
```shell
ssh-keygen -t rsa -C "your@email.com"
cat ~/.ssh/id_rsa.pub
```
Add SSH-key to github. Use command `ssh -T git@github.com` to test.


## Ranger
[参考教程](https://github.com/ranger/ranger)
```
sudo apt-get install ranger
```

## Neovim
1.[安装Neovim](https://blog.csdn.net/henryhu712/article/details/80458753)
```
sudo apt-get install neovim
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
cd ~/Download
git clone git@github.com:lazyshawn/.config.git config
mkdir ~/.config/nvim
cp config/nvim/init.vim ~/.config/nvim/init.vim
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
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt-get install -y nodejs
```

6. [多用户共享NVIM配置](https://bbs.csdn.net/topics/390509468)
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
sudo apt-get install zsh
chsh -s /bin/zsh    # Set zsh as the default terminator
```

2. [Zinit](https://github.com/zdharma/zinit)
```shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"
```


## Chromium
[参考教程](https://blog.csdn.net/dongchongyang/article/details/72758513)
```shell
sudo add-apt-repository ppa:chromium-daily
sudo apt-get update
sudo apt-get install chromium-browser
```


## Latex
[参考教程](https://blog.csdn.net/williamyi96/article/details/90732304)
1. 安装Texlive 2019
```shell
sudo mount -o loop texlive2019.iso /mnt
cd /mnt
sudo ./install-tl
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

3. 字体配置
WinFonts



