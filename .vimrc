scriptencoding utf-8
set encoding=utf-8
set fileformat=unix
set fileformats=unix,dos
set nocompatible
set showmode

filetype plugin indent on    " required

" Colors
set t_Co=256
syntax on
hi Normal ctermbg=234

filetype indent on
" set autoindent width to 4 spaces (see
" " " http://www.vim.org/tips/tip.php?tip_id=83)
" set et
" set sw=4
set smarttab
set relativenumber

set autoread
set backspace=indent,eol,start
set history=100
set undolevels=100
set directory=~/.vim-tmp,/tmp
set ignorecase
set smartcase
set backupcopy=yes
set scrolloff=2

" Status line
set laststatus=2
set statusline=
set statusline+=%m\ 
set statusline+=\"%F\"\ 
set statusline+=%c,\ %l\/\%L\  
set statusline+=\ chr(%b)
set statusline+=\ [%{&ff=='unix'?'unix':(&ff=='mac'?'mac':'windows')}]
set statusline+=\ [%{&fenc!=''?&fenc:&enc}]
set statusline+=\ %n\ 

" Status line colors
hi StatusLine term=bold ctermbg=238 ctermfg=189
au InsertEnter * hi StatusLine ctermbg=238 ctermfg=189
au InsertChange * hi StatusLine ctermbg=238 ctermfg=189
au InsertLeave * hi StatusLine ctermbg=238 ctermfg=189

let g:jsx_ext_required = 0 " Allow JSX in normal JS files

" ALE settings
let g:ale_linters_explicit = 1
let g:ale_linter_aliases = {'typescriptreact': 'typescript'}
let g:ale_linters = {'javascript': ['prettier', 'eslint'], 'typescript': ['prettier', 'tsserver', 'tslint'], 'php': ['php']}
let g:ale_fixers = {'json': ['prettier'], 'javascript': ['prettier', 'eslint'], 'typescript': ['prettier', 'eslint'],  'css': ['prettier'], 'scss': ['prettier'], 'sass': ['prettier'], 'less': ['prettier']}
let g:ale_fix_on_save = 1

" Turn on spell check for certain filetypes automatically
" autocmd BufRead,BufNewFile *.md setlocal spell spelllang=en_us
" autocmd BufRead,BufNewFile *.txt setlocal spell spelllang=en_us
" autocmd FileType gitcommit setlocal spell spelllang=en_us

" Remap the leader to <Space>
let mapleader="\<Space>"

" Save all buffers
nnoremap <leader>w :wa<cr>

"move lines around
nnoremap <leader>k :m-2<cr>==
nnoremap <leader>j :m+<cr>==
xnoremap <leader>k :m-2<cr>gv=gv
xnoremap <leader>j :m'>+<cr>gv=gv"

map <C-n> :NERDTreeToggle<CR>

nnoremap <A-A> <C-a>
nnoremap <A-x> <C-x>

nmap    j       gj
nmap    k       gk

"Split window mappings
map <Leader><Leader> <ESC>:vsplit<CR>:wincmd l<cr>
map <Leader>/   <ESC>:split<CR>:wincmd j<CR>
nnoremap <silent> <C-h> :call WinMove('h')<cr>
nnoremap <silent> <C-j> :call WinMove('j')<cr>
nnoremap <silent> <C-k> :call WinMove('k')<cr>
nnoremap <silent> <C-l> :call WinMove('l')<cr>))))

function! WinMove(key)
  let t:curwin = winnr()
  exec "wincmd ".a:key
  if (t:curwin == winnr())
    if (match(a:key,'[jk]'))
      wincmd v
    else
      wincmd s
    endif
    exec "wincmd ".a:key
  endif
endfunction

"Buffer mappings
map <F6> :buffers<CR>
map     <C-LEFT>  <ESC>:bp<CR>
map     <C-RIGHT> <ESC>:bn<CR>
map     <Leader>1 <ESC>:b1<CR>
map     <Leader>2 <ESC>:b2<CR>
map     <Leader>3 <ESC>:b3<CR>
map     <Leader>4 <ESC>:b4<CR>
map     <Leader>5 <ESC>:b5<CR>
map     <Leader>6 <ESC>:b6<CR>
map     <Leader>7 <ESC>:b7<CR>
map     <Leader>8 <ESC>:b8<CR>
map     <Leader>9 <ESC>:b9<CR>

"Other F keys
nnoremap <F2> O<Esc>"=strftime("%Y-%m-%d %H:%M:%S")<CR>P<Esc>0i# <Esc>o
inoremap <F2> <C-R>=strftime("%Y-%m-%d %H:%M:%S")<CR><Esc>0i# <Esc>o
map <F3> :!ls<CR>
map <F4> :!pwd<CR>
map <F5> :so $MYVIMRC<CR>

map <Leader>fp <Esc>:!phpcbf %<cr>
map <Leader>wli ^i<li><Esc>$a</li><Esc>j
map <Leader>wa ^i<a href=""><Esc>$a</a><Esc>j
map <Leader>wwa bi<a href=""><Esc>ea</a><Esc>
map <Leader>wp ^i<p><Esc>$a</p><Esc>j
map <Leader>wb ^i<strong><Esc>$a</strong><Esc>j
map <Leader>wtr ^i<tr><Esc>$a</tr><Esc>j
map <Leader>wtd ^i<td><Esc>$a</td><Esc>j
map <Leader>wth ^i<th><Esc>$a</th><Esc>j
map <Leader>wh1 ^i<h1><Esc>$a</h1><Esc>j
map <Leader>wh2 ^i<h2><Esc>$a</h2><Esc>j
map <Leader>wh3 ^i<h3><Esc>$a</h3><Esc>j
map <Leader>wh4 ^i<h4><Esc>$a</h4><Esc>j
map <Leader>wi ^i<em><Esc>$a</em><Esc>j
map <Leader>wb ^i<strong><Esc>$a</strong><Esc>j
map <Leader>wdt ^i<dt><Esc>$a</dt><Esc>j
map <Leader>wdd ^i<dd><Esc>$a</dd><Esc>j
map <Leader>w_( ^i<?=_("<Esc>$a")?><Esc>
map <Leader>w" ^i"<Esc>$a"<Esc>j
map <Leader>/* ^i/*<Esc>$a<Esc>$a*/

nnoremap <leader>ev <C-w><C-v><C-l>:e $MYVIMRC<cr>

if has("multi_byte")    " if not, we need to recompile
  if &enc !~? '^u'      " if the locale 'encoding' starts with u or U
                        " then Unicode is already set
    if &tenc == ''
      let &tenc = &enc  " save the keyboard charset
    endif
    set enc=utf-8       " to support Unicode fully, we need to be able
                        " to represent all Unicode codepoints in memory
  endif
  set fencs=ucs-bom,utf-8,latin1
  setg bomb             " default for new Unicode files
  setg fenc=latin1      " default for files created from scratch
  set encoding=utf8
else
  echomsg 'Warning: Multibyte support is not compiled-in.'
endif
