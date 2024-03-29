# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

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
# --- (光标在行首)补全 "cd " {{{
user-complete(){
case $BUFFER in
"" ) # 空行
BUFFER="cd ~/"
zle end-of-line
;;
"cd " ) # TAB + 空格 替换为 "cd ~"
BUFFER="cd $"
zle end-of-line
;;
" " )
BUFFER="!?" # 重复上一条 cd 指令(包括..)
zle end-of-line
;;
"cd --" ) # "cd --" 替换为 "cd +"
BUFFER="cd +"
zle end-of-line
zle expand-or-complete
;;
"cd +-" ) # "cd +-" 替换为 "cd -"
BUFFER="cd -"
zle end-of-line
zle expand-or-complete
;;
* )
zle expand-or-complete
;;
esac
}
zle -N user-complete
bindkey "\t" user-complete
# {{{
# --- 空行(光标在行首)补全 cd
# user-complete(){
#     if [[ -n $BUFFER ]] ; then
#         zle expand-or-complete
#     else
#         BUFFER="cd ~/"
#         zle end-of-line
#     fi }
# zle -N user-complete
# bindkey "\t" user-complete

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
# cmake
alias cmake='cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1'


# ========================
# === Zsh/zi
# ========================
# --- ranger
export VISUAL=nvim


# ========================
# === Zsh/zi
# ========================
if [[ ! -f $HOME/.zi/bin/zi.zsh ]]; then
  print -P "%F{33}▓▒░ %F{160}Installing (%F{33}z-shell/zi%F{160})…%f"
  command mkdir -p "$HOME/.zi" && command chmod go-rwX "$HOME/.zi"
  command git clone -q --depth=1 --branch "main" https://github.com/z-shell/zi "$HOME/.zi/bin" && \
    print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
    print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi
source "$HOME/.zi/bin/zi.zsh"
# enable zi completions
autoload -Uz _zi
(( ${+_comps} )) && _comps[zi]=_zi
# examples here -> https://wiki.zshell.dev/ecosystem/category/-annexes
zicompinit # <- https://wiki.zshell.dev/docs/guides/commands

# --- powerlevel10
zi ice depth=1; zi light romkatv/powerlevel10k
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# --- zsh-autosuggestions
zi light zsh-users/zsh-autosuggestions
# https://github.com/zsh-users/zsh-autosuggestions/issues/265#issuecomment-339235780
bindkey '^l' autosuggest-execute
bindkey '^j' autosuggest-accept
bindkey '^k' forward-word
bindkey '^h' backward-kill-word

zi light zsh-users/zsh-syntax-highlighting
# history-search-multi-word
zi load z-shell/H-S-MW
# zi light junegunn/fzf
zi load rupa/z

# auto startx
if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
    exec startx
fi

export LD_LIBRARY_PATH=/lib:/usr/lib:/usr/local/lib
