" All system-wide defaults are set in $VIMRUNTIME/debian.vim and sourced by
" the call to :runtime you can find below.  If you wish to change any of those
" settings, you should do it in this file (/etc/vim/vimrc), since debian.vim
" will be overwritten everytime an upgrade of the vim packages is performed.
" It is recommended to make changes after sourcing debian.vim since it alters
" the value of the 'compatible' option.

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages available in Debian.
runtime! debian.vim

" Uncomment the next line to make Vim more Vi-compatible
" NOTE: debian.vim sets 'nocompatible'.  Setting 'compatible' changes numerous
" options, so any other options should be set AFTER setting 'compatible'.
"set compatible

" Vim5 and later versions support syntax highlighting. Uncommenting the next
" line enables syntax highlighting by default.
if has("syntax")
  syntax on
endif

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
"set background=dark

" Uncomment the following to have Vim jump to the last position when
" reopening a file
"if has("autocmd")
"  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
"endif

" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
"if has("autocmd")
"  filetype plugin indent on
"endif

" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
"set showcmd		" Show (partial) command in status line.
"set showmatch		" Show matching brackets.
"set ignorecase		" Do case insensitive matching
"set smartcase		" Do smart case matching
"set incsearch		" Incremental search
"set autowrite		" Automatically save before commands like :next and :make
"set hidden		" Hide buffers when they are abandoned
"set mouse=a		" Enable mouse usage (all modes)

" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif

set mouse=v " Enable mouse usage (all modes)
set showmatch " Show matching brackets.
set smartcase " Do smart case matching
set incsearch " Incremental search
set hlsearch
set nu
set cursorline
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set cindent
set nowrap

highlight WhitespaceEOL ctermbg=red guibg=red
match WhitespaceEOL /\s\+$/

if has("multi_byte")
    if &termencoding == ""
        let termencoding = &encoding
    endif
    set encoding=utf-8
    setglobal fileencoding=utf-8
    set fileencodings=ucs-bom,utf-8,lation1
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" cscope setting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! AddCscope()
  if has("cscope")
      set csprg=/usr/bin/cscope
      set csto=1
      set cst
      set nocsverb

      " add any database in current directory
      let subDir = expand("%:p")
      let lastSplashIndex=strridx(subDir, "/")
      let l:cscopeFilePath=expand("")

      while lastSplashIndex >= 1
          let lastSplashIndex=strridx(subDir, "/")
          let l:curDir=strpart(subDir, 0, lastSplashIndex)
          let l:cscopeFilePath=expand(l:curDir . "/" . "cscope.out")
          if filereadable(l:cscopeFilePath)
              break
          endif
          let subDir=l:curDir
      endwhile

      exec 'cs add ' . l:cscopeFilePath
      set csverb
  endif
endfunction

nmap <C-a>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-a>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-a>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-a>t :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-a>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-a>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-a>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-a>d :cs find d <C-R>=expand("<cword>")<CR><CR>

"one ops to most largest
nmap w.  :resize +120<CR>
nmap w,  :resize -120<CR>
nmap w-  :vertical resize -120<CR>
nmap w=  :vertical resize +120<CR>

function InitSessionAndInfo()
    let sessionsdir="/home/guoguo/.vim/sessions"
    let infosdir="/home/guoguo/.vim/infos"

    let sessionSuffix='.vimsession'
    let viminfoSuffix='.viminfo'

    if !isdirectory(sessionsdir)
        call mkdir(sessionsdir, "p", 0755)
    endif

    if !isdirectory(infosdir)
        call mkdir(infosdir, "p", 0755)
    endif

    let curFileSuffix=expand('%:e')
    let curFileName=expand('%:t:r')
    let curFileDir=expand('%:p:h')

    let sessionFileDir=expand(sessionsdir . '/' . curFileDir)
    let infoFileDir = expand(infosdir . '/' . curFileDir)

    if !isdirectory(sessionFileDir)
        call mkdir(sessionFileDir, "p", 0777)
    endif

    if !isdirectory(infoFileDir)
        call mkdir(infoFileDir, "p", 0777)
    endif

    let g:sessionFileName =expand(sessionFileDir . '/' . curFileName . '_' . curFileSuffix . sessionSuffix)
    let g:viminfoFileName=expand(infoFileDir . '/' . curFileName .  '_' . curFileSuffix . viminfoSuffix)
endfunction

function SavedSessionAndInfo()
    call InitSessionAndInfo()
    execute 'mksession! ' . g:sessionFileName
    execute 'wviminfo! ' . g:viminfoFileName

endfunction


function RestoreSessionAndInfo()
    call InitSessionAndInfo()
    if filereadable(g:sessionFileName)
        execute 'source ' . g:sessionFileName
    endif

    if filereadable(g:viminfoFileName)
        execute 'rviminfo ' . g:viminfoFileName
    endif

    call AddCscope()

    if has("syntax")
        syntax on
    endif
endfunction

autocmd VimEnter * call RestoreSessionAndInfo()
autocmd VimLeave * call SavedSessionAndInfo()

" Persistent undo
set undodir="/home/guoguo/.vim/undodir"
set undofile
set undolevels=1000
set undoreload=10000
