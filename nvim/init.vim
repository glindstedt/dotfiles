"
" Vimrc
"

language en_US.UTF-8

" PLUGINS ---------------------------------------------------------------- {{{

" Begin vim-plug
call plug#begin('~/.local/share/nvim/plugged')

" Theme
" Plug 'morhetz/gruvbox'
" Plug 'mhartington/oceanic-next'

" Environment
Plug 'scrooloose/nerdtree', { 'on': ['NERDTree','NERDTreeToggle'] }
Plug 'scrooloose/syntastic'
Plug 'kien/ctrlp.vim'
Plug 'mg979/vim-visual-multi'
Plug 'ervandew/supertab'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'benekastah/neomake'
Plug 'kana/vim-arpeggio'
Plug 'airblade/vim-rooter'
Plug 'KabbAmine/zeavim.vim'
Plug 'jaxbot/semantic-highlight.vim'

" CoC
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Fish
Plug 'dag/vim-fish'

" Language specifics

" Pandoc
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'

" Rust
Plug 'wting/rust.vim'

" Jinja
Plug 'lepture/vim-jinja'

" Ansible
Plug 'pearofducks/ansible-vim'

" Git integration
Plug 'tpope/vim-fugitive'

" jsonnet
Plug 'google/vim-jsonnet'

" Dhall
Plug 'vmchale/dhall-vim'

" terraform
Plug 'hashivim/vim-terraform'

" UltiSnips
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" Nginx
Plug 'chr4/nginx.vim'

" Bazel
Plug 'bazelbuild/vim-ft-bzl'

" Varnish
Plug 'fgsch/vim-varnish'

" jq
Plug 'vito-c/jq.vim'

" Julia
Plug 'JuliaEditorSupport/julia-vim'

" Meson
Plug 'igankevich/mesonic'

call plug#end()

" END PLUGINS }}}

" BASIC SETTINGS --------------------------------------------------------- {{{

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
    finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set backup          " keep a backup file
set history=50      " keep 50 lines of command line history
set ruler           " show the cursor position all the time
set showcmd         " display incomplete commands
set incsearch       " do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

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

" Set window title
set title

" Set shell
set shell=/usr/local/bin/fish

" Enable hidden buffers, i.e. don't abandon buffer on close
set hidden

" Sets message options
set shortmess=atI

" Show more autocompletion
set wildmode=list:longest

" Set characters for displaying whitespace
set listchars=tab:>-,trail:·,eol:$

" Set better case handling when searching
set ignorecase
set smartcase

" Scroll earlier if cursor goes off screen
set scrolloff=3

" Set max amount of tabs to 50
set tabpagemax=50

" Set backup directory
set backupdir=~/.vim_tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim_tmp,~/.tmp,~/tmp,/var/tmp,/tmp

" Preserve existing indent structure
set copyindent
set preserveindent

" Indentation
let b:tabwidth=4
let &tabstop=b:tabwidth
let &shiftwidth=b:tabwidth
set softtabstop=-1      " When negative the the value of 'shiftwidth' is used
set expandtab

syntax on
filetype plugin indent on

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
            \ | wincmd p | diffthis
endif

" Highlight columns over 80
if exists('+colorcolumn')
    set colorcolumn=80
    highlight ColorColumn ctermbg=darkgrey
else
    highlight OverLength ctermbg=darkred ctermfg=grey guibg=#592929
    match OverLength /\%81v.\+/
endif

" VIM-LATEX SETTINGS ----------------------------------------------------- {{{

" IMPORTANT: win32 users will need to have 'shellslash' set so that latex
" can be called correctly.
" set shellslash

" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse Latex-Suite. Set your grep
" program to always generate a file-name.
set grepprg=grep\ -nH\ $*

" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'

" END VIM-LATEX SETTINGS }}}

" END BASIC SETTINGS }}}

" PLUGIN SETTINGS -------------------------------------------------------- {{{

" Colour Theme {

" Contrast settings
" let g:gruvbox_contrast_light='hard'
" let g:gruvbox_contrast_dark='medium'

" TODO work in progress

function! GetRunningOS()
    if has("win32")
        return "win"
    endif
    if has("unix")
        if system('uname -s')=='Darwin'
            return "mac"
        else
            return "linux"
        endif
    endif
endfunction
let os=GetRunningOS()

" Enable true color support
if has("nvim")
    if has ("unix")
        let s:uname = system("uname -s")
        if s:uname == "Darwin"
            " let $NVIM_TUI_ENABLE_TRUE_COLOR=1
        else
            " This doesn't work in iterm2 for some reason
        endif
    endif
endif

let g:airline_theme='bubblegum'

" Color Scheme
" colorscheme gruvbox
" colorscheme OceanicNext

" Default scheme
set background=dark

" If you want to customize the terminal color scheme, here's how:
" let g:terminal_color_0  = '#2e3436'
" let g:terminal_color_1  = '#cc0000'
" let g:terminal_color_2  = '#4e9a06'
" let g:terminal_color_3  = '#c4a000'
" let g:terminal_color_4  = '#3465a4'
" let g:terminal_color_5  = '#75507b'
" let g:terminal_color_6  = '#0b939b'
" let g:terminal_color_7  = '#d3d7cf'
" let g:terminal_color_8  = '#555753'
" let g:terminal_color_9  = '#ef2929'
" let g:terminal_color_10 = '#8ae234'
" let g:terminal_color_11 = '#fce94f'
" let g:terminal_color_12 = '#729fcf'
" let g:terminal_color_13 = '#ad7fa8'
" let g:terminal_color_14 = '#00f5e9'
" let g:terminal_color_15 = '#eeeeec'

" }

" Airline config

" Make airline appear always, even on non-focused windows
set laststatus=2

" Enable powerline fonts
let g:airline_powerline_fonts=1

" NERDTree

" DOESN'T WORK!!!!
" call NERDTreeHighlightFile('python', 'green', 'none', 'green', '#151515')
" call NERDTreeHighlightFile('ini', 'yellow', 'none', 'yellow', '#151515')
" call NERDTreeHighlightFile('md', 'blue', 'none', '#3366FF', '#151515')
" call NERDTreeHighlightFile('yml', 'yellow', 'none', 'yellow', '#151515')
" call NERDTreeHighlightFile('config', 'yellow', 'none', 'yellow', '#151515')
" call NERDTreeHighlightFile('conf', 'yellow', 'none', 'yellow', '#151515')
" call NERDTreeHighlightFile('json', 'yellow', 'none', 'yellow', '#151515')
" call NERDTreeHighlightFile('html', 'yellow', 'none', 'yellow', '#151515')
" call NERDTreeHighlightFile('styl', 'cyan', 'none', 'cyan', '#151515')
" call NERDTreeHighlightFile('css', 'cyan', 'none', 'cyan', '#151515')
" call NERDTreeHighlightFile('coffee', 'Red', 'none', 'red', '#151515')
" call NERDTreeHighlightFile('lua', 'Red', 'none', '#ffa500', '#151515')
" call NERDTreeHighlightFile('c', 'Magenta', 'none', '#ff00ff', '#151515')


" Syntastic java
let g:syntastic_java_javac_config_file_enabled = 1
let g:syntastic_python_checkers = ['flake8']

" Jsonnet fmt
let g:jsonnet_fmt_options = '--indent 4 --string-style d --comment-style s'

" Terraform fmt
let g:terraform_fmt_on_save=1

" END PLUGIN SETTINGS }}}

" FUNCTIONS -------------------------------------------------------------- {{{

" Function to remove the trailing whitespace in an abbreviation
function! EatChar(pattern)
    let c = nr2char(getchar(0))
    return (c =~ a:pattern) ? '' : c
endfunction

" Toggle real tabs or spaces for indentation
function! TabToggle()
    if &expandtab
        set noexpandtab
    else
        set expandtab
    endif
endfunction

" Set the indentation level to 'indent'
function! SetIndent(indent)
    let b:tabwidth=a:indent
    let &tabstop=b:tabwidth
    let &shiftwidth=b:tabwidth
    if &expandtab
        let &softtabstop=b:tabwidth
    endif
endfunction

" END FUNCTIONS }}}

" MAPPINGS --------------------------------------------------------------- {{{

" Set leading key for user defined commands
let mapleader = ","

" Set leading key for filetype specific commands
let maplocalleader = "\\"

" Open .vimrc for editing
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
" Source .vimrc
nnoremap <leader>sv :source $MYVIMRC<cr>

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" TODO: huh? Duplicates :S
" Make current word uppercase in insert mode
inoremap <c-u> <esc>gUiw`]a

" Remove line in insert mode
inoremap <c-d> <esc>cc

" Don't use Ex mode, use Q for formatting
nnoremap Q gq

" Hide search highlighting
nnoremap <silent> <leader>m :silent :nohlsearch<cr>

" Show trailing whitespace
nnoremap <silent> <leader>w :set nolist!<cr>

" Move lines up and down
nnoremap - ddp
nnoremap _ ddkP

" Make scroll faster
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

" Search for selection in visual mode
vnoremap * y/<C-R>"<cr>

" Make window navigation easier with the neovim terminal
if has("nvim")
    tnoremap <A-h> <C-\><C-n><C-w>h
    tnoremap <A-j> <C-\><C-n><C-w>j
    tnoremap <A-k> <C-\><C-n><C-w>k
    tnoremap <A-l> <C-\><C-n><C-w>l
    tnoremap <A-n> <C-\><C-n>gt
    tnoremap <A-p> <C-\><C-n>gT
    tnoremap <A-v> <C-\><C-n><C-w>v
    tnoremap <A-s> <C-\><C-n><C-w>s
    tnoremap <A-t> <C-\><C-n>:tabnew<cr>
endif
nnoremap ˙ <C-w>h
nnoremap ∆ <C-w>j
nnoremap ˚ <C-w>k
nnoremap ¬ <C-w>l
nnoremap ’ <esc>gt
nnoremap ” <esc>gT
vnoremap <A-h> <C-w>h
vnoremap <A-j> <C-w>j
vnoremap <A-k> <C-w>k
vnoremap <A-l> <C-w>l
vnoremap <A-n> <esc>gt
vnoremap <A-p> <esc>gT

" Window control
nnoremap <A--> <C-w>-
nnoremap <A-+> <C-w>+
nnoremap <A-<> <C-w><
nnoremap <A->> <C-w>>
nnoremap <A-s> <C-w>s
nnoremap <A-v> <C-w>v
nnoremap <A-c> <C-w>c
nnoremap <A-t> <esc>:tabnew<cr>

vnoremap <A--> <C-w>-
vnoremap <A-+> <C-w>+
vnoremap <A-<> <C-w><
vnoremap <A->> <C-w>>
vnoremap <A-s> <C-w>s
vnoremap <A-v> <C-w>v
vnoremap <A-c> <C-w>c
vnoremap <A-t> <esc>:tabnew<cr>

" Surround a word with things
nnoremap <leader>s" viw<esc>a"<esc>hbi"<esc>lel
nnoremap <leader>s' viw<esc>a'<esc>hbi'<esc>lel
nnoremap <leader>s( viw<esc>a)<esc>hbi(<esc>lel
nnoremap <leader>s[ viw<esc>a]<esc>hbi[<esc>lel
nnoremap <leader>s{ viw<esc>a}<esc>hbi{<esc>lel
nnoremap <leader>s< viw<esc>a><esc>hbi<<esc>lel

vnoremap <leader>s" <esc>`<i"<esc>`>lli"<esc>l
vnoremap <leader>s' <esc>`<i'<esc>`>lli'<esc>l
vnoremap <leader>s( <esc>`<i(<esc>`>lli)<esc>l
vnoremap <leader>s[ <esc>`<i[<esc>`>lli]<esc>l
vnoremap <leader>s{ <esc>`<i}<esc>`>lli}<esc>l
vnoremap <leader>s< <esc>`<i<<esc>`>lli><esc>l

" Operator-pending next inner thing
" see :help omap-info for reason for <C-u>
onoremap in" :<C-u>normal! f"vi"<cr>
onoremap in' :<C-u>normal! f'vi'<cr>
onoremap in( :<C-u>normal! f(vi(<cr>
onoremap in[ :<C-u>normal! f[vi[<cr>
onoremap in{ :<C-u>normal! f{vi{<cr>
onoremap in< :<C-u>normal! f<vi<<cr>

" Indentation toggle and set indent level
nnoremap <silent> <leader>it mz:execute TabToggle()<cr>'z
nnoremap <silent> <leader>i2 mz:execute SetIndent(2)<cr>'z
nnoremap <silent> <leader>i4 mz:execute SetIndent(4)<cr>'z
nnoremap <silent> <leader>i6 mz:execute SetIndent(6)<cr>'z
nnoremap <silent> <leader>i8 mz:execute SetIndent(8)<cr>'z

" END MAPPINGS }}}

" PLUGIN MAPPINGS -------------------------------------------------------- {{{

" NERDtree mapping
nnoremap <silent> <leader>n :NERDTreeToggle<cr>

" vim-plug mappings
nnoremap <silent> <leader>pi :PlugInstall<cr>
nnoremap <silent> <leader>pu :PlugUpdate<cr>
nnoremap <silent> <leader>pc :PlugClean<cr>
nnoremap <silent> <leader>pd :PlugDiff<cr>
nnoremap <silent> <leader>ps :PlugStatus<cr>
nnoremap <silent> <leader>pp :PlugUpgrade<cr>

" vim-arpeggio
call arpeggio#map('i', '', 0, 'jk', '<esc>')

" Taskwarrior

nnoremap <silent> <leader>tn :TW next<cr>
nnoremap <silent> <leader>tl :TW list<cr>
nnoremap <silent> <leader>ts :TWSync<cr>

" vim-fugitive (Git)
nnoremap <silent> <leader>gs :Gstatus<cr>
nnoremap <silent> <leader>gc :Gcommit<cr>
nnoremap <silent> <leader>gw :Gwrite<cr>
nnoremap <silent> <leader>gr :Gread<cr>
nnoremap <silent> <leader>gd :Gdiff<cr>
nnoremap <silent> <leader>gm :Gmove<space>
nnoremap <silent> <leader>gb :Gblame<cr>


" END PLUGIN MAPPINGS }}}

" ABBREVIATIONS ---------------------------------------------------------- {{{

" Email abbreviation
iabbrev @@ gustaflindstedt@gmail.com
" Signature abbreviation
iabbrev ssig Gustaf Lindstedt<cr>gustaflindstedt@gmail.com

" END ABBREVIATIONS }}}

" AUTOCOMMANDS ----------------------------------------------------------- {{{

" Only do this part when compiled with support for autocommands.
if has("autocmd")

    " Use the default filetype settings, so that mail gets 'tw' set to 72,
    " 'cindent' is on in C files, etc.

    " Put these in an autocmd group, so that we can delete them easily.
    augroup vimrcEx
        au!

        " For all text files set 'textwidth' to 80 characters.
        autocmd FileType text setlocal textwidth=80

        " When editing a file, always jump to the last known cursor position.
        " Don't do it when the position is invalid or when inside an event
        " handler (happens when dropping a file on gvim).  Also don't do it
        " when the mark is in the first line, that is the default position
        " when opening a file.
        autocmd BufReadPost *
          \ if line("'\"") > 1 && line("'\"") <= line("$") |
          \   exe "normal! g`\"" |
          \ endif

    augroup END

    aug vimrc_filetypes
        au!
        " OpenGL shader syntax highlight
        au BufNewFile,BufRead *.frag,*.vert,*.fp,*.vp,*.glsl,*.shader setf glsl
        au BufNewFile,BufRead *.minij setf java
    aug END

    aug filetype_vim
        au!
        au FileType vim setlocal foldmethod=marker
    aug END

    aug filetype_nix
        au!
        au FileType nix setlocal foldmethod=marker
    aug END

    aug filetype_tex
        au!
        au FileType tex setlocal textwidth=80
        au FileType tex setlocal spell
    aug END

    aug filetype_pandoc
        au!
        au FileType pandoc setlocal textwidth=80
        au FileType pandoc setlocal nospell
    aug END

    aug filetype_yaml
        au!
        au FileType yaml call SetIndent(2)
    aug END

    aug vimrc_snippets
        au!

        " Set comment out line mappings
        au FileType *      nnoremap <buffer> <leader>cc I// <esc>
        au FileType *      nnoremap <buffer> <leader>cr I<esc>d3l
        au FileType bash   nnoremap <buffer> <leader>cc I# <esc>
        au FileType python nnoremap <buffer> <leader>cc I# <esc>
        au FileType vim    nnoremap <buffer> <leader>cc I" <esc>
        au FileType lua    nnoremap <buffer> <leader>cc I-- <esc>

        " SNIPPETS {{{
        au FileType c,cpp :iabbrev <buffer> printf
            \ printf();<left><left><C-r>=EatChar('[\s\r]*')<cr>

        au FileType c,cpp :iabbrev <buffer> iff
            \ if () {<cr>
            \}<up><right><right><right><C-r>=EatChar('[\s\r]*')<cr>

        au FileType c,cpp :iabbrev <buffer> iffe
            \ if () {<cr>
            \} else {<cr>
            \}<up><up><right><right><right><C-r>=EatChar('[\s\r]*')<cr>

        au FileType c,cpp :iabbrev <buffer> ifif
            \ if () {<cr>
            \} else if () {<cr>
            \} else {<cr>
            \}<up><up><up><right><right><right><C-r>=EatChar('[\s\r]*')<cr>

        au FileType lua :iabbrev <buffer> func
            \ function()<cr>
            \end<up><right><right><right><right><right>

        " END SNIPPETS }}}

    aug END

    aug vimrc_greeting
        au!
        au vimenter * echom "   >^.^< ---(meow)"
    aug END

    " aug vimrc_rooter
        " Changes the directory to root of project every time a buffer is
        " entered (is there a better way??)
        " uses the vim-rooter plugin
        " DOESN'T WORK
        " au!
        " au bufenter * silent :Rooter
    " aug END

    " aug vimrc_nerdtree_open_on_empty
    "     au!
    "     au StdinReadPre * let s:std_in=1
    "     au VimEnter * if (argc() == 0 && !exists("s:std_in")) | NERDTree
    " aug END

else

  " Always set autoindenting on
  set autoindent

endif " has("autocmd")

" END AUTOCOMMANDS }}}
