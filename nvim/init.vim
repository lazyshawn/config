" Here is Shawn's configuration
" Ref: https://github.com/theniceboy/nvim

" >> auto install vim-plug at the first time ............................... {{{
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter *PlugInstall --sync | source $MYVIMRC
endif
" }}} ..........................................................................

" >> basic options setting ................................................. {{{
" not compatible with vi
set nocompatible
filetype plugin indent on
" enable mouse actions
augroup MouseActionSetting
  autocmd!
  autocmd InsertEnter * set mouse=
  autocmd InsertLeave * set mouse=a
  " Visual enter
  autocmd ModeChanged *:[vV\x16]* : set mouse=
  " Visual leave
  autocmd ModeChanged [vV\x16]*:* :set mouse=a
augroup END

set encoding=utf-8
" set <Space> as <LEADER>
let mapleader=" "

set number
set cursorline
set scrolloff=4
set cmdheight=1

" set <tab> behavior
" https://vi.stackexchange.com/a/9473
" expand <Tab> to <Space>
set expandtab
" number of spaces to use for each step of (auto)indent
set shiftwidth=2
" the display width of one <Tab> to how many spaces
set tabstop=2
" the characters that VIM actually gets by pressing <Tab> in insert mode
set softtabstop=2
set autoindent
" keys which will trigger autoindent
set indentkeys-=:

" 空格和tab的显示标志 --- \|\: 竖线; trail:·(行尾空格)
set list
set listchars=tab:\|\ ,trail:·,nbsp:+

" timeout for sequence mappings like cw, dw
set notimeout
" timeout for key codes like esc, arrow_key
set ttimeoutlen=150

set splitright
set noshowmode
set showcmd
set inccommand=split
set completeopt=longest,noinsert,menuone,noselect,preview
" the screen will not be redrawn while executing macros, registers and commands
set lazyredraw
set visualbell
set colorcolumn=80
set virtualedit=block

" Warp text
" https://stackoverflow.com/questions/1272173/in-vim-how-do-i-break-one-really-long-line-into-multiple-lines
set wrap linebreak
set textwidth=78
" influence how Vim formats text (m:warp for CJK)
set formatoptions+=tmBl
" autocmd BufNewFile,BufRead * setlocal formatoptions-=cqn

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300
" c: don't give |ins-completion-menu| messages.
" S: show count of matches
set shortmess+=cS
" Always show the signcolumn
set signcolumn=yes
" }}} ..........................................................................

" Use :!H <doc> to open <doc> in a full window
command! -nargs=1 -complete=help H h <args> | only
" Auto change directory to current dir
autocmd BufEnter *.* silent! lcd %:p:h
" location list
noremap <LEADER>- :lN<CR>
noremap <LEADER>= :lne<CR>

" >> basic navigation {{{
" Cursor motion
noremap <silent> J 5j
noremap <silent> K 5k
noremap <silent> H 5h
noremap <silent> L 5l
noremap <C-h> 0
noremap <C-l> $
nnoremap <C-j> 5<C-e>
nnoremap <C-k> 5<C-y>
" use <C-o> in [insert] to temporarily enter [normal] for the next command
inoremap <C-l> <C-o>a
" Search behavior
set ignorecase smartcase
nnoremap n nzz
nnoremap N Nzz
nnoremap <LEADER>/ :nohlsearch<CR>
" }}}

" >> file editing {{{
autocmd!
nnoremap S :w ++enc=utf-8<CR>
nnoremap Q :q<CR>
" Press <SPACE> + q to close the window below the current window
nnoremap <LEADER>q <C-w>j:q<CR>
" Substitude %s/<a>/<b>/g
nnoremap sg :%s/
" append space between english and chinese
nnoremap ss :%s/[^\x00-\xff]\zs\ze\w\\|\w\zs\ze[^\x00-\xff]/ /g
" Join lines (join! - produce extral space)
nnoremap <LEADER>J :join<CR>
vnoremap <LEADER>J :join<CR>
" yank to system clipboard
vnoremap Y "+y
" quickly indent
nnoremap < <<
nnoremap > >>
" Select all
nnoremap <C-a> <ESC>ggVG
" Placehold: Press , twice to jump to the next 'xxx' and edit it
noremap ,, <Esc>/xxx<CR>:nohlsearch<CR>c3l
" }}}

" >> tab window buffer {{{
" 分屏和标签页 && Slide and Tab
map sh :set nosplitright<CR>:vsplit<CR>
map sl :set splitright<CR>:vsplit<CR>
map sj :set splitbelow<CR>:split<CR>
map sk :set nosplitbelow<CR>:split<CR>
map T :tabe<CR>

" 更改分屏大小
map <up> :res +5<CR>
map <down> :res -5<CR>
map <left> :vertical resize -5<CR>
map <right> :vertical resize +5<CR>

" 切换分屏和标签页
map <LEADER>h <C-w>h
map <LEADER>l <C-w>l
map <LEADER>j <C-w>j
map <LEADER>k <C-w>k
map th :-tabnext<CR>
map tl :+tabnext<CR>

" 切换Buffer页面
map bn :bn<CR>;
map bp :bp<CR>;
map bb :bd<CR>;

" Switch layout of the windows: vertical & side by side
map sv <C-w>t<C-w>K
map sb <C-w>t<C-w>H
" }}}

" >> save change after exist ............................................... {{{
" back to last cursor position when load file, see :h '"
set viewoptions+=cursor
autocmd BufRead * autocmd FileType <buffer> ++once
    \ if &ft !~# 'commit\|rebase' && line("'\"") > 1 && line("'\"") <= line("$")
    \ | exe 'normal! g`"' | endif

" 退出仍然保存修改历史
silent !mkdir -p ~/.config/nvim/tmp/backup
silent !mkdir -p ~/.config/nvim/tmp/undo
set backupdir=~/.config/nvim/tmp/backup,.
set directory=~/.config/nvim/tmp/backup,.
if has('persistent_undo')
  set undofile
  set undodir=~/.config/nvim/tmp/undo,.
endif
" }}} ..........................................................................

" >> keep folds on save {{{
" https://stackoverflow.com/questions/37552913/vim-how-to-keep-folds-on-save
" `za` to trigger fold, `zm` to colse all folds, `zr` to open all folds
" set foldmethod=indent
set foldlevel=2
set viewoptions+=folds
set viewoptions-=options
" make `:mkview` ignores local bindings when folds are created
augroup remember_folds
	autocmd!
	autocmd BufWinLeave *.* mkview
	autocmd BufWinEnter *.* silent! loadview
augroup END
" }}}

" >> vimscript file setting ................................................ {{{
augroup filetype_vim
  autocmd!
  " set foldmathod for vim filetype
  autocmd FileType vim setlocal foldmethod=marker
augroup END

" Open the vimrc file anytime
noremap <LEADER>vi :e ~/.config/nvim/init.vim<CR>
" Source Vim配置文件
noremap <LEADER>R :source $MYVIMRC<CR>
let g:python3_host_prog = '/usr/bin/python3'
" }}} ..........................................................................

" >> auto fcitx {{{
" 退出插入模式和命令行模式自动切换到搜狗拼音模式源
let g:input_toggle = 1
function! Fcitx2en()
  let s:input_status = system("fcitx5-remote")
  if s:input_status == 2
    let g:input_toggle = 1
    let l:a = system("fcitx5-remote -c")
  endif
endfunction
" 退出插入模式(InsertLeave),命令行模式(CmdLineLeave)(使用逗号,分隔)
autocmd InsertLeave * call Fcitx2en()
" }}}

" >> opening a terminal window ............................................. {{{
noremap <LEADER><CR> :set splitbelow<CR>:split<CR>:res +10<CR>:term<CR>

augroup TermHandling
  autocmd!
  " Turn off line numbers, listchars, auto enter insert mode and map esc to
  " exit insert mode
  autocmd TermOpen * setlocal listchars= nonumber norelativenumber
        \ | startinsert
augroup END

function! LayoutTerm(size, orientation) abort
  let timeout = 16.0
  let animation_total = 120.0
  let timer = {
        \ 'size': a:size,
        \ 'step': 1,
        \ 'steps': animation_total / timeout
        \}

  if a:orientation == 'horizontal'
    resize 1
    function! timer.f(timer)
      execute 'resize ' . string(&lines * self.size * (self.step / self.steps))
      let self.step += 1
    endfunction
  else
    vertical resize 1
    function! timer.f(timer)
      execute 'vertical resize ' . string(&columns * self.size * (self.step / self.steps))
      let self.step += 1
    endfunction
  endif
  call timer_start(float2nr(timeout), timer.f, {'repeat': float2nr(timer.steps)})
endfunction

" Open autoclosing terminal, with optional size and orientation
function! OpenTerm(cmd, ...) abort
  let orientation = get(a:, 2, 'horizontal')
  if orientation == 'horizontal'
    new | wincmd J
  else
    vnew | wincmd L
  endif
  call LayoutTerm(get(a:, 1, 0.5), orientation)
  call termopen(a:cmd, {'on_exit': {j,c,e -> execute('if c == 0 | close | endif')}})
endfunction
" }}} ..........................................................................

" >> smart compile {{{
map <LEADER>r :call CompileRunGcc()<CR>
func! CompileRunGcc()
  exec "w"
  if &filetype == 'c'
    exec "!g++ % -o %<"
    exec "!time ./%<"
  elseif &filetype == 'cpp'
    set splitbelow
    exec "!g++ -std=c++17 % -Wall -l pthread -o %<"
    :sp
    :res -15
    :term ./%<
  elseif &filetype == 'java'
    exec "!javac %"
    exec "!time java %<"
  elseif &filetype == 'sh'
    :!time bash %
  elseif &filetype == 'python'
    set splitbelow
    :sp
    :term python3 %
  elseif &filetype == 'html'
    silent! exec "!".g:mkdp_browser." % &"
  elseif &filetype == 'markdown'
    exec "MarkdownPreview"
  elseif &filetype == 'tex'
    silent! exec "VimtexStop"
    silent! exec "VimtexCompile"
  elseif &filetype == 'go'
    set splitbelow
    :sp
    :term go run %
  elseif &filetype == 'lua'
    set splitbelow
    :sp
    :term lua %
  endif
endfunc
" }}}

" >> chinese charasters count {{{
" 原理是统计unicode大于0x2000的字符，下面命令有同样效果
" :s/[^\x00-\xff]//gn
function! ChineseCount() range
	let save = @z
	silent exec 'normal! gv"zy'
	let text = @z
	let @z = save
	silent exec 'normal! gv'
	let cc = 0
	for char in split(text, '\zs')
		if char2nr(char) >= 0x2000
			let cc += 1
		endif
	endfor
	echo "Count of Chinese charasters is:"
	echo cc
endfunc
vnoremap <F7> :call ChineseCount()<cr>
" }}}

" ===============
" === Plug-in ===
" ===============
"load lua files which list plugins
lua require('plugins')

lua require('plugin-config/themes')
lua require('settings')
lua require('plugin-config/lsp_dap')
lua require('plugin-config/cmp')

