################################################################################
#                                  ZSH config                                  #
################################################################################

export LANG=en_AU.UTF-8
export EDITOR='vim'
export SSH_KEY_PATH="$HOME/.ssh/id_rsa"
export VIRTUALENVWRAPPER_PYTHON="${VIRTUALENVWRAPPER_PYTHON:-python3}"

function sourceifexists() {
    file="$1"
    test -f "$file" && source "$file"
}

setopt autocd extendedglob notify
setopt histignorespace
setopt autopushd
unsetopt beep
stty -ixon

# Source here to ensure all plugins have paths etc. set right
sourceifexists "$HOME/.zshlocal.pre"
sourceifexists "$HOME/.zshlocal"

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
if [ -n "$SSH_CLIENT" ]
then
    BULLETTRAIN_CONTEXT_BG=red
    BULLETTRAIN_CONTEXT_FG=black
else
    BULLETTRAIN_CONTEXT_BG=green
    BULLETTRAIN_CONTEXT_FG=white
fi


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

sourceifexists "$HOME/.dots/aliases.sh"
sourceifexists "$HOME/.dots/functions.sh"
sourceifexists "$HOME/.dots/venv-jl.sh"

# Ensure tmux termcap is defined
TERM=tmux tput cols >/dev/null 2>&1 || tic ${HOME}/.dots/tmux.term

################################################################################
#                              load zshlocal.post                              #
################################################################################

# Source here to ensure all post script is final
test -f "$HOME/.zshlocal.post" && source "$HOME/.zshlocal.post"
