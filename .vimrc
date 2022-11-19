set nocompatible              " be iMproved, required
filetype off                  " required
filetype plugin on
syntax on

"Start maximized
autocmd GUIEnter * call system("wmctrl -ir " . v:windowid . " -b add,maximized_vert,maximized_horz")

"si gVim on vire les menus etc
if has('gui_running')
  set guifont=Ubuntu\ Mono\ 12
  set guioptions -=T
  set guioptions -=r
  set guioptions -=m
  set guioptions -=L
  set mousemodel=popup
endif 

" taille de base de la fenêtre
" set lines=50 columns=150

" Permettre à backspace de remonter des ligneOBs
set backspace=indent,eol,start

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
set rtp+=~/.fzf

"" PLUGINS----------------------------------------------------------------------------------------
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-fugitive'
" Plugin d'autocomplétion : affiche les suggestions sans taper CTRL+P ou N
Plugin 'vim-scripts/AutoComplPop.git'
" Surround --> pratique pour sélectionner des morceaux et les entourer de trucs
Plugin 'tpope/vim-surround.git'
" Lightline : barre de mode de couleur
Plugin 'itchyny/lightline.vim'
" nerdtree : explorateur
Plugin 'preservim/nerdtree'
" fzf : fuzzy file finder
"Plugin 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plugin 'junegunn/fzf.vim'
" SearchIndex
Plugin 'https://github.com/google/vim-searchindex.git'
" sneak : pour faire des recherches sur 2 caractères
Plugin 'justinmk/vim-sneak'
" SVED_Sync : forward et backward sync avec evince
Plugin 'https://github.com/peder2tm/sved.git'
" pour commenter
Plugin 'scrooloose/nerdcommenter'
" retrouver la dernière pos.
Plugin 'https://github.com/farmergreg/vim-lastplace.git'
Plugin 'micha/vim-colors-solarized'
Plugin 'morhetz/gruvbox'
"Plugin 'shinchu/lightline-gruvbox.vim'
Plugin 'https://github.com/freeo/vim-kalisi'
Plugin 'skywind3000/asyncrun.vim'
Plugin 'ap/vim-buftabline'
Plugin 'longkey1/vim-lf'
Plugin 'dpelle/vim-Grammalecte'
Plugin 'mechatroner/rainbow_csv'
Plugin 'vim-scripts/Align'
Plugin 'terryma/vim-multiple-cursors'
if has('gui_running')
 Plugin 'HendrikPetertje/vimify'
endif
call vundle#end()            " required
" ----------------------------------------------------------------------------------------------

" Leader à virgule pour toutes les combi de type <Leader>- ... 
let mapleader = ","
" REQUIRED. This makes vim invoke Latex-Suite when you open a tex file.
filetype plugin on
" Se placer dans le dir local du fichier édité
set autochdir
" IMPORTANT: win32 users will need to have 'shellslash' set so that latex
" can be called correctly.
" set shellslash
" OPTIONAL: This enables automatic indentation as you type.
filetype indent on


"" BLOC Latex Suite ------------------------------------------------------------------------------------------------------------------
" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'
" Réglages compilation latex
let g:Tex_DefaultTargetFormat = 'pdf'
let g:Tex_CompileRule_pdf = 'lualatex -synctex=1 -interaction=nonstopmode -shell-escape $*'
"let g:Tex_CompileRule_pdf = 'pdflatex -synctex=1 -file-line-error -interaction=nonstopmode $*'
" On visualise avec evince pour vim (pas réussi à forward sync zathura)
let g:Tex_ViewRule_pdf = 'zathura'
" et zathura si Gvim
if has('gui_running')
  let g:Tex_ViewRule_pdf = 'zathura'
endif
" Pas voir les warnings de merde
let g:Tex_IgnoredWarnings = 
      \'Underfull'."\n".
      \'Overfull'."\n".
      \'specifier changed to'."\n".
      \'You have requested'."\n".
      \'Missing number, treated as zero.'."\n".
      \'There were undefined references'."\n".
      \'Citation %.%# undefined'."\n".
      \'Package etex Warning'."\n".
      \'LaTeX Font Warning: '."\n".
      \'Package hyperref Warning: '."\n".
      \'LaTeX Warning: Text'."\n".
      \'Package inputenc Warning:'."\n".
      \'Package fourier Warning:'."\n".
      \'Package amsmath Warning'
let g:Tex_IgnoreLevel = 14
"Pas ouvrir les fichiers sty etc 
let g:Tex_PackagesMenu = 0
"Compiler avec F1
autocmd FileType tex map <F1> :w<CR>:silent call Tex_RunLaTeX()<CR>
autocmd FileType tex inoremap <F1> <ESC>:w<CR>:silent call Tex_RunLaTeX()<CR><CR>
"Visu avec F2
autocmd FileType tex map <F2> :!evince %:r.pdf & disown<CR><CR>
"" Truc inutile après avoir modifié /ftplugin/latex-suite/compiler.vim
"" Synctex forward avec F4 (ctrl+click pour backward)
"function! SyncTexForward()
"let linenumber=line(".")
"let colnumber=col(".")
"let filename=bufname("%")
"let filenamePDF=filename[:-4]."pdf"
"let execstr="!zathura --synctex-forward " . linenumber . ":" . colnumber . ":" . filename . " " . filenamePDF . "&>/dev/null &"
"exec execstr 
"endfunction
" De base on forward avec SVED Sync dans Evince
autocmd FileType tex nmap <F4> :call SVED_Sync()<CR>
" Sauf si Gvim, là on peut forwarder dans Zathura direct via latexsuite
" UTILISE UNE MODIF DANS compiler.vim
if has('gui_running')
  autocmd FileType tex nmap <F4> <leader>ls<CR>
endif
" -------------------------------------------------------------------------------------------------------------------------------------
" pas trop indenter
set shiftwidth=2 

" reconnaitre les ref: pour suggestion avec <C-n>
set iskeyword+=:

" Barres de mode en couleur (plugin lightline) 
set laststatus=2
set noshowmode

" Ouvrir un fichier avec fzf 
nnoremap <leader>ff :FZF! ~/<cr>
nnoremap <leader>f :FZF! ~/Nextcloud/<cr>
"nnoremap <leader>f :FZF! /mnt/c/Users/dietr/OneDrive\ -\ ac-nancy-metz.fr/Nextcloud/<cr>
" Regarder les buffers
nnoremap <leader>b :Buffer ~/<cr>
" Naviguer ds les buffers
nnoremap <C-h> :bprev<cr>
nnoremap <C-l> :bnext<cr>
" Historique
nnoremap <leader>h :History ~/<cr>


" Réparer alt dans vim
let c='a'
while c <= 'z'
  exec "set <A-".c.">=\e".c
  exec "imap \e".c." <A-".c.">"
  let c = nr2char(1+char2nr(c))
endw


" Attendre 50ms pour détecter les macros en plusieurs frappes ?
set timeout ttimeoutlen=50

" In the quickfix window, <CR> is used to jump to the error under the
" cursor, so undefine the mapping there.
" autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>

" Changer le curseur selon les modes
let &t_SI.="\e[5 q"
let &t_SR.="\e[3 q"
let &t_EI.="\e[2 q"

" Surligner les recherches
set hlsearch

" Plugin sneak
let g:sneak#s_next = 1
"retour arrière avec < dans sneak
autocmd FileType tex map < <Plug>Sneak_,  

" Vim compte les lignes relativement à la ligne actuelle (pratique pour naviguer)
set relativenumber 

"NERDToggle
map <C-n> :NERDTreeToggle /mnt/d/OneDrive\ -\ ac-nancy-metz.fr/Nextcloud/ECS/2019-2020/<CR>
let NERDTreeQuitOnOpen=1
let g:NERDTreeChDirMode = 2

" Compile rapport F8
autocmd FileType tex inoremap <C-x> \exercice{}<Esc>i
map <F8> :w<CR> :!./rapport.sh %<CR><F9><CR>
imap <F8> <Esc>:w<CR> :!./rapport.sh %<CR><F9><CR>i


" Tend vers quand n tend vers l'infini
autocmd FileType tex inoremap tvn \tendvers{n}{+\infty}{}<++><Esc>4<left>i
autocmd FileType tex inoremap tvx \tendvers{x}{}{<++>}<++><Esc>10<left>i

" Limite
autocmd FileType tex inoremap LIM \lim\limits_{ \to <++>} <++><Esc>14<left>i

" Thème 
"colorscheme gruvbox
colorscheme solarized
set background=dark

if has('gui_running')==0
  hi! Normal ctermbg=NONE guibg=NONE
  hi! NonText ctermbg=NONE guibg=NONE guifg=NONE ctermfg=NONE
endif

let g:gruvbox_contrast_dark='hard'
" Lightline full path
let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'readonly', 'absolutepath', 'modified' ] ],
      \ }
      \ }
"let g:lightline.colorscheme = 'gruvbox'
let g:lightline.colorscheme = 'solarized'

"" REGLAGES VIMIFY
if has('gui_running')
  "Vimify
  let g:spotify_token='YTJhNDJkMDRhYzZmNDJmMThlNDA3N2NiZDA3Y2Q3M2Y6N2RhYzhlNmMzZTE4NDRjMTgwMzcyYWFkNWY1OWI4MTA='
  map <F3><F3> :Spotify<CR>
  map <F3>s :SpSearch  
  map <F3><F4> :SpNext<CR>
  map <F3><F2> :SpPrev<CR>
  map <F3> :SpSelect<CR>
endif

" Si on est dans un vimdiff
autocmd BufWritePost * if &diff | diffupdate | endif
noremap <leader>dg :diffget<CR>
noremap <leader>dp :diffput<CR>
noremap <leader>du :diffupdate<CR>
noremap )c ]c
noremap (c [c




"" GROUPE DES TRUCS CHELOUS LATEXSUITE ---------------------------------------------------
" Remaper Alt+I en Alt+J car term en a besoin pour l'accent aigu
"imap <buffer> <leader>it <Plug>Tex_InsertItemOnThisLine
" PAS ICI : à mettre dans /ftplugin/tex.vim
let g:Tex_Leader = ';'
let g:Tex_SmartQuoteOpen = '\og '
let g:Tex_SmartQuoteClose = '\fg{}'
" Alt keys latex suite
let g:Tex_AdvancedMath = 1
" ne pas indenter les { }, très important pour que le tex ne devienne pas illisible
let g:tex_indent_brace = 0

" ne pas indenter le code Python (le faire à la main)
let g:tex_noindent_env = 'minted'

" Sauter les <++> avec TAB
autocmd FileType tex imap <TAB> <Plug>IMAP_JumpForward
" auto remplacement des double dollar
autocmd FileType tex inoremap $$ \[  \]<++><Esc>6<left>i
autocmd FileType tex inoremap <Bar><Bar> \left<Bar>  \right<Bar><++><Esc>11<left>i
" auto complétion des int, sum, prod, prsc, 
let g:Tex_Com_int = "\\int_{<++>}^{<++>} <++> \\d <++>"
let g:Tex_Com_sum = "\\sum_{<++>}^{<++>} <++>"
let g:Tex_Com_prod = "\\prod_{<++>}^{<++>} <++>"
let g:Tex_Com_prsc = "\\prsc{<++>}{<++>} <++>"
" Ne pas remplacer les ... par \cdots
let g:Tex_SmartKeyDot=0
" modif pour que ^mette automatiquement ^{}, cf ftplugin/latex-suite/main.vim
" 	call IMAP ('^', '^{<++>}<++>', "tex")
"------------------------------------------------------------------------------------------


"" GROUPE DES TRUCS LATEX PERSO
autocmd FileType tex inoremap <C-e> \emph{}<left>
" underbrace easy 
autocmd FileType tex inoremap ;un \underbrace{}_{<++>} <++><Esc>12<left>i
" Macro à la main pour ajouter un \textcolor{white}{ ... } autour de la
" sélection visuelle avec Alt+w ...
vnoremap <nowait> <A-w> <Esc>`>a}<Esc>gv<Esc>`<i\textcolor{prof}{<Esc>$
" avec des || pour mettre entre barres
" vnoremap || <Esc>`>a\right|<Esc>gv<Esc>`<i\left|<Esc>$
" FOIREUX : CF AJOUT /ftplugin/latex-suite/main.vim
autocmd FileType tex nmap <F6> :!rm *.out *.aux *.log *.zpid *.synctex.gz<CR>


" execution Scilab F9
autocmd FileType scilab noremap <F9> :w<CR>:AsyncRun scilab -nw -quit -f %<CR>
autocmd FileType scilab inoremap <F9> <Esc>:w<CR>:AsyncRun scilab -nw -quit -f %<CR>
autocmd FileType scilab noremap <F10> :call asyncrun#quickfix_toggle(8)<CR>
autocmd FileType scilab inoremap <F10> <Esc>:call asyncrun#quickfix_toggle(8)<CR>i
autocmd FileType scilab noremap <F8> :w<CR>:!scilab -nw -f %<CR>
autocmd FileType scilab inoremap <F8> <Esc>:w<CR>:!scilab -nw -f %<CR>


" execution Python F9
autocmd FileType python nmap <F9> :w<CR>:AsyncRun python % <CR>
autocmd FileType python let $PYTHONUNBUFFERED=1
autocmd FileType python nmap <F10> :call asyncrun#quickfix_toggle(8)<CR><C-W>H<C-W>50> 
autocmd FileType python nmap <F11> :call asyncrun#quickfix_toggle(8)<CR>
autocmd FileType python nmap <C-K> :AsyncStop<CR>

" execution Haskell F9
autocmd FileType haskell nmap <F9> :w<CR>:AsyncRun runghc % <CR>
autocmd FileType haskell nmap <F10> :call asyncrun#quickfix_toggle(8)<CR><C-W>H<C-W>50> 
autocmd FileType haskell nmap <F11> :call asyncrun#quickfix_toggle(8)<CR>
autocmd FileType haskell nmap <C-K> :AsyncStop<CR>


" execution oCaml F9
autocmd FileType ocaml nmap <F9> :w<CR>:AsyncRun ocaml % <CR>
autocmd FileType ocaml let $PYTHONUNBUFFERED=1
autocmd FileType ocaml nmap <F10> :call asyncrun#quickfix_toggle(8)<CR><C-W>H<C-W>50> 
autocmd FileType ocaml nmap <F11> :call asyncrun#quickfix_toggle(8)<CR>
autocmd FileType ocaml nmap <C-K> :AsyncStop<CR>


" régler bug couleur highlight random
set t_ut=""
if (&term =~ '^xterm' && &t_Co == 256)
  set t_ut= | set ttyscroll=1
endif


"Script Gautam
nnoremap <F9>
      \ :exec "!szathura %:r.pdf" line('.')  col('.') "% > /dev/null"<cr><cr>
nnoremap <C-F9>
      \ :exec "!szathura %:r.pdf" > /dev/null 2>&1 &"<cr><cr>

"let g:grammalecte_cli_py='~/Grammalecte-fr-v1.8.0/grammalecte-cli.py'
"setlocal spell spelllang=fr


autocmd FileType php nmap <F5> ysiw<s>
autocmd FileType tex inoremap MIT \mintinline{python}{}<++><Esc>4<left>i
autocmd FileType tex vnoremap <nowait> MIT <Esc>`>a}<Esc>gv<Esc>`<i\mintinline{python}{<Esc>$
autocmd FileType tex inoremap MIN \begin{minted}{python}<CR><CR>\end{minted}<++><Esc>ki

autocmd FileType tex inoremap ]] \left], <++>\right] <++><Esc>17<left>i
autocmd FileType tex inoremap ][ \left], <++>\right[ <++><Esc>17<left>i
autocmd FileType tex inoremap [] \left[, <++>\right] <++><Esc>17<left>i
autocmd FileType tex inoremap [[ \left[, <++>\right[ <++><Esc>17<left>i


autocmd FileType tex inoremap e^ \mathrm{e}^{}<++> <Esc>5<left>i 

" Augmenter ou diminuer la police
nnoremap <C-Up> :silent! let &guifont = substitute(&guifont,'\zs\d\+','\=eval(submatch(0)+1)','')<CR>
nnoremap <C-Down> :silent! let &guifont = substitute(
 \ &guifont,
 \ '\zs\d\+',
 \ '\=eval(submatch(0)-1)',
 \ '')<CR>


