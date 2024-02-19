###########
#  zplug  #
###########
export ZPLUG_HOME=$HOME/.zplug
if [ ! -e $ZPLUG_HOME ] ; then
    git clone https://github.com/zplug/zplug $ZPLUG_HOME
fi
source $ZPLUG_HOME/init.zsh

zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions"
# Must be loaded after compinit
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "babarot/enhancd", use:init.sh
zplug "nojhan/liquidprompt"

if ! zplug check ; then
    zplug install
fi

zplug load


#####################
#  Plugin Settings  #
#####################
export ENHANCD_FILTER=fzf
export ENHANCD_ENABLE_DOUBLE_DOT=false
export ENHANCD_ENABLE_HOME=false


###########################
#  Environment Variables  #
###########################
export EDITOR=vim


#########
# Alias #
#########
alias ls="ls -aF -G"
alias ll="ls -lh"
alias la="ls -lAh"
alias rm="rm -iv"
alias cp="cp -iv"
alias mv="mv -iv"
alias mkdir="mkdir -p"
alias ps="ps -axf"
alias ag="ag -S"
# Enable alias following sudo command
alias sudo="sudo "
alias tmp="vim $HOME/tmp.md"
# List latest 10 directories
alias j="cd -"


#############
#  History  #
#############
setopt share_history
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks

HISTFILE=$HOME/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000


##########
#  Init  #
##########
if [ -e $HOME/.pyenv ]; then
    export PYENV_ROOT="$HOME/.pyenv"
    path=(
        $PYENV_ROOT/shims
        $path
    )
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

if type "rbenv" > /dev/null 2>&1; then
    export PATH="~/.rbenv/shims:/usr/local/bin:$PATH"
    eval "$(rbenv init -)"
fi

if type "direnv" > /dev/null 2>&1; then
    eval "$(direnv hook zsh)"
fi

if [ -f ~/.fzf.zsh ]; then
    source ~/.fzf.zsh
fi


##########
#  Misc  #
##########
# fzf
export FZF_DEFAULT_COMMAND='ag --hidden -g ""'
export FZF_DEFAULT_OPTS="--height 40% --reverse --border"
