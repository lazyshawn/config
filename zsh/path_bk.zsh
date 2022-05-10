# ==============================================================
# ==>> Personal $PATH for zsh
# ==============================================================
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


# ========================
# === NVIDIA
# ========================
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda-11.1/lib64
export PATH=$PATH:/usr/local/cuda-11.1/bin
export CUDA_HOME=$CUDA_HOME:/usr/local/cuda-11.1
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda-11.1/extras/CUPTI/lib64

# ========================
# === ROS
# ========================
alias rs='source /opt/ros/foxy/setup.zsh && source ~/ros2ws/install/setup.zsh'
alias rs1='source /opt/ros/noetic/setup.zsh && source ~/catkin_ws/devel/setup.zsh'
alias -g kk='"$(eval "$(fc -ln -1)" | tail -n 1)"'
alias ros2cd='_ros2cd(){ cd "$(ros2 pkg prefix "$1")";}; _ros2cd'
alias vpn='_openvpn(){ sudo -v; sudo openvpn --config /etc/openvpn/"$1" --auth-user-pass /etc/openvpn/pass.txt &;}; _openvpn'
alias vpnoff='sudo killall openvpn'

export PATH=$PATH:/home/shawn/.cargo/bin



