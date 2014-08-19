
source $HOME/.vim/after/syntax/haskell/functions.vim
source $HOME/.vim/after/syntax/haskell/misspell.vim

" pragmas {{{

" insert LANGUAGE pragma
nnoremap <silent> <leader>l :call
  \ InsertLanguagePragma(InputList("Pragmas: "," ","CompleteExtensions"))<cr>

" insert pragma
nnoremap <leader>P :call
  \ InsertPragma(input("Pragma Type: "),InputList("Pragmas: "," "))<cr>

let g:dependent_pragmas =
  \ [ "FlexibleContexts"
  \ , "FlexibleInstances"
  \ , "UndecidableInstances"
  \ , "MultiParamTypeClasses"
  \ , "ScopedTypeVariables"
  \ , "RankNTypes"
  \ , "GADTs"
  \ , "TypeFamilies"
  \ , "TypeOperators"
  \ , "KindSignatures"
  \ , "ConstraintKinds"
  \ , "PolyKinds"
  \ , "DataKinds"
  \ ]

nnoremap <silent> <leader>D :call
  \ InsertPragma("LANGUAGE",g:dependent_pragmas)<cr>

nnoremap <silent> <leader>I :call InlineDef()<cr>

" }}}

" function definitions {{{

" copy function name from type sig onto next line
nnoremap <leader>U :call FillDef("= undefined",0)<cr>
" copy function name from type sig onto next line
nnoremap <leader>F :call FillDef("",1)<cr>

" gather definitions in file into @a
nmap <C-e> :let @a=''<cr>:g/::/y A<cr>gg}"aPjvap:s/ .*//g<cr>

" }}}

" commenting {{{

" comment out a paragraph
nnoremap <leader>c {o{-<esc>}O-}<esc>
" uncomment a paragraph
nnoremap <leader>C {jdd}kdd
" comment block top
nnoremap <leader>bC O{-<esc>
" comment block bottom
nnoremap <leader>bc o-}<esc>

" }}}

" imports {{{

" import module
nnoremap <leader>i Oimport 
" import qualified directive
nnoremap <leader>q Oimport qualified 

" import Data.Foo (Foo); import qualifed Data.Foo as F
nnoremap <leader>d :call ImportQualData()<cr>

" }}}

" syntax {{{

" vim lion align characters in a paragraph
nnoremap <leader>a :call AlignChar()<cr>

" toggle char under cursor between '.' and '$'
nnoremap <leader>. :call SwitchApp()<cr>

" toggle word under cursor between '_' and 'undefined'
nnoremap <leader>m :call SwitchHole()<cr>

nnoremap <leader>p :call PrevParenComma()<cr>
nnoremap <leader>n :call NextParenComma()<cr>

nnoremap <leader>G :call PrettyParenGroup()<cr>

" flip two expressions in a comma separated group
"   closed in braces, brackets, or parens
" nnoremap <leader>p :call FlipInGroup("{[(", "}])", ",")<cr>

" }}}

" folds {{{

" add fold section
nnoremap <leader>S i-- }}}<esc>O<cr><cr><cr><esc>3ki--  {{{<esc>3hi

" }}}

" syntastic options {{{

let g:hdevtools_options = '-g-ilib -g-isrc -g-i. -g-idist/build/autogen -g-Wall -g-package-conf='.FindCabalSandboxRootPackageConf()

" nnoremap <leader>, :ll<cr>
" nnoremap <leader>> :lne<cr>
" nnoremap <leader>< :lp<cr>
" nnoremap <buffer> <F1> :SyntasticCheck<cr>
" nnoremap <buffer> <F2> :HdevtoolsType<cr>
" nnoremap <buffer> <silent> <F3> :HdevtoolsClear<cr>
" nnoremap <buffer> <silent> <F4> :SyntasticReset<cr>

" vnoremap <expr> <SID>ClearVisual ClearVisual()
" nnoremap <script> v <SID>ClearVisualv
" nnoremap <script> V <SID>ClearVisualV
" nnoremap <script> <C-v> <SID>ClearVisual<C-v>

" }}}

