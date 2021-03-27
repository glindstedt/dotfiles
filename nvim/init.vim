"
" Vimrc
"

language en_US.UTF-8

" PLUGINS ---------------------------------------------------------------- {{{

" Begin vim-plug
call plug#begin('~/.local/share/nvim/plugged')

Plug 'arcticicestudio/nord-vim'

" Basic
Plug 'scrooloose/nerdtree', { 'on': ['NERDTree','NERDTreeToggle'] }
Plug 'airblade/vim-rooter'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'scrooloose/syntastic'
Plug 'mg979/vim-visual-multi'
" Plug 'ervandew/supertab'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'jaxbot/semantic-highlight.vim'

" Airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Language Server Protocol
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/lsp_extensions.nvim'
Plug 'nvim-lua/completion-nvim'

" Language specifics

" Fish
Plug 'georgewitteman/vim-fish'

" Pandoc
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'

" Rust
Plug 'rust-lang/rust.vim'

" TOML
Plug 'cespare/vim-toml'

" Jinja
Plug 'lepture/vim-jinja'

" Ansible
Plug 'pearofducks/ansible-vim'

" Git integration
Plug 'tpope/vim-fugitive'

" jsonnet
Plug 'google/vim-jsonnet'

" terraform
Plug 'hashivim/vim-terraform'

" UltiSnips
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" Nginx
Plug 'chr4/nginx.vim'

" Bazel
Plug 'bazelbuild/vim-ft-bzl'

" jq
Plug 'vito-c/jq.vim'

" Julia
Plug 'JuliaEditorSupport/julia-vim'

" Meson
Plug 'igankevich/mesonic'

" GLSL
Plug 'tikhomirov/vim-glsl'

call plug#end()

" END PLUGINS }}}

" BASIC SETTINGS --------------------------------------------------------- {{{

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
set shell=fish

" Enable hidden buffers, i.e. don't abandon buffer on close
set hidden

" Sets message options
" set shortmess=atI

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

" END BASIC SETTINGS }}}

" PLUGIN SETTINGS -------------------------------------------------------- {{{

" Colour Theme {

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

" Default scheme
" colorscheme nord

" hi Pmenu ctermbg=59
" hi Comment ctermfg=8

" set background=dark

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
let g:airline_theme='deus'

" Make airline appear always, even on non-focused windows
set laststatus=2

" Enable powerline fonts
let g:airline_powerline_fonts=1

" Syntastic
let g:syntastic_java_javac_config_file_enabled = 1
let g:syntastic_python_checkers = ['flake8']

" Supertab
" let g:SuperTabDefaultCompletionType = "<c-n>"

" Semantic Highlight
" TODO make pretty
"let s:semanticGUIColors = [28,1,2,3,4,5,6,7,25,9,10,34,12,13,14,15,16,125,124,19]
"let s:semanticGUIColors = [ '#72d572', '#c5e1a5', '#e6ee9c', '#fff59d', '#ffe082', '#ffcc80', '#ffab91', '#bcaaa4', '#b0bec5', '#ffa726', '#ff8a65', '#f9bdbb', '#f9bdbb', '#f8bbd0', '#e1bee7', '#d1c4e9', '#ffe0b2', '#c5cae9', '#d0d9ff', '#b3e5fc', '#b2ebf2', '#b2dfdb', '#a3e9a4', '#dcedc8' , '#f0f4c3', '#ffb74d' ]

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

else

  " Always set autoindenting on
  set autoindent

endif " has("autocmd")

" END AUTOCOMMANDS }}}

" {{{ LANGUAGE SERVER PROTOCOL

" Set completeopt to have a better completion experience
" :help completeopt
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
set completeopt=menuone,noinsert,noselect

" Avoid showing extra messages when using completion
set shortmess+=c

" Set updatetime for CursorHold
" 300ms of no cursor movement to trigger CursorHold
set updatetime=1000
" Show diagnostic popup on cursor hold
autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()

" Goto previous/next diagnostic warning/error
nnoremap <silent> g[    :lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> g]    :lua vim.lsp.diagnostic.goto_next()<CR>

nnoremap <silent> gD    :lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> :lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   :lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    :lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0    :lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    :lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> gd    :lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> ga    :lua vim.lsp.buf.code_action()<CR>

" Configure LSP
" https://github.com/neovim/nvim-lspconfig#rust_analyzer
lua <<EOF

-- nvim_lsp object
local nvim_lsp = require'lspconfig'

-- function to attach completion when setting up lsp
local on_attach = function(client)
    require'completion'.on_attach(client)
end

-- Enable rust_analyzer
nvim_lsp.rust_analyzer.setup({
    on_attach=on_attach,
    settings={
        ["rust-analyzer"] = {
            cargo = {
                -- needed for procMacro.enable = true
                loadOutDirsFromCheck = true
            },
            diagnostics = {
                enable = true,
                enableExperimental = true,
            },
            procMacro = {
                enable = null
            },
        },
    }
})

-- Enable diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = true,
    signs = true,
    update_in_insert = true,
  }
)
EOF

" Enable type inlay hints
autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *
\ lua require'lsp_extensions'.inlay_hints{ prefix = '', highlight = "Comment", enabled = {"TypeHint", "ChainingHint", "ParameterHint"}}

" END LANGUAGE SERVER PROTOCOL }}}
