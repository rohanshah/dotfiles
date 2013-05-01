" Rohan's vimrc
" --------------

execute pathogen#infect()

												" disable arrow keys in normal mode
" nmap <up> <nop>
" nmap <down> <nop>
" nmap <left> <nop>
" nmap <right> <nop>
" imap <up> <nop>
" imap <down> <nop>
" imap <left> <nop>
" imap <right> <nop>

												" TAB SETTINGS
set autoindent									" uses indent from the current line as indent for new line
set tabstop=4									" how many columns a tab counts for
set shiftwidth=4								" how many columns text is indendented with the reindent operations
set smarttab									" uses the value of shiftwidth when inserting or deleting tabs
noremap \t :setlocal expandtab!<CR>				" change tabs to spaces for current file only

												" SEARCH SETTINGS
set incsearch									" incremental search (i.e. search while typing)
set hlsearch									" highlights searched text
set ignorecase									" ignore case on searches
set smartcase									" override ignore case when search has uppercase in it
nmap \q :nohlsearch<CR>							" mapping to turn off highlighting
nnoremap * *``									" super * search does not jump to next result

												" MISCELLANEOUS SETTINGS
syntax enable									" enable syntax highlighting
filetype on										" enable filetype detection
filetype plugin on								" enable filetype detection
highlight Pmenu ctermfg=blue ctermbg=white		" coloring for Pmenu (used in autocomplete)
set maxmempattern=2000000 						" increase max memory for patterns because svgs are huge and cause vim to break
set wrap! 										" don't wrap lines because I hate that
set rnu 										" relative line numbers
set hidden 										" only hide the file when switching buffers otherwise it will not retain its undo history
map <F3> :NERDTreeToggle<CR>					" Toggle NERDTree on and off
set backspace=2 								" this makes backspace actually work in insert mode for some reason

												" STATUS LINE
set laststatus=2								" always show the status line
set statusline=%t\ 								" tail of the filename with space after
set statusline+=%m								" modified flag
set statusline+=%r								" read only flag
set statusline+=%=								" left/right separator
set statusline+=line\ %l\ of\ %L 				" current line and total lines
