#!/bin/bash
sudo apt-get install zsh
mkdir -p ~/.zsh/antigen
curl -L git.io/antigen > ~/.zsh/antigen/antigen.zsh
git clone https://github.com/xarronpan/fzf-tab-completion ~/.fzf-tab-completion
