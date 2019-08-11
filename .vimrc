set nocompatible

runtime! debian.vim

if !has('nvim')
    packadd! matchit
endif


" Try Plug
if empty(glob("~/.vim/autoload/plug.vim"))
    execute '!curl -fLo ~/.vim/autoload/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim'
endif

call plug#begin('~/.vim/plugged')
Plug 'gko/vim-coloresque'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'kien/ctrlp.vim'
Plug 'tpope/vim-fugitive'
Plug 'posva/vim-vue', { 'for': 'vue' }
Plug 'tpope/vim-surround'
Plug 'vim-ruby/vim-ruby', { 'for': 'ruby' }
Plug 'airblade/vim-gitgutter'
Plug 'jiangmiao/auto-pairs'
Plug 'w0rp/ale'
Plug 'editorconfig/editorconfig-vim'
Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'branch install.sh' }
Plug 'junegunn/fzf'
" Plugin 'junegunn/fzf.vim'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'scrooloose/nerdtree-git-plugin', { 'on': 'NERDTreeToggle' }
Plug 'JamshedVesuna/vim-markdown-preview', { 'for': 'markdown' }
" Plugin 'valloric/youcompleteme'
Plug 'vim-latex/vim-latex', { 'for': 'tex' }
" Plugin 'xuhdev/vim-latex-live-preview'
"Plug 'ludovicchabant/vim-gutentags'
"Plug 'skywind3000/gutentags_plus'
if has('nvim')
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
    Plug 'Shougo/deoplete.nvim'
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
endif
call plug#end()


" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif

" Source settings
let settings_file = expand('~/.vim/settings')
if filereadable(settings_file)
    source ~/.vim/settings
endif

" Source keybindings
let keybindings_file = expand('~/.vim/keybindings')
if filereadable(keybindings_file)
    source ~/.vim/keybindings
endif

" Source theme options
let airline_file = expand('~/.vim/airline')
if filereadable(airline_file)
    source ~/.vim/airline
endif
