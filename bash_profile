#!/bin/bash

PS1='$ '

export PATH=$PATH:/usr/local/sbin

export PATH="$PATH:$HOME/.cargo/env"

export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"

export PATH="$PATH:/Users/rohan/.gem/ruby/2.6.0/bin"

# export TERM="xterm-256color"

export HISTCONTROL=ignoreboth:erasedups

if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi

if [ -f ~/.bash_penn ]; then
    source ~/.bash_penn
fi

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/rohan/.lmstudio/bin"
# End of LM Studio CLI section

