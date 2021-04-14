" Here is Shawn's configuration
" Ref: https://github.com/theniceboy/nvim

" ===
" === Auto load first time uses
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
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_SR = "\<Esc>]50;CursorShape=2\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"


" ===
" === Terminal Behavior
" ===
let g:neoterm_autoscroll = 1
autocmd TermOpen term://* startinsert

let g:terminal_color_0  = '#000000'
let g:terminal_color_1  = '#FF5555'
let g:terminal_color_2  = '#50FA7B'
let g:terminal_color_3  = '#F1FA8C'
let g:terminal_color_4  = '#BD93F9'
let g:terminal_color_5  = '#FF79C6'
let g:terminal_color_6  = '#8BE9FD'
let g:terminal_color_7  = '#BFBFBF'
let g:terminal_color_8  = '#4D4D4D'
let g:terminal_color_9  = '#FF6E67'
let g:terminal_color_10 = '#5AF78E'
let g:terminal_color_11 = '#F4F99D'
let g:terminal_color_12 = '#CAA9FA'
let g:terminal_color_13 = '#FF92D0'
let g:terminal_color_14 = '#9AEDFE'
augroup TermHandling
  autocmd!
  " Turn off line numbers, listchars, auto enter insert mode and map esc to
  " exit insert mode
  autocmd TermOpen * setlocal listchars= nonumber norelativenumber
    \ | startinsert
  autocmd FileType fzf call LayoutTerm(0.6, 'horizontal')
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
let mapleader=" " " 设置空格键为LEADER键
"
" Source Vim配置文件
noremap R :source $MYVIMRC<CR>
map s <nop>
map <CR> <nop>
noremap S :w<CR>
noremap Q :q<CR>

" Copy, cut, and paste
" make Y to copy till the end of line
nnoremap Y y$
nnoremap D d$
" Copy to system clipboard
vnoremap Y "+y

" Indentation
nnoremap < <<
nnoremap > >>

" Search
map n <nop>
map N <nop>
noremap <LEADER>/ :nohlsearch<CR>
noremap - Nzz
noremap = nzz
exec "nohlsearch"

" Open the vimrc file anytime
noremap <LEADER>vi :e ~/.config/nvim/init.vim<CR>

" Adjacent duplicate words
noremap <LEADER>dw /\(\<\w\+\>\)\_s*\1<CR>

" Space to tab | 将连续空格替换为tab
nnoremap <LEADER>tt :%s/    /\t/g
vnoremap <LEADER>tt :s/    /\t/g

" Substitude
nnoremap sg :%s/

" Folding
noremap <silent><LEADER>o za

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
imap <c-l> <ESC>la

" Select all
noremap <C-a> <ESC>ggVG

" For when you forget to sudo.. Really Write the file.
cmap w!! w !sudo tee %

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

" Opening a terminal window
noremap <LEADER><CR> :set splitbelow<CR>:split<CR>:res +10<CR>:term<CR>

" Press space twice to jump to the next '<++>' and edit it
noremap <LEADER><LEADER> <Esc>/<++><CR>:nohlsearch<CR>c4l

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
		exec "!g++ -std=c++11 % -Wall -o %<"
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


" ===============
" === Plug-in ===
" ===============
call plug#begin('~/.config/nvim/plugged')
Plug 'mhinz/vim-startify'        " The fancy start screen of vim

" --- Pretty dress
" 状态栏设置
Plug 'bling/vim-bufferline'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Git gutter
Plug 'airblade/vim-gitgutter'
" Other visual enhancement
Plug 'luochen1990/rainbow'
Plug 'tpope/vim-fugitive'        " git status in airline
Plug 'ryanoasis/vim-devicons'    " pretty icons for vim

" --- Themes
" Plug 'ajmwagar/vim-deus'
Plug 'morhetz/gruvbox'

" --- General Highlighter
Plug 'chrisbra/Colorizer'    " Show colors with :ColorHighlight
Plug 'jackguo380/vim-lsp-cxx-highlight'   " Highlighter for ccls

" --- Taglist
Plug 'liuchengxu/vista.vim'  " Require ctags, support LSP

" --- Other useful utilities
Plug 'lambdalisue/suda.vim' " do stuff like :sudowrite
Plug 'makerj/vim-pdf'

" --- Dependencies
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'kana/vim-textobj-user'
Plug 'roxma/nvim-yarp'

" --- Debugger
Plug 'puremourning/vimspector', {'do': './install_gadget.py --enable-c --enable-python'}

" --- File navigation
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }    " Not configured

" --- Auto Complete
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" --- Snippets
Plug 'SirVer/ultisnips'   " Not configured
Plug 'lazyshawn/shawn-snippets'  " My snippets.

" Undo Tree
Plug 'mbbill/undotree'

" Tex
Plug 'lervag/vimtex'

" Flutter
Plug 'dart-lang/dart-vim-plugin'
Plug 'thosakwe/vim-flutter'

" Markdown
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install_sync() }, 'for' :['markdown', 'vim-plug'] }
Plug 'dhruvasagar/vim-table-mode', { 'on': 'TableModeToggle' }
Plug 'mzlogin/vim-markdown-toc', { 'for': ['gitignore', 'markdown'] }

" Editor Enhancement
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'      " Change or delete surround (cs/ds and etc.)
Plug 'gcmt/wildfire.vim'       " in Visual mode, type i' to select all text in '', or type i) i] i} ip. This will caused select paragraph when press Enter;
Plug 'junegunn/vim-easy-align' " gaip= to align the = in paragraph,
Plug 'preservim/nerdcommenter' " press <L>c<L> to toggle comments

call plug#end()


" ===================== Start of Plugin Settings ======================
" ===
" === Color themes
" ===
set termguicolors    " enable true colors support
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
" colors deus
color gruvbox
"color xcodedark

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
let g:airline_symbols.linenr = ' '
let g:airline_symbols.maxlinenr = ''
" let g:airline_symbols.maxlinenr = '㏑'
let g:airline_symbols.branch = ''
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.spell = 'Ꞩ'
let g:airline_symbols.notexists = 'Ɇ'
" airline_tabeline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = ''

" 切换Buffer页面
map bn :bn<CR>;
map bp :bp<CR>;
map bb :bd<CR>;


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
    \ 'coc-gitignore', 'coc-git', 'coc-explorer', 'coc-snippets', 'coc-json']
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

" Highlight the symbol and its references when holding the cursor.
set updatetime=300
autocmd CursorHold * silent call CocActionAsync('highlight')
au CursorHoldI * sil call CocActionAsync('showSignatureHelp')

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Language-server
let g:tex_flavor = "latex"

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
let g:vmt_auto_update_on_save = 0
let g:vmt_dont_insert_fence = 1
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
" let g:vista_executive_for = {
" \ 'cpp': 'coc',
" \}
let g:vista_fzf_preview = ['right:50%']
let g:vista#renderer#enable_icon = 1
let g:vista#renderer#icons = {
\   "function": "",
\   "variable": "",
\   "map":      "",
\   "augroup":  "",
\  }


" ===
" === Ultisnips
" ===
inoremap <c-k> <nop>
let g:tex_flavor = "latex"
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
let g:UltiSnipsSnippetDirectories = [$HOME.'/.config/nvim/plugged/shawn-snippets/UltiSnips/']
silent! au BufEnter,BufRead,BufNewFile * silent! unmap <c-r>


" ===
" === Suda.vim
" ===
cnoreabbrev sudowrite w suda://%
cnoreabbrev sw w suda://%


" ===
" === Wildfire
" ===
" this selects the next closest text object.
" unmap <CR>
map '' <plug>(wildfire-fuel)
" This selects the previous closest text object.
vmap <C-SPACE> <Plug>(wildfire-water)


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
" === Vim-easy-align
" ===
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)


" ============ End of Plugin Settings ============

