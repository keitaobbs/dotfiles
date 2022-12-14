""""""""""""""""""
"  variables  "
""""""""""""""""""
let host_var = $HOME
let python3_host_prog_var = expand('~/.pyenv/versions/3.7.4/envs/develop/bin/python')


""""""""""""""""""
"  vim-plug.vim  "
""""""""""""""""""
" python3 path
let g:python3_host_prog = python3_host_prog_var

if has('vim_starting')
    set rtp+=~/.vim/plugged/vim-plug
    if !isdirectory(expand('~/.vim/plugged/vim-plug'))
        echo 'install vim-plug...'
        call system('mkdir -p ~/.vim/plugged/vim-plug')
        call system('git clone https://github.com/junegunn/vim-plug.git ~/.vim/plugged/vim-plug/autoload')
    endif
endif

call plug#begin('~/.vim/plugged')
    " editing
    Plug 'junegunn/vim-plug', {
        \ 'dir': '~/.vim/plugged/vim-plug/autoload'}
    Plug 'Yggdroot/indentLine'
    Plug 'kana/vim-smartinput'
    Plug 'kana/vim-textobj-user' | Plug 'kana/vim-textobj-line'
    Plug 'Raimondi/delimitMate'
    Plug 'kana/vim-operator-user' | Plug 'rhysd/vim-operator-surround'
    Plug 'bronson/vim-trailing-whitespace'
    Plug 'junegunn/vim-easy-align'
    Plug 'osyo-manga/vim-over'

    " utilities
    Plug 'scrooloose/nerdtree'
    Plug 'jistr/vim-nerdtree-tabs'
    Plug 'mbbill/undotree', {'on': 'UndotreeToggle'}
    Plug 'vim-airline/vim-airline' | Plug 'vim-airline/vim-airline-themes'
    Plug 'tpope/vim-commentary'
    Plug 'machakann/vim-highlightedyank'
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'
    " ag.vim is already deprecated so use mileszs/ack.vim
    Plug 'rking/ag.vim'
    Plug 'airblade/vim-gitgutter'
    Plug 'tpope/vim-fugitive'
    Plug 'thinca/vim-quickrun'
    Plug 'majutsushi/tagbar'

    " completion and linting
    Plug 'SirVer/ultisnips'
    " Snippets are separated from the engine. Add this if you want them:
    Plug 'honza/vim-snippets'
    Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}

    " plantuml
    Plug 'aklt/plantuml-syntax'

    " colorschemes
    Plug 'atelierbram/Base2Tone-vim'

    Plug 'junegunn/goyo.vim'

    " filetype
call plug#end()


""""""""""""""""""""
"  Initialization  "
""""""""""""""""""""
" vimrc???autocmd??????????????????
augroup vimrc
    autocmd!
augroup END


""""""""""""""
"  filetype  "
""""""""""""""
filetype plugin indent on


"""""""""""""
"  Editing  "
"""""""""""""
set encoding=utf-8
set fileformats=unix,dos,mac
set autoread
set noerrorbells
set nostartofline
" ????????????????????????1??????????????????
set tabstop=4
" ?????????????????????????????????1???????????????????????????????????????
set softtabstop=4
" ???????????????????????????????????????????????????
set shiftwidth=4
" tab????????????????????????????????????????????????
set expandtab
" ????????????????????????????????????????????????
set autoindent
" {?????????????????????????????????1?????????????????????????????????????????????
set smartindent

" filetype?????????????????????????????????
augroup fileTypeIndent
    autocmd!
    autocmd BufNewFile,BufRead *.py setlocal tabstop=4 softtabstop=4 shiftwidth=4
    autocmd BufNewFile,BufRead *.rb setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.c setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.cc setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.cpp setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.h setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.hh setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.html setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.j2 setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.erb setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.hs setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.js setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.css setlocal tabstop=2 softtabstop=2 shiftwidth=2
augroup END

" ???????????????????????????
set scrolloff=15
" ????????????????????????
set pumheight=10
" ?????????????????????????????????
set backspace=indent,eol,start
" ????????????????????????????????????
set shortmess+=I
" ?????????????????????????????????
set clipboard&
" ?????????????????????????????????
if has("nvim")
    set clipboard=unnamedplus
else
    set clipboard=unnamed,autoselect,unnamedplus
endif
set mouse=a
" ?????????????????????????????????????????????????????????????????????
set splitright


""""""""
"  Ui  "
""""""""
syntax on
set number
" ????????????????????????
set list
set listchars=tab:>-,trail:-,extends:>,precedes:<,nbsp:%
set ruler
set wrap
set title
set mouse=a
set showcmd
set showmatch
set matchtime=1
set cursorline
set display=lastline
set wildmenu
set wildmode=list:full
set wildignore=*.o,*.obj,*.pyc,*.so,*.dll
set conceallevel=0

" show whitespace errors
hi link WhitespaceError Error
au vimrc Syntax * syn match WhitespaceError /\s\+$\| \+\ze\t/


""""""""""""
"  Colors  "
""""""""""""
" colors
" If you have vim >=8.0 or Neovim >= 0.1.5
if (has("termguicolors"))
    set termguicolors
    if has('nvim')
    " https://github.com/neovim/neovim/wiki/FAQ
    set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor
    endif
endif

" For Neovim 0.1.3 and 0.1.4
let $NVIM_TUI_ENABLE_TRUE_COLOR=1

" Theme
syntax enable
set bg=dark
" colorscheme Base2Tone_MeadowDark
colorscheme Base2Tone_LakeDark
" colorscheme hybrid

highlight Normal ctermbg=NONE guibg=NONE
highlight NonText ctermbg=NONE guibg=NONE
highlight LineNr ctermbg=NONE guibg=NONE
highlight Folded ctermbg=NONE guibg=NONE
highlight SpecialKey ctermbg=NONE guibg=NONE
highlight EndOfBuffer ctermbg=NONE guibg=NONE

augroup TransparentBG
    autocmd!
    autocmd Colorscheme * highlight Normal ctermbg=NONE guibg=NONE
    autocmd Colorscheme * highlight NonText ctermbg=NONE guibg=NONE
    autocmd Colorscheme * highlight LineNr ctermbg=NONE guibg=NONE
    autocmd Colorscheme * highlight Folded ctermbg=NONE guibg=NONE
    autocmd Colorscheme * highlight SpecialKey ctermbg=NONE guibg=NONE
    autocmd Colorscheme * highlight EndOfBuffer ctermbg=NONE guibg=NONE
augroup END


""""""""""""
"  Search  "
""""""""""""
" ?????????????????????????????????
set incsearch
" ????????????????????????????????????
set hlsearch
" ????????????????????????????????????
set ignorecase
" ????????????????????????????????????????????????ignorecase??????????????????
set smartcase
" ???????????????????????????????????????????????????????????????????????????????????????
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
for s:d in [&dir, &backupdir, &undodir]
  if !isdirectory(s:d)
    call mkdir(iconv(s:d, &encoding, &termencoding), 'p')
  endif
endfor


"""""""""""""""""
"  Keybindings  "
"""""""""""""""""
" Leader key
let mapleader="\<Space>"
" filetype plugin??????????????????Leader key
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
" nnoremap db dT????????????????????????dd?????????????????????
nnoremap dd dd
noremap <S-j> }
noremap <S-k> {
noremap ; :
noremap : ;
noremap Caps_Lock Zenkaku_Hankaku
inoremap Caps_Lock Zenkaku_Hankaku
inoremap jj <ESC>
inoremap <silent> <expr> <C-j> pumvisible() ? "\<C-n>" : "\<C-x>\<C-o>"
inoremap <silent> <expr> <C-k> pumvisible() ? "\<C-p>" : "\<C-x>\<C-o>"

tnoremap <S-l> $
tnoremap <S-h> ^
tnoremap jj <ESC>
tnoremap tt <C-\><C-n>

" tab
noremap <C-h> <C-w>h
noremap <C-l> <C-w>l
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
nnoremap sn gt
nnoremap sp gT
nnoremap st :<C-u>tabnew<CR>

" toggles
nnoremap <silent> <Leader>tf :NERDTreeToggle<CR>
nnoremap <silent> <Leader>tu :UndotreeToggle<CR>

" ctags
set tags=tags;,tag
set notagbsearch
" ????????????????????????????????????????????????????????????????????????????????????
nnoremap tj :exe("tjump ".expand('<cword>'))<CR>
" tag stack ????????? -> tp(tag pop)?????????tb???????????????????????????
nnoremap tb :pop<CR>
" tag stack ?????????
nnoremap tn :tag<CR>
" ????????????????????????????????????????????????
nnoremap tv :vsp<CR> :exe("tjump ".expand('<cword>'))<CR>
" ????????????????????????????????????????????????
nnoremap th :split<CR> :exe("tjump ".expand('<cword>'))<CR>
" tag list ?????????
nnoremap tl :ts<CR>
" tag ????????????????????????????????????
nnoremap ts :Tags <C-r>=expand("")<CR><CR>

" quickfix
nnoremap [q :cprevious<CR>
nnoremap ]q :cnext<CR>
nnoremap [Q :<C-u>cfirst<CR>
nnoremap ]Q :<C-u>clast<CR>

augroup QfAutoCommands
    autocmd!
    autocmd QuickFixCmdPost *grep* cwindow
    " Auto-close quickfix window
    autocmd WinEnter * if (winnr('$') == 1) && (getbufvar(winbufnr(0), '&buftype')) == 'quickfix' | quit | endif
augroup END

" ag
if executable('ag')
    let g:ag_working_path_mode="r"
    nnoremap <Leader>ag :Ag --follow --nocolor --nogroup --hidden -S ""<Left>
endif

" tagbar
nnoremap <silent> <Leader>b :TagbarToggle<CR>

" NERDTree
nnoremap <silent> <Leader>r :NERDTreeFind<CR><C-w><C-w>

" Shortcut
nnoremap <silent> <Leader>f :Files<CR>
nnoremap <silent> <Leader>g :GFiles?<CR>


""""""""""""""""""
"  Plugin option "
""""""""""""""""""
" vim-operator-surround
" operator mappings
map <silent>sa <Plug>(operator-surround-append)
map <silent>sd <Plug>(operator-surround-delete)
map <silent>sr <Plug>(operator-surround-replace)

" nerdtree
augroup NERDTreeAutoCommands
    autocmd!
    autocmd StdinReadPre * let s:std_in=1
    autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
    " TODO: ?????????????????????????????????NERDTree???Find??????????????????
augroup END
" ???????????????????????????
let NERDTreeShowHidden = 1
let g:NERDTreeIgnore = ['\.DS_Store$', '\.git$', '\.svn$', '\.clean$', '\.swp$', '\.bak$', '\.hg$', '\.hgcheck$', '\~$']
let g:nerdtree_tabs_focus_on_files = 1
let g:NERDTreeWinSize = 20

" undotree
let g:undotree_WindowLayout=2

" airline
let g:airline_skip_empty_sections=1
if $USE_POWERLINE
    let g:airline_powerline_fonts=1
endif

" fzf
let g:fzf_tags_command = 'ctags -R'

" Let <Tab> also do completion
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

" quickrun
nnoremap <silent> <Leader>p :QuickRun<CR>
let g:quickrun_config={'*': {'split': 'vertical'}}

" vim-trailing-whitespace
augroup WhiteSpaceCommands
    autocmd BufWritePre * :FixWhitespace
augroup END

" ultisnips
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
let g:UltiSnipsSnippetDirectories=[$HOME.'/.vim/UltiSnips']
let g:UltiSnipsEditSplit="vertical"

" indentLine
let g:indentLine_setConceal = 0

" tagbar
let g:tagbar_width = 30
let g:tagbar_autoshowtag = 1
set statusline=%F%m%r%h%w\%=%{tagbar#currenttag('[%s]','')}\[Pos=%v,%l]\[Len=%L]

" easy-align
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" over
nnoremap <silent> <Leader>m :OverCommandLine<CR>
" ?????????????????????????????????????????????????????????
nnoremap sub :OverCommandLine<CR>%s/<C-r><C-w>//g<Left><Left>

" coc
" use <c-space>for trigger completion
inoremap <silent><expr> <c-space> coc#refresh()
inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'

"""""""""""""
" filetype  "
"""""""""""""

""""""""
" MISC "
""""""""
" To show
let g:vim_markdown_conceal = 0
