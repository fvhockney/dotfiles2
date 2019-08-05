limit coredumpsize 0 2> /dev/null
umask 022

export GOPATH=/media/vern/projects/go

typeset -U path
path=(~/bin /usr/local/bin /usr/local/sbin /sbin/ ~/.config/composer/vendor/bin $GOPATH/bin $path)

typeset -U manpath

export EDITOR=vim
export VISUAL=vim
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
export ZSH="$HOME/.oh-my-zsh"
export NVM_DIR="${XDG_CONFIG_HOME}/nvm"
export LESSKEY="$XDG_CONFIG_HOME/less/lesskey"
export LESSHISTFILE=-
export GEM_HOME="$XDG_DATA_HOME/gem"
export GEM_SPEC_CACHE="$XDG_CACHE_HOME/gem"
export VAGRANT_HOME="$XDG_DATA_HOME/vagrant"
export VAGRANT_ALIAS_FILE="$XDG_DATA_HOME/vagrant/aliases"
export BUNDLE_USER_CONFIG="$XDG_CONFIG_HOME/bundle"
export BUNDLE_USER_CACHE="$XDG_CACHE_HOME/bundle"
export BUNDLE_USER_PLUGIN="$XDG_DATA_HOME/bundle"
export RANGER_LOAD_DEFAULT_RC=false
