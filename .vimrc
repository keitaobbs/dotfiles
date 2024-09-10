""""""""""""""""""
"  vim-plug.vim  "
""""""""""""""""""
if has('vim_starting')
    set rtp+=~/.vim/plugged/vim-plug
    if !isdirectory(expand('~/.vim/plugged/vim-plug'))
        echo 'install vim-plug...'
        call system('mkdir -p ~/.vim/plugged/vim-plug')
        call system('git clone https://github.com/junegunn/vim-plug.git ~/.vim/plugged/vim-plug/autoload')
    endif
endif

call plug#begin('~/.vim/plugged')
    """""""""""""
    "  Editing  "
    """""""""""""
    Plug 'junegunn/vim-plug', {
        \ 'dir': '~/.vim/plugged/vim-plug/autoload'}
    " Display the indention levels with thin vertical lines
    Plug 'Yggdroot/indentLine'
    " Provide smart input assistant
    Plug 'kana/vim-smartinput'
    " Provide automatic closing of quotes, parenthesis, brackets, etc
    Plug 'Raimondi/delimitMate'
    " Trail whitespace in red and provide :FixWhitespace to fix it
    Plug 'bronson/vim-trailing-whitespace'
    " Alignment
    Plug 'junegunn/vim-easy-align'

    """""""""""""""
    "  Utilities  "
    """""""""""""""
    Plug 'scrooloose/nerdtree'
    Plug 'jistr/vim-nerdtree-tabs'
    Plug 'mbbill/undotree', {'on': 'UndotreeToggle'}
    Plug 'itchyny/lightline.vim'
    " Comment stuff out
    Plug 'tpope/vim-commentary'
    Plug 'machakann/vim-highlightedyank'
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'
    " Run your favorite search tool
    Plug 'mileszs/ack.vim'
    " Show git diff markers in the sign column
    Plug 'airblade/vim-gitgutter'
    " Git wrapper commands like ':Git blame'
    Plug 'tpope/vim-fugitive'
    " Run commands quickly
    Plug 'thinca/vim-quickrun'
    " Load local vimrc files (".lvimrc") in the tree (root dir up to current dir)
    Plug 'embear/vim-localvimrc'

    """"""""""""""""""""""""""""
    "  Completion and Linting  "
    """"""""""""""""""""""""""""
    " Snippet engine
    Plug 'SirVer/ultisnips'
    " Contain snippets files for various programming languages
    Plug 'honza/vim-snippets'

    " Check syntax asynchronously and fix files with Language Server Protocol (LSP) support
    Plug 'dense-analysis/ale'

    Plug 'aklt/plantuml-syntax'

    """"""""""
    "  Misc  "
    """"""""""
    Plug 'atelierbram/Base2Tone-vim'
    Plug 'zenbones-theme/zenbones.nvim'
call plug#end()


""""""""""""""
"  Filetype  "
""""""""""""""
filetype plugin indent on

" Indent settings for each filetype
augroup filetype_indent
    autocmd!
    autocmd BufNewFile,BufRead *.py setlocal tabstop=4 softtabstop=4 shiftwidth=4
    autocmd BufNewFile,BufRead *.rb setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.c setlocal tabstop=2 softtabstop=2 shiftwidth=2 noexpandtab
    autocmd BufNewFile,BufRead *.cc setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.cpp setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.h setlocal tabstop=2 softtabstop=2 shiftwidth=2 noexpandtab
    autocmd BufNewFile,BufRead *.hh setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.html setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.j2 setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.erb setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.hs setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.js setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.css setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.dart setlocal tabstop=2 softtabstop=2 shiftwidth=2
augroup END

" Color column settings for each filetype
augroup filetype_colorcolumn
    autocmd!
    set colorcolumn=101
    autocmd BufNewFile,BufRead COMMIT_EDITMSG set colorcolumn=73
augroup END

augroup annotation_highlight
  autocmd!
  autocmd WinEnter,BufRead,BufNew,Syntax * :silent! call matchadd('SuccessAnnot', '\(DONE\):')
  autocmd WinEnter,BufRead,BufNew,Syntax * :silent! call matchadd('DangerAnnot', '\(TODO\):')
  autocmd WinEnter,BufRead,BufNew,Syntax * :silent! call matchadd('WarningAnnot', '\(NOTE\):')
  autocmd WinEnter,BufRead,BufNew,Syntax * :silent! call matchadd('InfoAnnot', '\(INFO\|WIP\|BACKLOG\):')
  autocmd WinEnter,BufRead,BufNew,Syntax * highlight SuccessAnnot guibg=darkgreen guifg=White
  autocmd WinEnter,BufRead,BufNew,Syntax * highlight DangerAnnot guibg=darkred guifg=White
  autocmd WinEnter,BufRead,BufNew,Syntax * highlight WarningAnnot guibg=darkorange guifg=White
  autocmd WinEnter,BufRead,BufNew,Syntax * highlight InfoAnnot guibg=darkcyan guifg=White
augroup END

"""""""""""""
"  Editing  "
"""""""""""""
set encoding=utf-8
" This gives the end-of-line (<EOL>) formats
set fileformats=unix,dos,mac
" When a file has been detected to have been changed outside of Vim, automatically read it again
set autoread
set noerrorbells
" Keep the cursor in the same column after the commands like 'gg', 'G'
set nostartofline
" Number of spaces that a <Tab> in the file counts for
set tabstop=4
" Number of spaces that a <Tab> counts for while performing editing operations
set softtabstop=4
" Number of spaces to use for each step of (auto)indent
" When zero the 'tabstop' value will be used
set shiftwidth=0
" Use the appropriate number of spaces to insert a <Tab>
set expandtab
" Copy indent from current line when starting a new line
set autoindent
" Do smart autoindenting when starting a new line
set smartindent
" Minimal number of screen lines to keep above and below the cursor
set scrolloff=15
" Determines the maximum number of items to show in the popup menu for Insert mode completion
set pumheight=10
" Backspace behaviour
set backspace=indent,eol,start
" Help to avoid all the hit-enter prompts caused by file messages
set shortmess+=I
if has('nvim')
    set clipboard=unnamedplus
else
    set clipboard=unnamed,autoselect,unnamedplus
endif
" Enable the use of the mouse
set mouse=a
" Splitting a window will put the new window right of the current one
set splitright
" Splitting a window will put the new window below the current one
set splitbelow


""""""""
"  Ui  "
""""""""
syntax on
set number
set list
set listchars=tab:>-,trail:-,extends:>,precedes:<,nbsp:%
set ruler
set wrap
set title
set showcmd
set showmatch
set matchtime=1
set cursorline
" Change the way text is displayed
set display=lastline
set wildmenu
set wildmode=list:full
set wildignore=*.o,*.obj,*.pyc,*.so,*.dll


""""""""""""
"  Colors  "
""""""""""""
" If you have vim >=8.0 or Neovim >= 0.1.5
if has('termguicolors')
    set termguicolors
    if has('nvim')
        " https://github.com/neovim/neovim/wiki/FAQ
        set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor
    endif
endif

" For Neovim 0.1.3 and 0.1.4
let $NVIM_TUI_ENABLE_TRUE_COLOR=1

" Theme
set bg=dark
colorscheme nordbones
let g:lightline={
\   'colorscheme': 'nord',
\}

" Override background color of the colorscheme
" highlight Normal ctermbg=black guibg=black
" highlight NonText ctermbg=black guibg=black
" highlight LineNr ctermbg=black guibg=black
" highlight Folded ctermbg=black guibg=black
" highlight SpecialKey ctermbg=black guibg=black
" highlight EndOfBuffer ctermbg=black guibg=black
" highlight SignColumn ctermbg=black guibg=black

""""""""""""
"  Search  "
""""""""""""
" While typing a search command, show where the pattern, as it was typed so far, matches
set incsearch
set hlsearch
set ignorecase
" Override the 'ignorecase' option if the search pattern contains upper case characters
set smartcase
set wrapscan


"""""""""""
"  Cache  "
"""""""""""
if !has('nvim')
    set viminfo+=n~/.cache/vim/viminfo
endif
set dir=~/.cache/vim/swap
set noswapfile
set backup
set backupdir=~/.cache/vim/backup
set undofile
set undodir=~/.cache/vim/undo
for d in [&dir, &backupdir, &undodir]
  if !isdirectory(d)
    call mkdir(iconv(d, &encoding, &termencoding), 'p')
  endif
endfor


""""""""""""""""
"  Keybinding  "
""""""""""""""""
let mapleader="\<Space>"
let maplocalleader="\<Space>\<Space>"
nnoremap <Space> \
xnoremap <Space> \

noremap <S-l> $
noremap <S-h> ^
noremap j gj
noremap k gk
noremap gj j
noremap gk k
nnoremap db dT
" Remove dd delay due to 'nnoremap db dT'
nnoremap dd dd
noremap <S-j> }
noremap <S-k> {
noremap ; :
noremap : ;
noremap Caps_Lock Zenkaku_Hankaku
inoremap Caps_Lock Zenkaku_Hankaku
inoremap jj <ESC>

tnoremap <S-l> $
tnoremap <S-h> ^
tnoremap jj <ESC>

" completion
inoremap <C-j> <C-n>
inoremap <C-k> <C-p>

" tab
noremap <C-h> <C-w>h
noremap <C-l> <C-w>l
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
nnoremap sn gt
nnoremap sp gT
nnoremap st :<C-u>tabnew<CR>

" toggles
nnoremap <silent> <Leader>tb :Git blame<CR>
nnoremap <silent> <Leader>tf :NERDTreeToggle<CR>
nnoremap <silent> <Leader>tu :UndotreeToggle<CR>

" ctags
set tags=tags;,tag
set notagbsearch
" Jump to definition
nnoremap tj :exe('tjump '.expand('<cword>'))<CR>
" Move backwards in the tag stack
nnoremap tp :pop<CR>
" Move forwards in the tag stack
nnoremap tn :tag<CR>
nnoremap tv :vsp<CR> :exe('tjump '.expand('<cword>'))<CR>
nnoremap th :split<CR> :exe('tjump '.expand('<cword>'))<CR>
" Show tag list
nnoremap tl :ts<CR>
" Search tag
nnoremap ts :Tags <C-r>=expand('')<CR><CR>

" quickfix
nnoremap [q :cprevious<CR>
nnoremap ]q :cnext<CR>
nnoremap [Q :<C-u>cfirst<CR>
nnoremap ]Q :<C-u>clast<CR>

" ack
" Search results may leak into terminal so set/unset shellpipe properly
function AckSearch(string) abort
    let saved_shellpipe=&shellpipe
    let &shellpipe='>'
    try
        execute 'Ack!' shellescape(a:string, 1)
    finally
        let &shellpipe=saved_shellpipe
    endtry
endfunction

nnoremap <Leader>ack :call AckSearch("")<left><left>

" nerdtree
nnoremap <silent> <Leader>r :NERDTreeFind<CR><C-w><C-w>

" fzf
nnoremap <silent> <Leader>f :Files<CR>
nnoremap <silent> <Leader>g :GFiles?<CR>

" ultisnips
nnoremap <silent> <Leader>s :Snippets<CR>

" ale
nnoremap <silent> <Leader>ld :ALEDetail<CR>
nnoremap <silent> <Leader>lf :ALEFix<CR>


"""""""""""""""""""
"  Plugin Option  "
"""""""""""""""""""
" nerdtree
augroup nerdtree
    autocmd!
    autocmd StdinReadPre * let s:std_in=1
    autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif
    autocmd bufenter * if (winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree()) | q | endif
augroup END
let NERDTreeShowHidden=1
let g:NERDTreeIgnore=['\.DS_Store$', '\.git$', '\.svn$', '\.clean$', '\.swp$', '\.bak$', '\.hg$', '\.hgcheck$', '\~$']
let g:nerdtree_tabs_focus_on_files=1
let g:NERDTreeWinSize=20

" undotree
let g:undotree_WindowLayout=2

" fzf
let g:fzf_tags_command='ctags -R'

" quickrun
let g:my_quickrun_args=''
function! MyQuickRunSetArgs()
    let g:my_quickrun_args=input('Enter arguments: ')
endfunction
command! MyQuickRunSetArgs call MyQuickRunSetArgs()

function! MyQuickRunWithArgs()
    execute 'QuickRun -args "' . g:my_quickrun_args . '"'
endfunction
command! MyQuickRunWithArgs call MyQuickRunWithArgs()

nnoremap <silent> <Leader>qs :MyQuickRunSetArgs<CR>
nnoremap <silent> <Leader>qr :MyQuickRunWithArgs<CR>

let g:quickrun_config={
\   '*': {'split': 'vertical'},
\   'cpp': {'cmdopt': '--std=gnu++17'},
\   'python': {
\       'command': 'python3',
\       'exec': '%c %s %a',
\   },
\}

" vim-trailing-whitespace
augroup whitespace
    autocmd BufWritePre * :FixWhitespace
augroup END

" indentLine
let g:indentLine_setConceal=0

" easy-align
" Start interactive EasyAlign in visual mode
xmap ea <Plug>(EasyAlign)

" ultisnips
let g:UltiSnipsExpandTrigger='<TAB>'

" ale
" Only run linters named in ale_linters settings
let g:ale_linters_explicit=1
let g:ale_completion_enabled=1
let g:ale_sign_column_always=1
" https://github.com/dense-analysis/ale/blob/master/supported-tools.md
let g:ale_linters={
\   'c': ['gcc'],
\   'cpp': ['gcc --std=gnu++17'],
\   'ruby': ['rubocop'],
\   'rust': ['cargo'],
\}
let g:ale_fixers={
\   'ruby': ['rubocop'],
\   'cpp': ['clang-format'],
\   'rust': ['rustfmt'],
\}
" Lint only when files are saved
let g:ale_lint_on_text_changed='never'
let g:ale_lint_on_insert_leave=0
let g:ale_lint_on_enter=1

