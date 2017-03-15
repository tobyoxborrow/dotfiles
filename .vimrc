" .vimrc
" Vim Configuration
" https://github.com/tobyoxborrow/dotfiles

" References:
" https://bitbucket.org/sjl/dotfiles/
" https://github.com/alanctkc/dotfiles/
" https://github.com/netdata/vim/

" Basic options --------------------------------------------------------

set encoding=utf-8

" indentation
set expandtab      " Use spaces, not tabs, for autoindent/tab key
set tabstop=4      " Tabs are four spaces wide
set shiftwidth=4   " Indent level is 4 spaces wide
set shiftround     " Round indent to multiple of shiftwidth when using > and <
set softtabstop=4  " <BS> over an autoindent deletes the spaces
set nosmartindent  " Use filetype-specific plugins for indentation
filetype plugin indent on

" but do not autoindent yaml files on the : character
"autocmd FileType yml setl indentkeys-=<:>
"autocmd FileType yml setl indentkeys-=<->

" allow backspacing over autoindent, EOL, and BOL
set backspace=indent,eol,start

" searching
" Perl style regex
nnoremap / /\v
vnoremap / /\v

set ignorecase     " Default to using case insensitive searches,
set smartcase      "  unless uppercase letters are used in the regex
set incsearch      " Incrementally search while typing a /regex
set showmatch      " Briefly jump to a paren once it's balanced
set hlsearch       " Highlight searches by default
set gdefault       " Set /g for :substitute (subst. all by default)
set matchtime=2    "  (for only .2 seconds).

" status line display
set laststatus=2   " Always show statusline, even if only 1 window
set ruler          " Show some info, even without statuslines
set shortmess+=a   " Use [+]/[RO]/[w] for modified/readonly/written
set showmode       " Show current mode (vim defaults to On)
set showcmd        " Show incomplete normal mode commands as I type
set report=0       " : commands always print changed line count
set confirm        " Y-N-C prompt if closing with unsaved changes

set title          " Set title of the window to the value of titlestring
set term=screen-256color
set ttyfast

"set vb t_vb=       " Disable all bells. I hate ringing/flashing
set visualbell
set hidden         " Hide modified buffers when they are abandoned
set scrolloff=3    " Keep 3 context lines above and below the cursor
set history=10000  " The number of command-lines that are remembered
set modelines=3    " The number of lines that is checked for set commands
set nonumber       " Do not display line numbers

if exists('+relativenumber')
    set norelativenumber       " Do not display relative line numbers
endif
"set undofile
"set undoreload=10000
"set lazyredraw

set wildmenu       " Menu completion in command mode on <Tab>
set wildmode=full
set wildignore+=.hg,.git,.svn " Version control
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg " Binary images
set wildignore+=*.swp,*.swo " Vim swap files
set wildignore+=*.pyc " Python byte code
set wildignore+=*.DS_Store " OSX bullshit

" store to the system keyboard
" actually, I don't like this, it is very annoying
"set clipboard=unnamed


" Backups and file locations ---------------------------------------------

" Make those folders automatically if they don't exist
set backupdir=~/.vim/tmp/backup// " backup files
if !isdirectory(expand(&backupdir))
    call mkdir(expand(&backupdir), "p")
endif
set directory=~/.vim/tmp/swap// " swap files
if !isdirectory(expand(&directory))
    call mkdir(expand(&directory), "p")
endif
if exists('+undodir')
    set undodir=~/.vim/tmp/undo// " undo files
    if !isdirectory(expand(&undodir))
        call mkdir(expand(&undodir), "p")
    endif
endif

set backup
set noswapfile


" Functions and autocommands ---------------------------------------------

" removes trailing spaces
function TrimWhiteSpace()
    %s/\s*$//
    ''
:endfunction

" returns to the same line when you reopen a file
augroup line_return
    au!
    au BufReadPost *
                \ if line("'\"") > 0 && line("'\"") <= line("$") |
                \       execute 'normal! g`"zvzz' |
                \ endif
augroup END


" Key Bindings -----------------------------------------------------------

" Use comma as leader
let mapleader = ','

" map ,a to start Ack
nnoremap <Leader>a :Ack<SPACE>--smart-case<SPACE>
" map ,b to close current buffer
nnoremap <Leader>b :bdelete<CR>
" map ,k to launch NERDTree
nnoremap <Leader>k :NERDTree<CR>
" map ,K to close NERDTree
nnoremap <Leader>K :NERDTreeClose<CR>
" map ,n to toggle relative line numbering
if exists('+relativenumber')
    nnoremap <Leader>n :set norelativenumber!<CR>
endif
" map ,P to paste from clipboard
set pastetoggle=<Leader>P
" map ,p to toggle paste mode
"nnoremap <Leader>p :set nopaste!<CR>
" map ,s to run sort
nnoremap <Leader>s :sort<CR>
" map ,t to call TrimWhiteSpace()
nnoremap <Leader>t :call TrimWhiteSpace()<CR>
" map ,u to write all buffers with changes
nnoremap <Leader>u :bufdo update<CR>
" map ,p to call CtrlP
nnoremap <leader>p :CtrlP<cr>
" additional mappings for CtrlP modes
nnoremap <leader>bb :CtrlPBuffer<cr>
nnoremap <leader>bm :CtrlPMixed<cr>
nnoremap <leader>bs :CtrlPMRU<cr>

" re-map visual-mode indenting to not lose the selection
vnoremap < <gv
vnoremap > >gv

" map ctrl+<movement> to move around windows with one less key
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h

" clear search highlighting
noremap <silent> <leader><space> :noh<cr>:call clearmatches()<cr>

" re-map tab to match parens
map <tab> %

" keep search matches in the middle of the window
nnoremap n nzzzv
nnoremap N Nzzzv


" Plugins ----------------------------------------------------------------

" Use vim-plug for plugins
" https://github.com/junegunn/vim-plug
" Fresh install: plugins need to be installed with ":PlugInstall"
if filereadable(glob('~/.vim/autoload/plug.vim'))
    " Plugin list
    call plug#begin('~/.vim/plugged')

    " Fuzzy file, buffer, mru, tag, etc finder.
    "Plug 'https://github.com/kien/ctrlp.vim.git'
    Plug 'https://github.com/ctrlpvim/ctrlp.vim'
    " A tree explorer plugin for vim.
    "Plug 'https://github.com/scrooloose/nerdtree'
    " Puppet niceties for your Vim setup
    "Plug 'https://github.com/rodjek/vim-puppet'
    " Semantic Highlighting for Vim http://jaxbot.me/
    "Plug 'https://github.com/jaxbot/semantic-highlight.vim'
    " Syntax checking hacks for vim
    Plug 'https://github.com/scrooloose/syntastic'
    " Vim script for text filtering and alignment
    "Plug 'https://github.com/godlygeek/tabular'
    " lean & mean status/tabline for vim that's light as air
    Plug 'https://github.com/bling/vim-airline'
    " theme repository for vim-airline
    Plug 'https://github.com/vim-airline/vim-airline-themes'
    " one colorscheme pack to rule them all!
    Plug 'https://github.com/flazz/vim-colorschemes'
    " fugitive.vim: a Git wrapper so awesome, it should be illegal
    Plug 'https://github.com/tpope/vim-fugitive'
    " sensible.vim: Defaults everyone can agree on
    Plug 'https://github.com/tpope/vim-sensible'
    " Plugin for transparent editing of gpg encrypted files.
    Plug 'https://github.com/vim-scripts/gnupg.vim'
    " use CTRL-A/CTRL-X to increment dates, times, and more
    "Plug 'https://github.com/tpope/vim-speeddating'
    " comment stuff out
    "Plug 'https://github.com/tpope/vim-commentary'
    " Smart Space key for Vim
    "Plug 'https://github.com/spiiph/vim-space'
    " helpers for UNIX
    Plug 'https://github.com/tpope/vim-eunuch'
    " pairs of handy bracket mappings
    Plug 'https://github.com/tpope/vim-unimpaired'
    " Essential Stupid
    Plug 'https://github.com/koron/nyancat-vim'
    "  Vim plugin for the Perl module / CLI script 'ack'
    Plug 'https://github.com/mileszs/ack.vim'
    " Vim motions on speed!
    Plug 'https://github.com/Lokaltog/vim-easymotion'
    " Next generation completion framework after neocomplcache
    " Requires lua - brew install vim --with-lua
    Plug 'https://github.com/Shougo/neocomplete.vim'
    " A Vim plugin which shows a git diff in the gutter (sign column) and
    " stages/reverts hunks
    Plug 'https://github.com/airblade/vim-gitgutter'
    " Uncover usage problems in your writing
    "Plug 'https://github.com/reedes/vim-wordy'
    " Easy note taking in Vim http://peterodding.com/code/vim/notes/
    "Plug 'https://github.com/xolox/vim-notes'
    " Miscellaneous auto-load Vim scripts http://peterodding.com/code/vim/misc/
    Plug 'https://github.com/xolox/vim-misc'
    " Add additional support for Ansible in VIM
    Plug 'https://github.com/chase/vim-ansible-yaml'
    " allows you to find and replace occurrences in many buffers being aware
    " of the context
    "Plug 'https://github.com/pelodelfuego/vim-swoop'
    " Source code browser (supports C/C++, java, perl, python, tcl, sql, php,
    " etc)
    Plug 'https://github.com/vim-scripts/taglist.vim'

    call plug#end()

    " Plugin Configuration
    " Airline
    " do not use the fancy symbols in airline
    let g:airline_powerline_fonts = 0
    " don't use fancy symbols in airline (if they don't display well in iTerm2)
    let g:airline_left_sep=''
    let g:airline_right_sep=''
    " airline theme
    let g:airline_theme='papercolor'
    " display buffers
    let g:airline#extensions#tabline#enabled = 1

    " Syntastic
    " don't run syntastic on :wq which can cause an unnecessary delay
    let g:syntastic_check_on_wq=0

    " CTRL+P
    " enable ctrl+p
    set runtimepath^=~/.vim/bundle/ctrlp.vim

    " Use the nearest .git directory as the cwd
    " This makes a lot of sense if you are working on a project that is in version
    " control. It also supports works with .svn, .hg, .bzr.
    let g:ctrlp_working_path_mode = 'r'

    " Semantic highlight colours
    " run RebuildSemanticColors to flush the cache
    "let g:semanticTermColors = [28,1,2,3,4,5,6,7,25,9,10,34,12,13,14,15,16,125,124,19]

    " neocomplete
    " Disable AutoComplPop.
    let g:acp_enableAtStartup = 0
    " Use neocomplete.
    let g:neocomplete#enable_at_startup = 1
    " Use smartcase.
    let g:neocomplete#enable_smart_case = 1
    " Set minimum syntax keyword length.
    let g:neocomplete#sources#syntax#min_keyword_length = 3
    let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
    " automatically close tip window after selection is made
    autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
    autocmd InsertLeave * if pumvisible() == 0|pclose|endif

    " vim-ansible-yaml do not auto-indent after a blank line
    " to stop crazy stuff like:
    " - name: foo
    "   debug: msg="{{bar}}"
    "
    "   - name: baz
    let g:ansible_options = {'ignore_blank_lines': 0}
endif


" Colours ----------------------------------------------------------------

" highlight trailing whitespace (must come before 'colorscheme')
autocmd ColorScheme * highlight TrailingWhitespace ctermbg=red guibg=red
au InsertLeave * match TrailingWhitespace /\s\+$/

syntax enable
set synmaxcol=800      " Don't try to highlight lines this long

" Use 256 colours in colourschemes
set t_Co=256

" hint we are using a light background
" some themes will act on this
"set background=light

try
    colorscheme pencil
catch
    colorscheme desert
endtry

" disable any background colour set by the theme
" that is only useful in gvim
hi Normal guibg=NONE ctermbg=NONE

" fix for puppet syntax and ctags based on:
" https://github.com/netdata/vim/blob/master/vimrc
"set iskeyword=-,:,@,48-57,_,192-255

" mark column 80 (must come after 'colorscheme')
if exists('+colorcolumn')
    set colorcolumn=80
    hi ColorColumn ctermbg=grey guibg=grey
endif
