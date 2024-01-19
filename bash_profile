#!/bin/bash

export PATH=$PATH:/usr/local/sbin
export PATH="$PATH:$HOME/.cargo/env"
export TERM="xterm-256color"

export HISTCONTROL=ignoreboth:erasedups

if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi

if [ -f ~/.bash_figure ]; then
    source ~/.bash_figure
fi
. "$HOME/.cargo/env"
