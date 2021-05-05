# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Set up the prompt

autoload -Uz promptinit
promptinit
prompt adam1

setopt histignorealldups sharehistory

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

ANTIGEN_CACHE=false
VIM_MODE_VICMD_KEY='^j'
source ~/.zsh/antigen/antigen.zsh

#Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
#antigen bundle git
#antigen bundle heroku
#antigen bundle pip
#antigen bundle lein
#antigen bundle command-not-found
antigen bundle extract

# External bundle.
antigen bundle zlsun/solarized-man
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle joel-porquet/zsh-dircolors-solarized.git
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle hlissner/zsh-autopair

# Load the theme.
antigen theme romkatv/powerlevel10k

# Tell Antigen that you're done.
antigen apply

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source ~/.fzf-tab-completion/zsh/fzf-zsh-completion.sh
eval "$(fasd --init auto)"
source ~/.zce/zce.zsh

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=230"
ZSH_HIGHLIGHT_STYLES[comment]=fg=230
bindkey '^O' fzf_completion
zstyle ':zce:*' bg 'fg=11'
zstyle ':zce:*' fg 'fg=1,bold'
bindkey '^s' zce
setupsolarized dircolors.ansi-dark

_gen_fzf_default_opts() {
  local base03="8"
  local base02="0"
  local base01="10"
  local base00="11"
  local base0="12"
  local base1="14"
  local base2="7"
  local base3="15"
  local yellow="3"
  local orange="9"
  local red="1"
  local magenta="5"
  local violet="13"
  local blue="4"
  local cyan="6"
  local green="2"

  # Comment and uncomment below for the light theme.

  # Solarized Dark color scheme for fzf
  export FZF_DEFAULT_OPTS="
    --color fg:-1,bg:-1,hl:$blue,fg+:$base2,bg+:$base02,hl+:$blue
    --color info:$yellow,prompt:$yellow,pointer:$base3,marker:$base3,spinner:$yellow
  "
  ## Solarized Light color scheme for fzf
  #export FZF_DEFAULT_OPTS="
  #  --color fg:-1,bg:-1,hl:$blue,fg+:$base02,bg+:$base2,hl+:$blue
  #  --color info:$yellow,prompt:$yellow,pointer:$base03,marker:$base03,spinner:$yellow
  #"
}
_gen_fzf_default_opts
export FZF_DEFAULT_OPTS="--bind=alt-j:preview-down,alt-k:preview-up $FZF_DEFAULT_OPTS"

function dirdiff()
{
  # Shell-escape each path:
  DIR1=$(printf '%q' "$1"); shift
  DIR2=$(printf '%q' "$1"); shift
  vim $@ -c "DirDiff $DIR1 $DIR2"
}

function rg {
  local IFS=$'\t\n'
  local tempfile="$(mktemp -t tmp.XXXXXX)"
  local ranger_cmd=(
    command
    ranger
    --cmd="map Q chain shell echo %d > "$tempfile"; quitall"
  )

  ${ranger_cmd[@]} "$@"
  if [[ -f "$tempfile" ]] && [[ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]]; then
    cd -- "$(cat "$tempfile")" || return
  fi
  command rm -f -- "$tempfile" 2>/dev/null
}

export BAT_THEME='Solarized'
export LESS="-F -X $LESS"
export PATH=$PATH:~/bin
export PATH="/home/panxiangrong/.git-fuzzy/bin:$PATH"
export TLDR_HEADER='magenta bold underline'
export TLDR_QUOTE='italic'
export TLDR_DESCRIPTION='gray'
export TLDR_CODE='green'
export TLDR_PARAM='green'
export CHTSH_QUERY_OPTIONS="style=solarized-dark"
export TZ='Asia/Shanghai'

alias cv="tput cnorm"
alias gh="group-hosts"
alias sa="$HOME/.tmux-butler/scripts/snippetdb put"
alias sr="$HOME/bin/snippetdb-remove.sh"
alias info="info --vi-keys"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[[ -s "/home/panxiangrong/.gvm/scripts/gvm" ]] && source "/home/panxiangrong/.gvm/scripts/gvm"
