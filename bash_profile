#!/bin/bash

export PATH=$PATH:/usr/local/sbin
export TERM="xterm-256color"

if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi

if [ -f ~/.bash_figure ]; then
    source ~/.bash_figure
fi
