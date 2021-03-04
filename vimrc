" Rohan's vimrc
" --------------

execute pathogen#infect()

                                                    " disable arrow keys in normal mode
nmap <up> <nop>
nmap <down> <nop>
nmap <left> <nop>
nmap <right> <nop>
"imap <up> <nop>
"imap <down> <nop>
"imap <left> <nop>
"imap <right> <nop>

                                                    " TAB SETTINGS
set autoindent                                      " uses indent from the current line as indent for new line
set tabstop=4                                       " how many columns a tab counts for
set shiftwidth=4                                    " how many columns text is indendented with the reindent operations
set smarttab                                        " uses the value of shiftwidth when inserting or deleting tabs
set expandtab                                       " tabs should be spaces by default
noremap \t :setlocal expandtab!<CR>                 " change spaced tabs to actual tabs for current file only

                                                    " LINE NUMBER SETTINGS
if version >= 703                                   " if the version is 7.03 or greater
    set rnu                                         " relative line numbers
else                                                " otherwise
    set nu                                          " line numbers
endif
noremap \n :setlocal invrelativenumber<CR>          " toggle relative line number bar on/off

                                                    " SEARCH SETTINGS
set incsearch                                       " incremental search (i.e. search while typing)
set hlsearch                                        " highlights searched text
set ignorecase                                      " ignore case on searches
set smartcase                                       " override ignore case when search has uppercase in it
nmap \q :nohlsearch<CR>                             " mapping to turn off highlighting


                                                    " SLIMUX CONFIGURATION
nnoremap <Leader>sl :SlimuxREPLSendLine<CR>         " sends the current line to another tumx pane
vnoremap <Leader>ss :SlimuxREPLSendSelection<CR>    " sends the current select to another tmux pane
nnoremap <leader>sb :SlimuxREPLSendBuffer<CR>       " sends the current buffer to another tmux pane

                                                    " STATUS LINE
set laststatus=2                                    " always show the status line
set statusline=%t\                                  " tail of the filename with space after
set statusline+=%m                                  " modified flag
set statusline+=%r                                  " read only flag
set statusline+=%h\                                 " help flag
set statusline+=%=                                  " left/right separator
set statusline+=[column:%c]                         " current column
set statusline+=[line:%l]                           " current line
set statusline+=[%p%%]                              " percentage through file

let g:ctrlp_max_files = 0
let g:ctrlp_max_depth = 30
let g:ctrlp_regexp = 1                              " default to regexp search
let g:ctrlp_custom_ignore = '\v[\/](target)$'       " ignore target directories


                                                    " MISCELLANEOUS SETTINGS
syntax enable                                       " enable syntax highlighting
filetype on                                         " enable filetype detection
filetype plugin on                                  " enable filetype detection
filetype plugin indent on                           " enable filetype detection
autocmd BufNewFile,BufRead *.nf set syntax=groovy   " Groovy syntax highlighting for Nextflow files
map <F12> :syntax enable<CR>                        " hot key to enable syntax highlighting
set autoread                                        " Auto-reload files that change on disk
au CursorHold * checktime
highlight Pmenu ctermfg=blue ctermbg=white          " coloring for Pmenu (used in autocomplete)
set maxmempattern=2000000                           " increase max memory for patterns because svgs are huge and cause vim to break
set wrap!                                           " don't wrap lines because I hate that
set hidden                                          " only hide the file when switching buffers otherwise it will not retain its undo history
map <F3> :NERDTreeToggle<CR>                        " Toggle NERDTree on and off
set backspace=2                                     " this makes backspace actually work in insert mode for some reason
set colorcolumn=81                                  " show colorcolumn -- lines of code should not be more that 80 characters
highlight ColorColumn ctermbg=lightblue             " make the colorcolumn white

set background=dark                                 " set solarized to use the dark backgroun
colorscheme solarized                               " make the colorscheme use solarize
