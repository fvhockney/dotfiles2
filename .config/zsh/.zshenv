fpath=("$ZDOTDIR/prompts $ZDOTDIR/functions" $fpath)
limit coredumpsize 0 2> /dev/null
umask 022

export GOPATH=/media/vern/projects/go

typeset -U path
path=(~/bin ~/.config/.cargo/bin /usr/local/bin /usr/local/sbin /sbin/ ~/.config/composer/vendor/bin $GOPATH/bin $path)

typeset -U manpath

export EDITOR=vim
export VISUAL=vim
export XDG_CONFIG_HOME="$HOME/.config"
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
export NVM_DIR="$XDG_CONFIG_HOME/nvm"
export LESSKEY="$XDG_CONFIG_HOME/less/lesskey"
export LESSHISTFILE=-
export RANGER_LOAD_DEFAULT_RC=false
export CARGO_HOME="$XDG_CONFIG_HOME/.cargo"
export RUSTUP_HOME="$XDG_CONFIG_HOME/.rustup"
export LANG=en_US.UTF-8
