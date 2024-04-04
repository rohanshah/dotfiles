#!/bin/bash

PS1='$ '

export PATH=$PATH:/usr/local/sbin

export PATH="$PATH:$HOME/.cargo/env"

export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"

export TERM="xterm-256color"

export HISTCONTROL=ignoreboth:erasedups

if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi

if [ -f ~/.bash_penn ]; then
    source ~/.bash_penn
fi
