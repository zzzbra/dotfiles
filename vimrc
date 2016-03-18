" URL: http://vim.wikia.com/wiki/Example_vimrc
" Authors: http://vim.wikia.com/wiki/Vim_on_Freenode
" Description: A minimal, but feature rich, example .vimrc. If you are a
"              newbie, basing your first .vimrc on this file is a good choice.
"              If you're a more advanced user, building your own .vimrc based
"              on this file is still a good idea.

"------------------------------------------------------------
" Features {{{1
"
" These options and commands enable some very useful features in Vim, that
" no user should have to live without.

" Set 'nocompatible' to ward off unexpected things that your distro might
" have made, as well as sanely reset options when re-sourcing .vimrc
set nocompatible

" Attempt to determine the type of a file based on its name and possibly its
" contents. Use this to allow intelligent auto-indenting for each filetype,
" and for plugins that are filetype specific.
filetype indent plugin on

" Enable syntax highlighting
syntax on


"------------------------------------------------------------
" Must have options {{{1
"
" These are highly recommended options.

" Vim with default settings does not allow easy switching between multiple files
" in the same editor window. Users can use multiple split windows or multiple
" tab pages to edit multiple files, but it is still best to enable an option to
" allow easier switching between files.
"
" One such option is the 'hidden' option, which allows you to re-use the same
" window and switch from an unsaved buffer without saving it first. Also allows
" you to keep an undo history for multiple files when re-using the same window
" in this way. Note that using persistent undo also lets you undo in multiple
" files even in the same window, but is less efficient and is actually designed
" for keeping undo history after closing Vim entirely. Vim will complain if you
" try to quit without saving, and swap files will keep you safe if your computer
" crashes.
set hidden

" Note that not everyone likes working this way (with the hidden option).
" Alternatives include using tabs or split windows instead of re-using the same
" window as mentioned above, and/or either of the following options:
" set confirm
" set autowriteall

" Better command-line completion
set wildmenu

" Show partial commands in the last line of the screen
set showcmd

" Highlight searches (use <C-L> to temporarily turn off highlighting; see the
" mapping of <C-L> below)
set hlsearch

" Modelines have historically been a source of security vulnerabilities. As
" such, it may be a good idea to disable them and use the securemodelines
" script, <http://www.vim.org/scripts/script.php?script_id=1876>.
set nomodeline


"------------------------------------------------------------
" Usability options {{{1
"
" These are options that users frequently set in their .vimrc. Some of them
" change Vim's behaviour in ways which deviate from the true Vi way, but
" which are considered to add usability. Which, if any, of these options to
" use is very much a personal preference, but they are harmless.

" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase

" Allow backspacing over autoindent, line breaks and start of insert action
set backspace=indent,eol,start

" When opening a new line and no filetype-specific indenting is enabled, keep
" the same indent as the line you're currently on. Useful for READMEs, etc.
set autoindent

" Stop certain movements from always going to the first character of a line.
" While this behaviour deviates from that of Vi, it does what most users
" coming from other editors would expect.
" set nostartofline

" Display the cursor position on the last line of the screen or in the status
" line of a window
set ruler

" Always display the status line, even if only one window is displayed
set laststatus=2

" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files.
set confirm

" Use visual bell instead of beeping when doing something wrong
set visualbell

" And reset the terminal code for the visual bell. If visualbell is set, and
" this line is also included, vim will neither flash nor beep. If visualbell
" is unset, this does nothing.
set t_vb=

" Enable use of the mouse for all modes
set mouse=a

" Set the command window height to 2 lines, to avoid many cases of having to
 "press <Enter> to continue"
set cmdheight=2

" Display line numbers on the left
" set number

" Quickly time out on keycodes, but never time out on mappings
set notimeout ttimeout ttimeoutlen=200

" Use <F11> to toggle between 'paste' and 'nopaste'
set pastetoggle=<F11>


"------------------------------------------------------------
" Indentation options {{{1
"
" Indentation settings according to personal preference.

" Indentation settings for using 4 spaces instead of tabs.
" Do not change 'tabstop' from its default value of 8 with this setup.
" ACTUALLY I am gonna change 'tabstop' because it's what this guy
" recommened: http://stevelosh.com/blog/2010/09/coming-home-to-vim/
" TODO figure out why they originally didn't 
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

" Indentation settings for using hard tabs for indent. Display tabs as
" four characters wide.
"set shiftwidth=4
"set tabstop=4


"------------------------------------------------------------
" Mappings {{{1
"
" Useful mappings

" Map Y to act like D and C, i.e. to yank until EOL, rather than act as yy,
" which is the default
map Y y$

" Map <C-L> (redraw screen) to also turn off search highlighting until the
" next search
nnoremap <C-L> :nohl<CR><C-L>


"------------------------------------------------------------
" Custom Styles

" Installing Pathogen for managing vim runtimepath / installing shit
execute pathogen#infect()

colorscheme monokai

" Set relative number instead (according to Thought Bot's tutorial)
set relativenumber
set number

" Change up the position for new windows to a more natural order
set splitbelow
set splitright

" Some more stuff from the guy who 'Switched Back to Vim':
" http://stevelosh.com/blog/2010/09/coming-home-to-vim/
set encoding=utf-8
set scrolloff=3
set showmode
set wildmenu
set wildmode=list:longest
set visualbell
set cursorline
set ttyfast
" set undofile

" let mapleader="\"


" Searching / Moving
"
" The first two lines fix Vim’s horribly broken default regex “handling” by
" automatically inserting a \v before any string you search for. This turns off
" Vim’s crazy default regex characters and makes searches use normal regexes. I
" already know Perl/Python compatible regex formatting, why would I want to
" learn another scheme?

" ignorecase and smartcase together make Vim deal with case-sensitive search
" intelligently. If you search for an all-lowercase string your search will be
" case-insensitive, but if one or more characters is uppercase the search will
" be case-sensitive. Most of the time this does what you want.

" gdefault applies substitutions globally on lines. For example, instead of
" :%s/foo/bar/g you just type :%s/foo/bar/. This is almost always what you want
" (when was the last time you wanted to only replace the first occurrence of a
" word on a line?) and if you need the previous behavior you just tack on the g
" again.

" incsearch, showmatch and hlsearch work together to highlight search results
" (as you type). It’s really quite handy, as long as you have the next line as
" well.

" The <leader><space> mapping makes it easy to clear out a search by typing
" ,<space>. This gets rid of the distracting highlighting once I’ve found what
" I’m looking for.

" The last two lines make the tab key match bracket pairs. I use this to move
" around all the time and <tab> is a hell of a lot easier to type than %.

nnoremap / /\v
vnoremap / /\v
set ignorecase
set smartcase
set gdefault
set incsearch
set showmatch
set hlsearch
nnoremap <leader><space> :noh<cr>
nnoremap <tab> %
vnoremap <tab> %


" These lines manage my line wrapping settings and also show a colored column
" at 85 characters (so I can see when I write a too-long line of code).

set wrap
set textwidth=79
set formatoptions=qrn1
" set colorcolumn=85

" Enable line wrapping the (hanging?) indent
set breakindent

" SO YOU DO THINGS THE RIGHT WAY

nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
nnoremap j gj
nnoremap k gk


" Leader key combos

" strip all trailing whitespace in the current file
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>

" re-hardwrap paragraphs of text
nnoremap <leader>q gqip

" open a new vertical split and switch over to it
nnoremap <leader>w <C-w>v<C-w>l

" This next set of mappings maps <C-[h/j/k/l]> to the commands needed to move
" around your splits
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l


" Quicker Escaping
inoremap jj <ESC>

" Move a line at a time even on linewrapped lines
:nmap j gj
:nmap k gk

" broken lines wrap to the indented line from which they broke
set breakindent

" Turn off Vim generating a backup file everytime I edit
set nobackup
set nowritebackup

" ============================================================================
" NERDTree stuff I've stolen from vcavalo
" ============================================================================

" map 'tt' to open up NERDTree "
" :map tt :NERDTreeToggle
:map tt <plug>NERDTreeTabsToggle<CR>

" open NERDTree automatically when vim starts "
" if has("gui")
" autocmd vimenter * NERDTree
" endif

" close vim if NERDTree is the only window left "
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif


" ============================================================================
" Ctrl P settings
" ============================================================================
let g:ctrlp_custom_ignore = '\v[\/]\theme$'
