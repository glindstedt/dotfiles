"
" Vimrc
"

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif


" Egna settings
set hidden

" Set leading key for user defined commands
let mapleader = ","

runtime macros/matchit.vim

" Show more autocompletion
set wildmode=list:longest

" Set better case handling when searching
set ignorecase
set smartcase

" Set window title
set title

" Scroll earlier if cursor goes off screen
set scrolloff=3

" Set max amount of tabs to 50
set tabpagemax=50

" Set backup directory
set backupdir=~/.vim_tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim_tmp,~/.tmp,~/tmp,/var/tmp,/tmp

" Make scroll faster
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

" Map hide search highlighting to <,-n>
nmap <silent> <leader>n :silent :nohlsearch<CR>

" Map show trailing whitespace to <,-s>
set listchars=tab:>-,trail:·,eol:$
nmap <silent> <leader>s :set nolist!<CR>

" Sets message options
set shortmess=atI

" INDENTATION ----------------------------

" Preserve existing indent structure
set copyindent
set preserveindent

let b:tabwidth=4
let &tabstop=b:tabwidth
let &shiftwidth=b:tabwidth
let &softtabstop=b:tabwidth
set expandtab

function TabToggle()
    if &expandtab
        let &shiftwidth=b:tabwidth
        set softtabstop=0
        set noexpandtab
    else
        let &shiftwidth=b:tabwidth
        let &softtabstop=b:tabwidth
        set expandtab
    endif
endfunction

function SetIndent(indent)
	let b:tabwidth=a:indent
	let &tabstop=b:tabwidth
	let &shiftwidth=b:tabwidth
	if &expandtab
		let &softtabstop=b:tabwidth
	endif
endfunction

nmap <silent> <leader>t mz:execute TabToggle()<CR>'z
nmap <silent> <leader>2 mz:execute SetIndent(2)<CR>'z
nmap <silent> <leader>4 mz:execute SetIndent(4)<CR>'z
nmap <silent> <leader>6 mz:execute SetIndent(6)<CR>'z
nmap <silent> <leader>8 mz:execute SetIndent(8)<CR>'z

" Highlight columns over 80
if exists('+colorcolumn')
	set colorcolumn=80
	highlight ColorColumn ctermbg=darkgrey
else
	highlight OverLength ctermbg=darkred ctermfg=grey guibg=#592929
	match OverLength /\%81v.\+/
endif

" VIM-LATEX SETTINGS -------------------------------------------------

" REQUIRED. This makes vim invoke Latex-Suite when you open a tex file.
" filetype plugin on

" IMPORTANT: win32 users will need to have 'shellslash' set so that latex
" can be called correctly.
" set shellslash

" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse Latex-Suite. Set your grep
" program to always generate a file-name.
set grepprg=grep\ -nH\ $*

" OPTIONAL: This enables automatic indentation as you type.
" filetype indent on

" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'

" VUNDLE -------------------------------------------------------------
filetype off " dunno why.
set rtp+=~/.vim/bundle/Vundle.vim
set shell=/bin/bash " lots of errors if fish is used
call vundle#begin()

" manage Vundle with Vundle :P
Plugin 'gmarik/Vundle.vim'

Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'kien/ctrlp.vim'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'ervandew/supertab'
Plugin 'tpope/vim-surround'
Plugin 'bling/vim-airline'

" Coffeescript
Bundle 'kchmck/vim-coffee-script'

" { Clojure
" Syntax highligh & indent
Plugin 'guns/vim-clojure-static'
Plugin 'kien/rainbow_parentheses.vim'
" Repl, requires cider/cider-nrepl plugin for leiningen
Plugin 'tpope/vim-fireplace'

" }

call vundle#end()

" Pathogen ------------------------------------------
"execute pathogen#infect()
"execute pathogen#helptags()
syntax on
filetype plugin indent on

" Solarized
" set background=dark
" colorscheme solarized

" Make airline appear always
set laststatus=2

" NERDTree ------------------------------------------
"autocmd vimenter * if !argc() | NERDTree | endif
" autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" OpenGL shader syntax highlight
au BufNewFile,BufRead *.frag,*.vert,*.fp,*.vp,*.glsl,*.shader setf glsl 

au BufNewFile,BufRead *.minij setf java
au BufNewFile,BufRead *.yaml,*.yml so ~/.vim/yaml.vim
