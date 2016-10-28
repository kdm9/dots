################################################################################
#                                  ZSH config                                  #
################################################################################

export LANG=en_AU.UTF-8
export EDITOR='vim'
export SSH_KEY_PATH="$HOME/.ssh/id_rsa"
export VIRTUALENVWRAPPER_PYTHON="${VIRTUALENVWRAPPER_PYTHON:-python3}"

setopt autocd extendedglob notify
setopt histignorespace
setopt autopushd
unsetopt beep
stty -ixon

# Aliases

alias findswp='find -name \*.swp'
alias gap='git add --patch'
alias gds='git diff --staged'
alias gpdeb='git push origin master upstream pristine-tar --follow-tags'
alias gsh='git stash'
alias ifconfig='/sbin/ifconfig'
alias ipy='ipython3'
alias jnb='jupyter notebook'
alias l='ls -lhF'
alias ll='ls -lahf'
alias less='less -SR'
alias makejavalessshit='wmname LG3D'
alias nmcli='/usr/bin/nmcli -p'
alias sa='sudo aptitude'
alias speedtest='wget -O /dev/null ftp://ftp.iinet.net.au/test10MB.dat'
alias sum='paste -sd+ | bc'
alias svim='sudo vim'
alias t='task'
alias tt='task tdo'
alias tp='task project:phd'
alias ts='task sync'
alias texspell='aspell -d en_GB -t -c '
alias time='/usr/bin/time -f "\n\n%%TIME: [usr:%U sys:%S %P wall:%E rss:%M]"'
alias trimspace='perl -p -i -e "s/\s+$/\n/"'
alias utc='TZ=UTC date'
alias vim='vim -p'
alias whatismyip='wget -qO- icanhazip.com'

# Source here to ensure all plugins have paths etc. set right
test -f "$HOME/.zshlocal" && source "$HOME/.zshlocal"

################################################################################
#                                Plugin config                                 #
################################################################################
# Unfortunately some of these seem to need to be above the zgen stanza below

# Virtualenvwrapper
export WORKON_HOME="$HOME/.virtualenvs/"

# tmux
ZSH_TMUX_AUTOSTART=true
ZSH_TMUX_AUTOQUIT=false
ZSH_TMUX_AUTOCONNECT=false
ZSH_TMUX_FIXTERM=false

BULLETTRAIN_CONTEXT_SHOW=true
BULLETTRAIN_IS_SSH_CLIENT=true

################################################################################
#                                     Zgen                                     #
################################################################################
# Double underscore not to clash w/ zgen's internals
__ZGEN_DIR="$HOME/.zgen"
__ZGEN="$__ZGEN_DIR/zgen.zsh"
if [ ! -f $__ZGEN ]; then
    git clone https://github.com/tarjoilija/zgen.git $__ZGEN_DIR
fi
source $__ZGEN
unset __ZGEN_DIR
unset __ZGEN


################################################################################
#                           Zgen plugin install/load                           #
################################################################################

# Uncomment the below while debugging, forces reset
# zgen reset

ZGEN_RESET_ON_CHANGE=(${HOME}/.zshrc)

if ! zgen saved; then
    # OMZsh and some plugins
    zgen oh-my-zsh
    zgen oh-my-zsh plugins/git
    zgen oh-my-zsh plugins/debian
    zgen oh-my-zsh plugins/virtualenvwrapper
    zgen oh-my-zsh plugins/taskwarrior
    zgen oh-my-zsh plugins/sudo
    zgen oh-my-zsh plugins/tmux

    # Hist search
    zgen load zsh-users/zsh-history-substring-search

    # ZSH command syntax hl
    zgen load zsh-users/zsh-syntax-highlighting

    # Extra shell completions
    zgen load zsh-users/zsh-completions

    # easily add remotes to git repositories.
    zgen load caarlos0/git-add-remote

    # Warns you when you have an alias for the command you just typed, and tells
    # you what it is.
    zgen load djui/alias-tips

    # Improvements to vi-mode
    zgen load sharat87/zsh-vim-mode
    zgen load b4b4r07/zsh-vimode-visual

    # Gitignore generator
    zgen load voronkovich/gitignore.plugin.zsh

    # Theme
    zgen load caiogondim/bullet-train-oh-my-zsh-theme bullet-train

    zgen save
fi

################################################################################
#                           Misc final configuration                           #
################################################################################

# These need to be at the end

bindkey '^R' history-incremental-search-backward
bindkey '^S' history-incremental-search-forward

################################################################################
#                         KDM specific aliases & funcs                         #
################################################################################

test -f "$HOME/.dots/venv-jl.sh" && source "$HOME/.dots/venv-jl.sh"

function git-recover() {
    file="$1"
    if [ -z "$file" ]; then echo "USAGE: git-recover <filename>"; exit; fi
    git checkout "$(git rev-list -n 1 HEAD -- \"$file\")^" -- "$file"
}

function mkcd {
	mkdir -p "$1" && cd "$1"
}

if [ -n "$(which xrandr)" ]; then
    function xr() {
        CMD=$(xrandr | awk '
        BEGIN{
            printf("xrandr ");
            m=""
        }
        {
            if ($2 ~ /connected/){
                printf("--output %s --auto ", $1);
            }
            if ($1 ~ /^eDP/){
                m=$1
            } else if ($2 == "connected") {
                printf("--left-of %s ", m);
            }
        }
        END{printf("\n");}
        ')
        echo $CMD
        eval $CMD

    }
fi

# Ensure tmux termcap is defined
TERM=tmux tput cols >/dev/null 2>&1 || tic ${HOME}/.dots/tmux.term
