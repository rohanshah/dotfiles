# Aliases, shared by zsh and bash.

##### Listing #####

alias l='ls -l'
alias la='ls -lah'

##### System #####

# macOS has no `free`; vm_stat is the closest equivalent.
alias memory='vm_stat'
alias space='df -h'

alias caffeine='caffeinate -disu -t 1000000000'
alias password='pwgen --num-passwords=1 -snc'

##### Editor #####

# All real editor config is neovim, so send every spelling there.
alias vim='nvim'
alias vi='nvim'
alias bim='nvim'
alias im='nvim'

##### Git #####

alias ga='git add -p'
alias gb='git branch'
alias gc='git commit -m'
alias gd='git diff'
alias gs='git status'

alias push='git push -u origin HEAD'
alias pull='git pull'

alias clean-branches="git branch | sed -E '/main|master|\*|development|develop|dev/d' | xargs git branch -D"

##### Misc #####

alias uuid="uuidgen | tr -d '\n' | tr '[:upper:]' '[:lower:]' | xargs echo"
alias datetime='date +"%Y%m%d%H%M%S"'

# GNU grep (brew `grep`), needed for the -P perl-regexp mode used by g().
alias grep='ggrep'
