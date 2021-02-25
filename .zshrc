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
antigen bundle softmoth/zsh-vim-mode
antigen bundle hlissner/zsh-autopair

# Load the theme.
#antigen theme mh
antigen theme romkatv/powerlevel10k

# Tell Antigen that you're done.
antigen apply

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source ~/.fzf-tab-completion/zsh/fzf-zsh-completion.sh
eval "$(fasd --init auto)"
source ~/.zce/zce.zsh

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=241"
bindkey '^O' fzf_completion
zstyle ':zce:*' bg 'fg=241'
zstyle ':zce:*' fg 'fg=160,bold'
bindkey '^s' zce
setupsolarized dircolors.ansi-dark

export BAT_THEME='Solarized (dark)'
export PATH=$PATH:~/bin
export LESS="-F -X $LESS"

alias cv="tput cnorm"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
