" Here is Shawn's configuration
" Ref: https://github.com/theniceboy/nvim

" ===
" === Auto install vim-plug at first time
" ===
if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter *PlugInstall --sync | source $MYVIMRC
endif

" ====================
" === Editor Setup ===
" ====================

" ===
" === System
" ===
set nocompatible  " 取消与vi兼容
filetype on
filetype indent on
filetype plugin on
filetype plugin indent on

set mouse=a    " 支持鼠标
set encoding=utf-8
let &t_ut=''    " 修复终端配色bug
set autochdir
let mapleader=" " " 设置空格键为LEADER键

" ===
" === Editor behavior
" ===
set number
set cursorline
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=4
set autoindent
set list
" 空格和tab的显示标志
" \|\: 竖线; trail:▫(用方框表示空格)
set listchars=tab:\|\ 
set scrolloff=4
set ttimeoutlen=0
set notimeout
set viewoptions=cursor,folds,slash,unix
set wrap
set tw=0
set indentexpr=
set foldmethod=indent
set foldlevel=99
set foldenable
set formatoptions-=tc
set splitright
set splitbelow
set noshowmode
set showcmd
set wildmenu
set ignorecase
set smartcase
set shortmess+=c
set inccommand=split
set completeopt=longest,noinsert,menuone,noselect,preview
set ttyfast "should make scrolling faster
set lazyredraw "same as above
set visualbell
set colorcolumn=80
set updatetime=1000
set virtualedit=block
" Warp text
" https://stackoverflow.com/questions/1272173/in-vim-how-do-i-break-one-really-long-line-into-multiple-lines
set wrap
set linebreak
set textwidth=80
set formatoptions+=tmM  " warp for CJK

au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" 退出仍然保存修改历史
silent !mkdir -p ~/.config/nvim/tmp/backup
silent !mkdir -p ~/.config/nvim/tmp/undo
set backupdir=~/.config/nvim/tmp/backup,.
set directory=~/.config/nvim/tmp/backup,.
if has('persistent_undo')
    set undofile
    set undodir=~/.config/nvim/tmp/undo,.
endif

" Cursor shape
" let &t_SI = "\<Esc>]50;CursorShape=1\x7"
" let &t_SR = "\<Esc>]50;CursorShape=2\x7"
" let &t_EI = "\<Esc>]50;CursorShape=0\x7"


" ===
" === Terminal Behavior
" ===
" Opening a terminal window
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

" ===
" === Basic Mappings
" ===
" Source Vim配置文件
noremap R :source $MYVIMRC<CR>
map s <nop>
map <CR> <nop>
noremap S :w ++enc=utf-8<CR>
noremap Q :q<CR>

" Copy, cut, and paste
" make Y to copy till the end of line
nnoremap Y y$
nnoremap D d$
nnoremap C c$
" Copy to system clipboard
vnoremap Y "+y

" Indentation
nnoremap < <<
nnoremap > >>

" Search
exec "nohlsearch"
noremap <LEADER>/ :nohlsearch<CR>
map n <nop>
map N <nop>
noremap - Nzz
noremap = nzz

" Open the vimrc file anytime
noremap <LEADER>vi :e ~/.config/nvim/init.vim<CR>

" Adjacent duplicate words
noremap <LEADER>dw /\(\<\w\+\>\)\_s*\1<CR>

" Substitude %s/<a>/<b>/g
nnoremap sg :%s/

" Folding
noremap <silent><LEADER>o za

" Join lines (join! - produce extral space)
nmap <LEADER>jj :join<CR>
vmap <LEADER>jj :join<CR>


" ===
" === Cursor Movement
" ===
noremap <silent> J 5j
noremap <silent> K 5k
noremap <silent> H 5h
noremap <silent> L 5l
noremap <C-h> 0
noremap <C-l> $
noremap <C-j> 5<C-e>
noremap <C-k> 5<C-y>

" Select all
nmap <C-a> <ESC>ggVG
imap <C-l> <ESC>la

" ===
" === Windows management
" ===
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

" Press <SPACE> + q to close the window below the current window
noremap <LEADER>q <C-w>j:q<CR>

" Switch layout of the windows (vertical & side by side)
map sv <C-w>t<C-w>K
map sb <C-w>t<C-w>H

" ===
" === Other useful stuff
" ===
" Auto change directory to current dir
autocmd BufEnter * silent! lcd %:p:h

" Press space twice to jump to the next '<++>' and edit it
" noremap <LEADER><LEADER> <Esc>/<++><CR>:nohlsearch<CR>c4l

" Spelling Check with <space>sc
noremap <LEADER>sc :set spell!<CR>

noremap <LEADER>- :lN<CR>
noremap <LEADER>= :lne<CR>

" ===
" === Compile function
" ===
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

" ===
" === Auto fcitx
" ===
" 退出插入模式和命令行模式自动切换到搜狗拼音模式源
let g:input_toggle = 1
function! Fcitx2en()
  let s:input_status = system("fcitx-remote")
  if s:input_status == 2
    let g:input_toggle = 1
    let l:a = system("fcitx-remote -c")
  endif
endfunction
set ttimeoutlen=150
" 退出插入模式(InsertLeave),命令行模式(CmdLineLeave)(使用逗号,分隔)
autocmd InsertLeave * call Fcitx2en()

" ===
" === Chinese count
" ===
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

" append space between english and chinese
" nmap ss :%s/[^\x00-\xff]\zs\ze\w\|\w\zs\ze[^\x00-\xff]/ /g

" ===
" === Keep folds on save
" ===
" https://stackoverflow.com/questions/37552913/vim-how-to-keep-folds-on-save
" make `:mkview` ignores local bindings when folds are created
set viewoptions-=options
augroup remember_folds
  autocmd!
  autocmd BufWinLeave *.* mkview
  autocmd BufWinEnter *.* silent! loadview
augroup END


" ===============
" === Plug-in ===
" ===============
call plug#begin('~/.config/nvim/plugged')
" --- Pretty dress
Plug 'morhetz/gruvbox'           " Themes
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'airblade/vim-gitgutter'    " Git gutter
Plug 'tpope/vim-fugitive'        " git status in airline
Plug 'ryanoasis/vim-devicons'    " pretty icons for vim
Plug 'mhinz/vim-startify'        " The fancy start screen of vim


" --- Other useful utilities
" Plug 'wakatime/vim-wakatime'  " wakatime
Plug 'makerj/vim-pdf'         " Make VIM as a PDF reader
Plug 'airblade/vim-rooter'    " Changes Vim working directory to project root
Plug 'chrisbra/Colorizer'     " Show colors with :ColorHighlight

 " --- Debugger
Plug 'puremourning/vimspector', {'do': './install_gadget.py --enable-c --enable-python'}

" --- File navigation
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" --- Easy Coding
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'SirVer/ultisnips'          " Snippets
Plug 'lazyshawn/shawn-snippets'  " My snippets.
Plug 'liuchengxu/vista.vim'      " Require ctags, support LSP

" Tex
Plug 'lervag/vimtex'

" C/C++
Plug 'jackguo380/vim-lsp-cxx-highlight'  " Highlighter for ccls
Plug 'cdelledonne/vim-cmake'             " CMake in vim

" Markdown
Plug 'iamcco/markdown-preview.nvim', { 'do': ':call mkdp#util#install()', 'for': 'markdown', 'on': 'MarkdownPreview' }
Plug 'mzlogin/vim-markdown-toc', { 'for': ['gitignore', 'markdown'] }  " auto toc
Plug 'dhruvasagar/vim-table-mode', { 'on': 'TableModeToggle' }

" Editor Enhancement
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'jiangmiao/auto-pairs'
Plug 'mbbill/undotree'         " Undo Tree
Plug 'tpope/vim-surround'      " Change or delete surround (cs/ds and etc.)
Plug 'gcmt/wildfire.vim'       " in Visual mode, type i' to select all text in '', or type i) i] i} ip. This will caused select paragraph when press Enter;
Plug 'preservim/nerdcommenter' " toggle comments

call plug#end()


" ===================== Start of Plugin Settings ======================
" " ===
" " === Color themes
" " ===
set termguicolors    " enable true colors support
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
color gruvbox
set background=dark
" set background=light


" ===
" === Airline
" ===
let g:airline_theme='gruvbox'
let g:airline#powerline_fonts = 1    " 使用powerline打过补丁的字体
let g:bufferline_echo = 0
let g:airline#extensions#whitespace#enabled = 0    " Whitespace detector
" Install SourceCodePro fonts, and change terminal fonts;
set guifont=Source\ Code\ Pro\ for\ Powerline:h15:cANSI
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
" unicode symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.crypt = ''
let g:airline_symbols.linenr = '  '
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.spell = 'Ꞩ'
let g:airline_symbols.notexists = 'Ɇ'
" airline_tabeline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = ''


" ===
" === Colorizer
" ===
" 显示十六进制格式的颜色
let g:colorizer_syntax = 1


" ===
" === Coc-nvim
" ===
" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
    \ pumvisible() ? "\<C-n>" :
    \ <SID>check_back_space() ? "\<TAB>" :
    \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" fix the most annoying bug that coc has
silent! au BufEnter,BufRead,BufNewFile * silent! unmap if

let g:coc_global_extensions = ['coc-python', 'coc-texlab', 'coc-vimlsp',
    \ 'coc-gitignore', 'coc-git', 'coc-explorer', 'coc-snippets', 'coc-json',
    \ 'coc-sumneko-lua']
inoremap <silent><expr> <c-space> coc#refresh()

" Open up coc-commands
nnoremap <C-c> :CocCommand<CR>

" Useful commands
nnoremap <silent> <space>y :<C-u>CocList -A --normal yank<cr>
nmap     <silent> gd <Plug>(coc-definition)zz
nmap     <silent> gy <Plug>(coc-type-definition)
nmap     <silent> gi <Plug>(coc-implementation)
nmap     <silent> gr <Plug>(coc-references)
nmap     <leader>rn <Plug>(coc-rename)
nmap     tt :CocCommand explorer<CR>
nmap     so :CocCommand workspace.showOutput<CR>
try
    nmap <silent> gj :call CocAction('diagnosticNext')<cr>
    nmap <silent> gk :call CocAction('diagnosticPrevious')<cr>
endtry

" Highlight the symbol and its references when holding the cursor.
set updatetime=300
autocmd CursorHold * silent call CocActionAsync('highlight')
au CursorHoldI * sil call CocActionAsync('showSignatureHelp')

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" ----- coc.ccls -----
nn <silent> <C-d> :call CocActionAsync('doHover')<cr>

" ----- coc.git -----
" navigate chunks of current buffer
nmap [g <Plug>(coc-git-prevchunk)
nmap ]g <Plug>(coc-git-nextchunk)
" show chunk diff at current position
nmap gs <Plug>(coc-git-chunkinfo)
" show commit contains current position
nmap gc <Plug>(coc-git-commit)
nmap gt :GitGutterSignsToggle<CR>

" ===
" === vimtex
" ===
let g:vimtex_view_method = 'zathura'
let g:vimtex_compiler_latexmk_engines = {'_': '-xelatex'}
let g:vimtex_fold_enabled = 1
let g:vimtex_complete_enabled = 0
filetype plugin indent on
if empty(v:servername) && exists('*remote_startserver')
call remote_startserver('VIM')
endif
" Close viewers when VimTeX buffers are closed
function! CloseViewers()
  if executable('xdotool')
        \ && exists('b:vimtex.viewer.xwin_id')
        \ && b:vimtex.viewer.xwin_id > 0
    call system('xdotool windowclose '. b:vimtex.viewer.xwin_id)
  endif
endfunction
augroup vimtex_close_viewers
  au!
  au User VimtexEventQuit call CloseViewers()
augroup END
" focus on vim after open viewers
augroup vimtex_focus_on_vim
  autocmd!
  autocmd User VimtexEventView call b:vimtex.viewer.xdo_focus_vim()
augroup END


" ===
" === MarkdownPreview
" ===
" ------------ Basic settings ------------
" auto spell
autocmd BufRead,BufNewFile *.md setlocal spell

" ------------ Markdown Preview ------------
let g:mkdp_auto_start         = 0
let g:mkdp_auto_close         = 1
let g:mkdp_refresh_slow       = 0
let g:mkdp_command_for_global = 0
let g:mkdp_open_to_the_world  = 0
let g:mkdp_open_ip            = ''
let g:mkdp_echo_preview_url   = 0
let g:mkdp_browserfunc        = ''
let g:mkdp_browser            = 'chromium-browser'
" google-chrome, chromium-browser
let g:mkdp_preview_options = {
      \ 'mkit': {},
      \ 'katex': {},
      \ 'uml': {},
      \ 'maid': {},
      \ 'disable_sync_scroll': 0,
      \ 'sync_scroll_type': 'middle',
      \ 'hide_yaml_meta': 1
      \ }
let g:mkdp_markdown_css  = ''
let g:mkdp_highlight_css = ''
let g:mkdp_port          = ''
let g:mkdp_page_title    = '「${name}」'

" ----------- vim-markdown-toc ----------
nmap toc :GenTocGFM<CR>
let g:vmt_auto_update_on_save = 0
let g:vmt_dont_insert_fence = 0
let g:vmt_cycle_list_item_markers = 1
let g:vmt_fence_text              = 'TOC'
let g:vmt_fence_closing_text      = '/TOC'

" ---------- vim-table-model ----------
noremap <LEADER>tm :TableModeToggle<CR>
let g:table_mode_disable_mappings = 1
let g:table_mode_cell_text_object_i_map = 'k<Bar>'

function! s:isAtStartOfLine(mapping)
  let text_before_cursor = getline('.')[0 : col('.')-1]
  let mapping_pattern = '\V' . escape(a:mapping, '\')
  let comment_pattern = '\V' . escape(substitute(&l:commentstring, '%s.*$', '', ''), '\')
  return (text_before_cursor =~? '^' . ('\v(' . comment_pattern . '\v)?') . '\s*\v' . mapping_pattern . '\v$')
endfunction

inoreabbrev <expr> <bar><bar>
  \ <SID>isAtStartOfLine('\|\|') ?
  \ '<c-o>:TableModeEnable<cr><bar><space><bar><left><left>' : '<bar><bar>'
inoreabbrev <expr> __
  \ <SID>isAtStartOfLine('__') ?
  \ '<c-o>:silent! TableModeDisable<cr>' : '__'


" ===
" === Vista.vim
" ===
noremap <silent> M :Vista!!<CR>
let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
let g:vista_default_executive = 'ctags'
let g:vista_fzf_preview = ['right:50%']
let g:vista#renderer#enable_icon = 1
let g:vista#renderer#icons = {
\   "function": "",
\   "variable": "",
\   "map":      "",
\   "augroup":  "",
\  }


" ===
" === vim-rooter
" ===
let g:rooter_targets = '*.cpp,*.h,*.md'
let g:rooter_patterns = ['src', 'CMakeList.txt']

" ===
" === Ultisnips
" ===
inoremap <c-k> <nop>
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
let g:UltiSnipsSnippetDirectories = [$HOME.'/.config/nvim/plugged/shawn-snippets/UltiSnips/']
silent! au BufEnter,BufRead,BufNewFile * silent! unmap <c-r>


" ===
" === Wildfire
" ===
" this selects the next closest text object.
map ;; <plug>(wildfire-fuel)
" This selects the previous closest text object.
" vmap '' <Plug>(wildfire-water)


" ===
" === Debuger: vimspector
" ===
let g:vimspector_enable_mappings = 'HUMAN'
function! s:read_template_into_buffer(template)
  " has to be a function to avoid the extra space fzf#run insers otherwise
  execute '0r ~/.config/nvim/sample_vimspector_json/'.a:template
endfunction
command! -bang -nargs=* LoadVimSpectorJsonTemplate call fzf#run({
      \   'source': 'ls -1 ~/.config/nvim/sample_vimspector_json',
      \   'down': 20,
      \   'sink': function('<sid>read_template_into_buffer')
      \ })
noremap <leader>vs :tabe .vimspector.json<CR>:LoadVimSpectorJsonTemplate<CR>
sign define vimspectorBP text=☛ texthl=Normal
sign define vimspectorBPDisabled text=☞ texthl=Normal
sign define vimspectorPC text=🔶 texthl=SpellBa


" ===
" === FZF
" ===
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
nmap F :Files<CR>


" ===
" === undotree
" ===
nmap U :call undotree#UndotreeToggle()<CR>
" e.g. using 'd' instead of 'days' to save some space.
if !exists('g:undotree_ShortIndicators')
    let g:undotree_ShortIndicators = 1
endif
" if set, let undotree window get focus after being opened, otherwise
" focus will stay in current window.
if !exists('g:undotree_SetFocusWhenToggle')
    let g:undotree_SetFocusWhenToggle = 1
endif

" ===
" === Nerdcomment
" ===
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1
" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'
" Set a language to use its alternate delimiters by default
let g:NERDAltDelims_java = 1
" Add your own custom formats or override the defaults
let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }
" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1
" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1
" Enable NERDCommenterToggle to check all selected lines is commented or not
let g:NERDToggleCheckAllLines = 1


" ===
" === vim-visual-multi
" ===
let g:VM_leader                     ='<Space><Space>'
let g:VM_maps                       = {}
let g:VM_maps["Undo"]               = 'u'
let g:VM_maps["Redo"]               = '<C-r>'
let g:VM_maps["Select Cursor Down"] = '<M-C-j>'
let g:VM_maps["Select Cursor Up"]   = '<M-C-k>'


" ===
" === cdelledonne/vim-cmake
" ===
let g:cmake_link_compile_commands=1
let g:cmake_root_markers = ['.git','.ccls']
let g:cmake_default_config = 'build'
nmap <leader>cg :CMakeGenerate<cr>
nmap <leader>cb :CMakeBuild<cr>


" ===
" === auto-pairs
" ===
let g:AutoPairs = {'(':')', '[':']', '{':'}',"'":"'",'"':'"','<':'>'}
let g:AutoPairsFlyMode = 1
let g:AutoPairsShortcutFastWrap = '<C-p>'


" ============ End of Plugin Settings ============

