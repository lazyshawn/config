# ========================
# === Basic Settigns
# ========================
# --- 关于历史纪录的配置
# number of lines kept in history
export HISTSIZE=10000
# number of lines saved in the history after logout
export SAVEHIST=10000
# location of history, mkdir first
export HISTFILE=~/.cache/zhistory
# append command to history file once executed
setopt INC_APPEND_HISTORY
# 如果连续输入的命令相同，历史纪录中只保留一个
setopt HIST_IGNORE_DUPS
# 为历史纪录中的命令添加时间戳
setopt EXTENDED_HISTORY
#启用 cd 命令的历史纪录，cd -[TAB]进入历史路径
setopt AUTO_PUSHD
#相同的历史路径只保留一个
setopt PUSHD_IGNORE_DUPS
# 解决dpkg -l firefox*，zsh不会列出名字以firefox开头的包
setopt no_nomatch
#以下字符视为单词的一部分
WORDCHARS='*?_-[]~=&;!#$%^(){}<>'

#禁用 core dumps
limit coredumpsize 0



# ========================
# === Completion
# ========================
# --- 初始化补全命令
autoload -U compinit
compinit

# --- 自动补全功能
setopt AUTO_LIST
setopt AUTO_MENU
setopt MENU_COMPLETE

# --- 自动补全缓存
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path .zcache
zstyle ':completion:*:cd:*' ignore-parents parent pwd

# --- 修正大小写
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'

# --- 自动补全选项
zstyle ':completion::match:' original only
zstyle ':completion::prefix-1:' completer _complete
zstyle ':completion:predict:' completer _complete
zstyle ':completion:incremental:*' completer _complete _correct
zstyle ':completion:*' completer _complete _prefix _correct _prefix _match _approximate

# --- 路径补全
zstyle ':completion:' expand 'yes'
zstyle ':completion:' squeeze-shlashes 'yes'
zstyle ':completion::complete:*' '\'

#--- 彩色补全菜单
eval $(dircolors -b)
export ZLSCOLORS="${LS_COLORS}"
zmodload zsh/complist
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

# --- Completion in OMZ
# https://github.com/ohmyzsh/ohmyzsh/blob/master/lib/key-bindings.zsh
# start typing + [Up-Arrow] - fuzzy find history forward
if [[ "${terminfo[kcuu1]}" != "" ]]; then
  autoload -U up-line-or-beginning-search
  zle -N up-line-or-beginning-search
  bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search
  bindkey "\C-p" up-line-or-beginning-search
fi
# start typing + [Down-Arrow] - fuzzy find history backward
if [[ "${terminfo[kcud1]}" != "" ]]; then
  autoload -U down-line-or-beginning-search
  zle -N down-line-or-beginning-search
  bindkey "${terminfo[kcud1]}" down-line-or-beginning-search
  bindkey "\C-n" down-line-or-beginning-search
fi

# Edit the current command line in $EDITOR
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-v' edit-command-line


# ========================
# === User Define
# ========================
# --- 空行(光标在行首)补全 cd
user-complete(){
    if [[ -n $BUFFER ]] ; then
        zle expand-or-complete
    else
        BUFFER="cd $"
        zle end-of-line
    fi }
zle -N user-complete
bindkey "\t" user-complete

# --- 在命令前插入 sudo
sudo-command-line() {
[[ -z $BUFFER ]] && zle up-history
[[ $BUFFER != sudo\ * ]] && BUFFER="sudo $BUFFER"
zle end-of-line #光标移动到行末
}
zle -N sudo-command-line
# 定义快捷键为： [Esc] [Esc]
bindkey "\e\e" sudo-command-line

# --- 目录栈(dirstack)
# 使用`dirs -v`来打印目录栈
# 使用 `cd -<NUM>` 来跳转到以前访问过的目录
DIRSTACKFILE="$HOME/.cache/zshdirs"
chpwd() {
  print -l $PWD ${(u)dirstack} >$DIRSTACKFILE
}
DIRSTACKSIZE=20
setopt autopushd pushdsilent pushdtohome
# Remove duplicate entries
setopt pushdignoredups
# This reverts the +/- operators.
setopt pushdminus

# ========================
# === Alias
# ========================
# --- Shrotcuts for personal path
# use cd $xxx
dld="/home/shawn/Downloads"
shawn="/home/shawn/.config/shawn_config"
# use cd ~xxx
# hash -d dld="/home/shawn/Downloads"

# --- aliases
alias ra='ranger'
alias vi='nvim'
alias c='clear'
alias ..='cd ..'
# git
alias gs='git status'
alias gc='git clone'
alias gl='git lg'
alias ga='git add'
alias gcmt='git commit -m'
alias gd='git diff'
alias gp='git push'
# apt-get
alias install='sudo apt-get install'
alias remove='sudo apt-get remove'
alias update='sudo apt-get update'
alias upgrade='sudo apt-get upgrade'
# terminal
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
# ROS
alias sb='source /opt/ros/noetic/setup.zsh'


# ========================
# === Zinit
# ========================
### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-rust \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-bin-gem-node

### End of Zinit's installer chunk


# --- Zinit plugins
# Press <C-R> to display history directives
zinit light-mode for \
    zsh-users/zsh-autosuggestions \
    zdharma/fast-syntax-highlighting \
    zdharma/history-search-multi-word \

# zsh-autosuggestions
bindkey '^j' autosuggest-accept

# Binary release in archive, from GitHub-releases page.
# After automatic unpacking it provides program "fzf".
zinit ice from"gh-r" as"program"
zinit load junegunn/fzf-bin

# ======================
# === 主题设置
# ======================
# 初始化prompt
autoload -Uz promptinit
promptinit    
# Pure
zinit ice pick"async.zsh" src"pure.zsh"
zinit light sindresorhus/pure


# ======================
# === Env
# ======================
# --- GCC
# export PATH=/usr/local/gcc/bin:$PATH
# export LD_LIBRARY_PATH=/usr/local/gcc/lib64:/usr/local/gmp/lib:/usr/local/mpfr/lib:/usr/local/mpc/lib:$LD_LIBRARY_PATH
# export MANPATH=/usr/local/gcc/share/man:$MANPATH

# --- Rust
export PATH=$HOME/.cargo/bin:$PATH

# --- Opencv
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig

# --- Texlive 2019
export MANPATH=/usr/local/texlive/2020/texmf-dist/doc/man:$MANPATH
export INFOPATH=/usr/local/texlive/2020/texmf-dist/doc/info:$INFOPATH
export PATH=/usr/local/texlive/2020/bin/x86_64-linux:$PATH

# --- i3
export PATH=~/.config/i3/scripts:$PATH


# --- Nvim
source $HOME/.config/nvim/plugged/gruvbox/gruvbox_256palette.sh
export TERM=xterm-256color
# export VISUAL=emacs
export VISUAL=nvim

# --- Opencv4
PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig
export PKG_CONFIG_PATH


# ========================
# === Ranger
# ========================
# 用ranger打开终端时有提示符[ranger]
if [ -n "$RANGER_LEVEL" ]; then export PS1="[RA]$PS1"; fi


# ========================
# === fzf
# ========================
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# --- preview window
export FZF_DEFAULT_OPTS='
  --preview "[[ $(file --mime {}) =~ binary ]] && (echo Binary file !!! {}) || (cat {}) 2> /dev/null | head -100"
  --color fg:#ebdbb2,bg:#282828,hl:#fabd2f,fg+:#ebdbb2,bg+:#3c3836,hl+:#fabd2f
  --color info:#83a598,prompt:#bdae93,spinner:#fabd2f,pointer:#83a598,marker:#fe8019,header:#665c54'
# export FZF_DEFAULT_COMMAND='rg --hidden --ignore .git -g ""'


