autoload -Uz promptinit && promptinit
#prompt walters
prompt verns

autoload -Uz compinit && compinit
setopt COMPLETE_ALIASES
zstyle :compinstall filename '/home/fvhockney/.config/zsh/.zshrc'

setopt inc_append_history
HISTFILE=~/.config/zsh/.zhistory
HISTSIZE=1000
SAVEHIST=1000
setopt autocd extendedglob nomatch notify
source /usr/share/fzf/completion.zsh
export FZF_COMPLETION_TRIGGER='__'
export FZF_COMPLETION_OPTS='+c -x'
bindkey -v



# show history search matching only to cursor
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

[[ -n "${key[Up]}"   ]] && bindkey -- "${key[Up]}"   up-line-or-beginning-search
[[ -n "${key[Down]}" ]] && bindkey -- "${key[Down]}" down-line-or-beginning-search

# syntax highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export GPG_TTY="$(tty)"
export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
gpg-connect-agent updatestartuptty /bye

#export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
#gpgconf --launch gpg-agent

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[[ -r $NVM_DIR/bash_completion ]] && \. $NVM_DIR/bash_completion


if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='vim'
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# Lines configured by zsh-newuser-install

source ${ZDOTDIR}/aliases
source ${ZDOTDIR}/my_functions
