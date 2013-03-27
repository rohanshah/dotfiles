" Rohan's vimrc
" --------------

execute pathogen#infect()

" Disable arrow keys in normal mode
" nmap <up> <nop>
" nmap <down> <nop>
" nmap <left> <nop>
" nmap <right> <nop>
" imap <up> <nop>
" imap <down> <nop>
" imap <left> <nop>
" imap <right> <nop>

" Tab settings
set autoindent		" uses indent from the current line as indent for new line
set tabstop=4		" how many columns a tab counts for
set shiftwidth=4	" how many columns text is indendented with the reindent operations
set smarttab		" uses the value of shiftwidth when inserting or deleting tabs
noremap \t :setlocal expandtab!<CR> 	"change tabs to spaces for current file only

" Search settings
set incsearch	" incremental search (i.e. search while typing)
set hlsearch	" highlights searched text
set ignorecase	" ignore case on searches
set smartcase	" override ignore case when search has uppercase in it
nmap \q :nohlsearch<CR>	" mapping to turn off highlighting

" Backspace settings
set backspace=2

" Misc. settings
syntax enable	" enable syntax highlighting
filetype on		" enable filetype detection
filetype plugin on
highlight Pmenu ctermfg=blue ctermbg=white	" coloring for Pmenu (used in autocomplete)
set maxmempattern=2000000 " this is because svgs are huge
set wrap! " Don't wrap lines I hate that
set statusline=%t%m%r\ \|\ [%{strlen(&ft)?&ft:'none'}][%{&ff}][%{strlen(&fenc)?&fenc:'none'}]%=line\ %l\ of\ %L " Set status line
set rnu " relative line numbers
set hidden " Only hide the file when switching buffers otherwise it will not retain its undo history
map <F3> :NERDTreeToggle<CR>

" Status Line
set laststatus=2		" always show the status line
set statusline=%t\      " tail of the filename with space after
set statusline+=%m      " modified flag
set statusline+=%r      " read only flag
set statusline+=%=      " left/right separator
set statusline+=line\ %l\ of\ %L   " current line and total lines
