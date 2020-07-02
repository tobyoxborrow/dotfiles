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
set nomodeline     " Do not use modelines, common security risk
"set modelines=3    " The number of lines that is checked for set commands
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

set autowrite   " Save file when running :make (and :GoBuild)


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

" map ,bu to write all buffers with changes
nnoremap <leader>bu :bufdo update<CR>

" map ,gb to GoBuild; ,gr to GoRun; ,gi to GoInfo
autocmd FileType go nmap <leader>gb <Plug>(go-build)
autocmd FileType go nmap <leader>gr <Plug>(go-run)
autocmd FileType go nmap <leader>gi <Plug>(go-info)

" maps to kill current buffer, quickfix, location and preview windows
nnoremap <leader>kb :bdelete<CR>
nnoremap <leader>kq :cclose<CR>
nnoremap <leader>kl :lclose<CR>
nnoremap <leader>kp :pclose<CR>

" map ,p* for CtrlP modes
nnoremap <leader>pb :CtrlPBuffer<CR>
" nnoremap <leader>pm :CtrlPMixed<CR>
nnoremap <leader>pm :CtrlPMRU<CR>
" nnoremap <leader>pt :CtrlPTag<CR>
nnoremap <leader>pf :CtrlPCurWD<CR>

" map ,r to start the vim-ripgrep plugin
nnoremap <leader>r :Rg<SPACE>

" map ,s to turn on English spell check
" :help spell
" Builtin: ]s (next misspelling), [s (prev), z= (suggest), zg (add)
nnoremap <leader>s :setlocal spell spelllang=en_gb<CR>

" map ,t to call TrimWhiteSpace()
nnoremap <leader>t :call TrimWhiteSpace()<CR>

" re-map visual-mode indenting to not lose the selection
vnoremap < <gv
vnoremap > >gv

" map ctrl+<movement> to move around windows with one less key
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h

" re-map tab to match parens
map <tab> %

" keep search matches in the middle of the window
nnoremap n nzzzv
nnoremap N Nzzzv


" Plugins ----------------------------------------------------------------

" Use vim-plug for plugins
" Installation instructions, see https://github.com/junegunn/vim-plug
" Or run:
" ~ curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
"      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
" Fresh install: plugins need to be installed with ":PlugInstall"
if filereadable(glob('~/.vim/autoload/plug.vim'))
    " Plugin list
    call plug#begin('~/.vim/plugged')

    " sensible.vim: Defaults everyone can agree on
    Plug 'https://github.com/tpope/vim-sensible'

    " Essential Stupid
    Plug 'https://github.com/koron/nyancat-vim'

    " lean & mean status/tabline for vim that's light as air
    " :help vim-airline
    Plug 'https://github.com/bling/vim-airline'

    " theme repository for vim-airline
    Plug 'https://github.com/vim-airline/vim-airline-themes'

    " one colorscheme pack to rule them all!
    Plug 'https://github.com/flazz/vim-colorschemes'

    " A Vim plugin which shows a git diff in the gutter (sign column) and
    " stages/reverts hunks
    " :help gitgutter
    Plug 'https://github.com/airblade/vim-gitgutter'

    " Plugin for transparent editing of gpg encrypted files.
    Plug 'https://github.com/vim-scripts/gnupg.vim'

    " helpers for UNIX
    Plug 'https://github.com/tpope/vim-eunuch'

    " fugitive.vim: a Git wrapper so awesome, it should be illegal
    " :help fugitive
    " Examples: :Gwrite, :Gblame, :Gcommit
    Plug 'https://github.com/tpope/vim-fugitive'

    " Vim motions on speed!
    " :help easymotion
    " Examples: ,,w (jump to start of word) ,,W (start of WORD)
    "           ,,e (end of word) ,,E (end of WORD)
    "           ,,fo (find letter o) ,,Fo (backwards)
    "           ,,j (line downward) ,,k (line upward)
    "           ,,n (next "/" or "?" match forward) ,,N (backward)
    Plug 'https://github.com/Lokaltog/vim-easymotion'

    " pairs of handy bracket mappings
    " :help unimpaired
    " Examples: [f (previous file in directory), ]f (next file)
    "           [<space> (add blank lines before), ]<space> (after)
    "           [e (exchange line, i.e. move up) ]e (move down)
    "           [b (previous buffer), ]b (next), [B (first)
    "           [q (previous quickfix), ]q (next), [Q (first), ]Q (last)
    "           [l (previous locationlist), ]l (next), [L (first), ]L (last)
    Plug 'https://github.com/tpope/vim-unimpaired'

    " Fuzzy file, buffer, mru, tag, etc finder.
    " :help ctrlp
    " Maps: ,pb (find buffer) ,pm (find in MRU) ,pf (find file in cwd)
    Plug 'https://github.com/ctrlpvim/ctrlp.vim'

    " Use RipGrep in Vim and display results in a quickfix list
    " Examples: :Rg <string|pattern>
    " Builtin: :cc (jump to err), :cr (first item), :cn (next), :cp (prev)
    " Unimpaired: [q (previous quickfix), ]q (next), [Q (first), ]Q (last)
    " Maps: ,r (`:Rg `) ,kq (kill quickfix window)
    Plug 'https://github.com/jremmen/vim-ripgrep'

    " Add additional support for Ansible in VIM
    " :help ansible
    Plug 'https://github.com/chase/vim-ansible-yaml'

    " Go development plugin for Vim
    " :help vim-go
    " Examples: :go-build, :go-run, :go-info
    " Maps: ,gb (:go-build); ,gr (:go-run); ,gi (go-info)
    Plug 'fatih/vim-go'

    " Vim configuration for Rust
    Plug 'rust-lang/rust.vim'

    " Syntax checking hacks for vim
    " :help syntastic
    " Errors will appear in vim's location list.
    " Builtin: :Errors, :lopen, :lclose, :ll (jump to loc), :lnext, :lprev
    " Unimpaired: [l (previous list item), ]l (next), [L (first), ]L (last)
    " Maps: ,kl (kill location list window)
    Plug 'https://github.com/scrooloose/syntastic'

    " YouCompleteMe - A code-completion engine for Vim
    " Requires cmake: `brew install cmake`
    " Requires dynamic python binary. For pyenv do:
    " env PYTHON_CONFIGURE_OPTS="--enable-framework" pyenv install 3.6.3
    " You must manually run install.py after installing with vim-plug
    " cd ~/.vim/plugged/YouCompleteMe/
    " ./install.py
    Plug 'https://github.com/Valloric/YouCompleteMe'

    call plug#end()

    " Plugin Configuration

    " Airline
    " don't use fancy symbols in airline
    " requires too much effort to display well in iTerm2 and I like it plain
    let g:airline_powerline_fonts = 0
    let g:airline_left_sep = ''
    let g:airline_right_sep = ''
    " airline theme
    let g:airline_theme = 'papercolor'
    " display buffers
    let g:airline#extensions#tabline#enabled = 1

    " CTRL+P
    " enable ctrl+p
    set runtimepath^=~/.vim/bundle/ctrlp.vim
    " Use the nearest .git directory as the cwd
    " This makes a lot of sense if you are working on a project that is in
    " version control. It also supports works with .svn, .hg, .bzr.
    let g:ctrlp_working_path_mode = 'r'

    " if the ripgrep executable is found, we can make use of that instead of
    " some command defaults
    if executable('rg')
        " ctrlp plugin
        let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
        let g:ctrlp_use_caching = 0
    endif

    " vim-ansible-yaml
    " do not auto-indent after a blank line to stop crazy stuff like:
    " - name: foo
    "   debug: msg="{{bar}}"
    "
    "   - name: baz
    let g:ansible_options = {'ignore_blank_lines': 0}

    " vim-go
    let g:go_fmt_command = "goimports"
    let g:go_addtags_transform = "camelcase"
    let g:go_highlight_types = 1
    let g:go_highlight_fields = 1
    let g:go_highlight_functions = 1
    let g:go_highlight_methods = 1
    let g:go_metalinter_autosave_enabled = ['vet', 'golint']
    " buggy? let g:go_auto_type_info = 1
    " buggy? let g:go_auto_sameids = 1

    " rust.vim
    " disable rust specific text width of 99, use value in vim instead
    let g:rust_recommended_style = 0

    " jedi-vim
    " disable autocompletion on dot (annoying)
    let g:jedi#popup_on_dot = 0

    " Syntastic
    " don't run syntastic on :wq which can cause an unnecessary delay
    let g:syntastic_check_on_wq = 0
    " enable gometalinter for golang files
    " go get -u github.com/alecthomas/gometalinter
    " gometalinter --install
    " let g:syntastic_go_checkers = ['gometalinter']
    " don't test the exit status, it seems broken with pylint 202002
    " syntastic would complain 'abnormal exit status' and show pylint output,
    " interrupting the editing workflow
    let g:syntastic_exit_checks = 0
    " Always populate vim's locationlist with errors
    let g:syntastic_always_populate_loc_list = 1

    " YouCompleteMe
    " let g:ycm_server_keep_logfiles = 1
    " let g:ycm_server_log_level = 'debug'
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

" enable nasm syntax highlighting for *.nasm files
au BufRead,BufNewFile *.nasm set filetype=nasm
