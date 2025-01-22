" The default vimrc file.
"
" Maintainer:	The Vim Project <https://github.com/vim/vim>
" Last change:	2023 Aug 10
" Former Maintainer:	Bram Moolenaar <Bram@vim.org>
"
" This is loaded if no vimrc file was found.
" Except when Vim is run with "-u NONE" or "-C".
" Individual settings can be reverted with ":set option&".
" Other commands can be reverted as mentioned below.

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Bail out if something that ran earlier, e.g. a system wide vimrc, does not
" want Vim to use these default values.
if exists('skip_defaults_vim')
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
" Avoid side effects when it was already reset.
if &compatible
  set nocompatible
endif

" When the +eval feature is missing, the set command above will be skipped.
" Use a trick to reset compatible only when the +eval feature is missing.
silent! while 0
  set nocompatible
silent! endwhile

" Allow backspacing over everything in insert mode.
set backspace=indent,eol,start

set history=200		" keep 200 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set wildmenu		" display completion matches in a status line

set ttimeout		" time out for key codes
set ttimeoutlen=100	" wait up to 100ms after Esc for special key

" Show @@@ in the last line if it is truncated.
set display=truncate

" Show a few lines of context around the cursor.  Note that this makes the
" text scroll if you mouse-click near the start or end of the window.
set scrolloff=5

" Do incremental searching when it's possible to timeout.
if has('reltime')
  set incsearch
endif

" Do not recognize octal numbers for Ctrl-A and Ctrl-X, most users find it
" confusing.
set nrformats-=octal

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries.
if has('win32')
  set guioptions-=t
endif

" Don't use Q for Ex mode, use it for formatting.  Except for Select mode.
" Revert with ":unmap Q".
map Q gq
sunmap Q

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
" Revert with ":iunmap <C-U>".
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine.  By enabling it you
" can position the cursor, Visually select and scroll with the mouse.
" Only xterm can grab the mouse events when using the shift key, for other
" terminals use ":", select text and press Esc.
if has('mouse')
  if &term =~ 'xterm'
    set mouse=a
  else
    set mouse=nvi
  endif
endif

" Only do this part when Vim was compiled with the +eval feature.
if 1

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  " Revert with ":filetype off".
  filetype plugin indent on

  " Put these in an autocmd group, so that you can revert them with:
  " ":autocmd! vimStartup"
  augroup vimStartup
    autocmd!

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid, when inside an event handler
    " (happens when dropping a file on gvim), for a commit or rebase message
    " (likely a different one than last time), and when using xxd(1) to filter
    " and edit binary files (it transforms input files back and forth, causing
    " them to have dual nature, so to speak)
    autocmd BufReadPost *
      \ let line = line("'\"")
      \ | if line >= 1 && line <= line("$") && &filetype !~# 'commit'
      \      && index(['xxd', 'gitrebase'], &filetype) == -1
      \ |   execute "normal! g`\""
      \ | endif

  augroup END

  " Quite a few people accidentally type "q:" instead of ":q" and get confused
  " by the command line window.  Give a hint about how to get out.
  " If you don't like this you can put this in your vimrc:
  " ":autocmd! vimHints"
  augroup vimHints
    au!
    autocmd CmdwinEnter *
	  \ echohl Todo |
	  \ echo gettext('You discovered the command-line window! You can close it with ":q".') |
	  \ echohl None
  augroup END

endif

" Switch syntax highlighting on when the terminal has colors or when using the
" GUI (which always has colors).
if &t_Co > 2 || has("gui_running")
  syntax on

  " I like highlighting strings inside C comments.
  " Revert with ":unlet c_comment_strings".
  let c_comment_strings=1
endif

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
" Revert with: ":delcommand DiffOrig".
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

if has('langmap') && exists('+langremap')
  " Prevent that the langmap option applies to characters that result from a
  " mapping.  If set (default), this may break plugins (but it's backward
  " compatible).
  set nolangremap
endi

	call plug#begin()

	Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
	Plug 'vim-airline/vim-airline'

	Plug 'vim-airline/vim-airline-themes'
	let g:airline_theme='wal'
	let g:airline_powerline_fonts = 1
	let g:airline_section_b = '%t' " in section B of the status line display the CWD

	"TABLINE:
	  if !exists('g:airline_symbols')
    let g:airline_symbols = {}
  endif

  " powerline symbols
    let g:airline_left_sep = ''
    let g:airline_left_alt_sep = ''
    let g:airline_right_sep = ''
    let g:airline_right_alt_sep = ''
    let g:airline_symbols.branch = ''
    let g:airline_symbols.colnr = ':'
    let g:airline_symbols.readonly = ''
    let g:airline_symbols.linenr = '    '
    let g:airline_symbols.maxlinenr = ''
    let g:airline_symbols.dirty='⚡'


	let g:airline#extensions#tabline#enabled = 1           " enable airline tabline
	let g:airline#extensions#tabline#show_close_button = 0 " remove 'X' at the end of the tabline
	let g:airline#extensions#tabline#tabs_label = ''       " can put text here like BUFFERS to denote buffers (I clear it so nothing is shown)
"	let g:airline#extensions#tabline#buffers_label = ''    " can put text here like TABS to denote tabs (I clear it so nothing is shown)
	let g:airline#extensions#tabline#fnamemod = ':t'       " disable file paths in the tab
"	let g:airline#extensions#tabline#show_tab_count = 0    " dont show tab numbers on the right
	let g:airline#extensions#tabline#show_buffers = 0      " dont show buffers in the tabline
"	let g:airline#extensions#tabline#tab_min_count = 2     " minimum of 2 tabs needed to display the tabline
	let g:airline#extensions#tabline#show_splits = 0       " disables the buffer name that displays on the right of the tabline
	let g:airline#extensions#tabline#show_tab_nr = 0       " disable tab numbers
"	let g:airline#extensions#tabline#show_tab_type = 0     " disables the weird ornage arrow on the tabline
	let g:airline#extensions#whitespace#enabled = 0

	Plug 'preservim/nerdtree'
	nnoremap <C-t> :NERDTreeToggle<CR>
	nnoremap <C-s> :NERDTreeFind<CR>

	Plug 'https://github.com/tpope/vim-surround.git'
	Plug 'https://github.com/tpope/vim-commentary.git'
	Plug 'https://github.com/ap/vim-css-color.git'
	Plug 'https://github.com/rafi/awesome-vim-colorschemes.git'
"	Plug 'ryanoasis/vim-devicons'
	Plug 'https://github.com/tc50cal/vim-terminal.git'
	Plug 'terryma/vim-multiple-cursors'
	Plug 'https://github.com/preservim/tagbar.git'
	Plug 'neoclide/coc.nvim', {'branch': 'release'}
"	Plug 'github/copilot.vim'

	set updatetime=300
	autocmd CursorHold * silent call CocActionAsync('highlight')
	nmap gd <Plug>(coc-definition) " Переход к определению
	nmap gr <Plug>(coc-references) " Поиск ссылок


	function! CheckBackspace() abort
	  let col = col('.') - 1
	  return !col || getline('.')[col - 1]  =~# '\s'
	endfunction

	inoremap <expr> <cr> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"

	inoremap <silent><expr> <Tab>
		  \ coc#pum#visible() ? coc#pum#next(1) :
		  \ CheckBackspace() ? "\<Tab>" :
		  \ coc#refresh()
	inoremap <expr> <S-Tab> coc#pum#visible() ? coc#pum#prev(1) : "\<S-Tab>"

	Plug 'dylanaraps/wal.vim'
    Plug 'jiangmiao/auto-pairs'
	
" Быстрый поиск файлов через FZF
	Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
	Plug 'junegunn/fzf.vim'
	nnoremap <C-p> :Files<CR>
	" nnoremap <C-[> :Files~<CR>

	Plug 'puremourning/vimspector'
	let g:vimspector_enable_mappings = 'HUMAN'

	set encoding=utf-8
 	
	call plug#end()

" Set colorscheme
  colorscheme wal
" Disable transparent background
  set background=dark
" Line's numbering
  set number
" Line's numbering relative to the current one
  set relativenumber
" Automatic indentation
  set autoindent
  set smartindent
  " How many spaces one TAB i
  set tabstop=4
" how many columns of whitespace a “level of indentation” is worth            
  set shiftwidth=4                                                            
  set smarttab
" in insert mod
  set softtabstop=4
" moise activation
  set mouse=a
" compiling code
  set tags=~/gitrepos/glibc/tags
  set path+=/usr/include,/usr/include/x86_64-linux-gnu
  set path+=/usr/lib/gcc/x86_64-pc-linux-gnu/14.2.1/include


  map <F2> :w<CR>:!gcc % -g -o  %<.out -lm && reset && ./%<.out<CR>
  map <F7> :w<CR>:!gcc % -g -o  %<.out && reset && ./%<.out<CR>
  map <F1> :w<CR>:!reset && gcc % -g -o %<.out<CR>
  set formatprg=clang-format
  inoremap <C-l> <Right>
" autocmd BufWritePre *.c,*.cpp :silent! execute '!clang-format -i %' | :edit | :w
" autocmd BufWritePost *.c,*.cpp :silent! execute '!clang-format -i %' | :edit

