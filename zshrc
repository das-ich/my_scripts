#PROMPT='%B%F{green}%n@%m%f:%F{blue}%~%f%b%(!.#.$) '

autoload -U compinit promptinit
compinit
promptinit
prompt redhat
zmodload zsh/complist
zstyle ':completion:*' menu yes select

export CLICOLOR=1
export LSCOLORS=exfxcxdxbxegedabagacad
export LS_COLORS='di=33;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:'
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

setopt AUTO_CD BSD_ECHO CORRECT_ALL
SPROMPT="Ошибка! Вы хотели ввести %r вместо %R? ([Y]es/[N]o/[E]dit/[A]bort) "

_force_rehash() {
  (( CURRENT == 1 )) && rehash
  return 1
}

zstyle ':completion:::::' completer _force_rehash _complete

setopt SH_WORD_SPLIT #п©я─п╬п╠п╣п╩я▀ п╨п╟п╨ п╡ bash
setopt ALWAYS_TO_END
if [ -e $HOME/.ssh/known_hosts ] ; then
  hosts=(${${${(f)"$(<$HOME/.ssh/known_hosts)"}%%\ *}%%,*})
  zstyle ':completion:*:hosts' hosts $hosts
fi

typeset -U path cdpath fpath manpath

autoload -U predict-on
zle -N predict-on
zle -N predict-off
bindkey "^X^Z" predict-on # C-x C-z
bindkey "^Z" predict-off # C-z

autoload -U zcalc zed

export HISTFILE=~/.zsh_history
export HISTSIZE=1000
export SAVEHIST=1000
setopt APPEND_HISTORY HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS

bindkey '^[[3~' delete-char
#bindkey '^E' expand-cmd-path
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey "\e[4~" end-of-line
bindkey '^[[A' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward

alias df='df -h'
alias du='du -sh'
alias grep='egrep --color=auto'
alias ls='ls --color=auto -F'
alias vi='vim'
alias xterm='xterm -bg black -bd red -bw 5'

PATH=$PATH:~/bin
export OOO_FORCE_DESKTOP=kde4
export EDITOR="vim"
export SDL_AUDIODRIVER="alsa"
autoload colors zsh/terminfo
colors
        if [[ "$terminfo[colors]" -ge 8 ]]; then
                colors
        fi
    for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
        eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
        eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'
        (( count = $count + 1 ))
    done
PR_NO_COLOUR="%{$terminfo[sgr0]%}"
#PS1="[%{$fg[yellow]%}%n%{$reset_color%}@%{$fg[cyan]%}%m %{$fg[yellow]%}%1~%{$reset_color%}]$ % "
