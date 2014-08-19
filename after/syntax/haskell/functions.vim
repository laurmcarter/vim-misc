
" completion test {{{

fu! ListMonths()
  call complete(col('.'), ['January', 'February', 'March',
    \ 'April', 'May', 'June', 'July', 'August', 'September',
    \ 'October', 'November', 'December'])
  return ''
endf

fu! TabComplete()
  let line = getline('.')
  let substr = strpart(line, -1, col('.')+1)
  let substr = matchstr(substr, "[^ \t]*$")
  if (strlen(substr)==0)
    return "\<tab>"
  endif
  return "\<c-x>\<c-p>"
endf
  
" }}}

" known extensions {{{

fu! CompleteExtensions(A,L,P)
    let l:pat = 'v:val =~ "^'.a:A.'"'
    return filter(g:ghc_extensions, l:pat)
endf

let g:ghc_extensions =
  \ [ 'OverlappingInstances', 'UndecidableInstances', 'IncoherentInstances',
  \   'RecursiveDo', 'ParallelListComp', 'MultiParamTypeClasses',
  \   'MonomorphismRestriction', 'FunctionalDependencies', 'Rank2Types',
  \   'RankNTypes', 'PolymorphicComponents', 'ExistentialQuantification',
  \   'ScopedTypeVariables', 'PatternSignatures', 'ImplicitParams',
  \   'FlexibleContexts', 'FlexibleInstances', 'EmptyDataDecls',
  \   'CPP', 'KindSignatures', 'BangPatterns',
  \   'TypeSynonymInstances', 'TemplateHaskell', 'ForeignFunctionInterface',
  \   'Arrows', 'Generics', 'ImplicitPrelude',
  \   'NamedFieldPuns', 'PatternGuards', 'GeneralizedNewtypeDeriving',
  \   'ExtensibleRecords', 'RestrictedTypeSynonyms', 'HereDocuments',
  \   'MagicHash', 'TypeFamilies', 'StandaloneDeriving',
  \   'UnicodeSyntax', 'UnliftedFFITypes', 'LiberalTypeSynonyms',
  \   'TypeOperators', 'RecordWildCards', 'RecordPuns',
  \   'DisambiguateRecordFields', 'OverloadedStrings', 'GADTs',
  \   'MonoPatBinds', 'RelaxedPolyRec', 'ExtendedDefaultRules',
  \   'UnboxedTuples', 'DeriveDataTypeable', 'ConstrainedClassMethods',
  \   'PackageImports', 'LambdaCase', 'ImpredicativeTypes',
  \   'NewQualifiedOperators', 'PostfixOperators', 'QuasiQuotes',
  \   'TransformListComp', 'ViewPatterns', 'XmlSyntax',
  \   'RegularPatterns', 'TupleSections', 'GHCForeignImportPrim',
  \   'NPlusKPatterns', 'DoAndIfThenElse', 'RebindableSyntax',
  \   'ExplicitForAll', 'DatatypeContexts', 'MonoLocalBinds',
  \   'DeriveFunctor', 'DeriveTraversable', 'DeriveFoldable',
  \   'NondecreasingIndentation', 'InterruptibleFFI', 'CApiFFI',
  \   'DataKinds', 'PolyKinds', 'MultiWayIf',
  \ ]


" }}}

" cabal sandboxes {{{

fu! FindCabalSandboxRoot()
    return RunShellCmd("realpath ".finddir('.cabal-sandbox'))
endf

fu! FindCabalSandboxRootPackageConf()
    return glob(FindCabalSandboxRoot().'/*-packages.conf.d')
endf

" }}}

" syntax manipulation {{{

fu! AlignChar()
    let l:chr = nr2char(getchar())
    exec "normal glip".l:chr
endf

fu! SwitchApp()
    let c = getline('.')[col('.') - 1]
    if c == "$"
        call feedkeys("xi.\<esc>")
    elseif c == '.'
        call feedkeys("xi$\<esc>")
    endif
endf

fu! SwitchHole()
    let w = expand("<cword>")
    if w == "undefined"
        call feedkeys("ciw_\<esc>")
    elseif w == "_"
        call feedkeys("ciwundefined\<esc>")
    endif
endf

fu! PrevParenComma()
    call feedkeys("?[(,]\<cr>")
endf

fu! NextParenComma()
    call feedkeys("/[(,]\<cr>")
endf

fu! PrettyParenGroup()
    call feedkeys(":s/\\([(,)]\\) */\\r  \\1 /g\<cr>")
endf

" fu! FlipInGroup(open, close, sep)
" 
"     let open  = escape(a:open, '[]')
"     let close = escape(a:close, '[]')
"     let sep   = a:sep
"     let anyopen = '['.open.']'
"     let anyclose = '['.close.']'
"     let nonspace = '[^ ]'
"     let prev = '['.open.sep.']'
"     let next = '['.close.sep.']'
"     let n    = 'normal'
" 
"     let done = "\<cr>"
"     let selectgroup = "?".anyopen.done."v/".anyclose.done
"     let prevgroup = "?".prev.done
"     let nextgroup = "/".next.done
" 
"     " echom open
"     " echom close
"     " echom prev
"     " echom next
" 
"     let c = getline('.')[col('.') - 1]
"     if c =~ anyopen                 | " if we're on the open paren, scoot off into the group,
"         exec n "l"
"     elseif c =~ anyclose            | " and if we're on the close paren, do the same.
"         exec n "h"
"     endif
" 
"     exec n prevgroup                     | " go back to last comma or open paren
"     exec n "ma"                          | " mark position
" 
"     exec n selectgroup.":s/ \\+/ /ge\<cr>`a"      | " normalize whitespace in group
"     exec n selectgroup.":s/\\(".anyopen."\\) \\+/\\1/ge\<cr>`a"
"     exec n selectgroup.":s/ \\+\\(".anyclose."\\)/\\1/ge\<cr>`a"
"     exec n "/".nonspace."\<cr>"          | " to go first non-space char after mark
"     exec n nextgroup                     | " select forward until next comma or close paren
"     exec n "?".nonspace."\<cr>d"         | " go back to closest non-space char and yank selection
"     exec n "mb"                          | " reset the mark.
"     let c = getline("'b")[col("'b") - 1]
"     if c == ")"                          | " if we just deleted the last of the group
"         exec n "P"                       | " put it back.
"     else
"         exec n nextgroup                 | " else, go to next delimiter
"         exec n "i, \<esc>p"              | " insert comma and paste after
"         exec n "`b"                      | " go back to leftover delimiter
"         exec n "v/".nonspace."\<cr>"     | " select leftover delimiter and whitespace
"         exec n "hd"                      | " deselect leading non-space character, and remove.
"     endif
" endf

" }}}

" quick definition {{{

fu! NearbyDefLine()
    let l = getline('.')
    if l !~ "::"
        let labove = getline(line('.') - 1)
        let lbelow = getline(line('.') + 1)
        if labove =~ "::"
            exec "normal k"
            return 0
        elseif lbelow =~ "::"
            exec "normal j"
            return 1
        endif
    endif
    return 1
endf

fu! CopyDefName()
    call NearbyDefLine()
    call feedkeys("^yaw")
endf

fu! InlineDef()
    call feedkeys("}")
    call NearbyDefLine()
    call CopyDefName()
    call feedkeys("}O{-# INLINE \<esc>pA #-}\<esc>")
endf

fu! FillDef(def,ins)
    let m = NearbyDefLine()
    call CopyDefName()
    call feedkeys("o\<esc>pA".a:def)
    if ! a:ins
        call feedkeys("\r\<esc>")
    endif
endf

" }}}

" pragmas {{{

fu! Insert(word)
    exe "normal i".a:word
endf

fu! InsertPragma(prg, ns, ...)
    let [b,l,c,o] = getpos('.')
    call setpos('.',[b,0,1,0])
    " exec "normal gg}"
    if type(a:ns) == type([])
        if a:0 == 0
            for n in a:ns
                call InsertPragma(a:prg,n)
            endfor
        else
            for n in a:ns
                call InsertPragma(a:prg,n,a:1)
            endfor
        endif
        let lns = len(a:ns)
    elseif type(a:ns) == type("")
        let l:word = "{-# ".a:prg." ".a:ns." #-}\r"
        call Insert(l:word)
        let lns = 1
    endif
    call setpos('.',[b,l + lns,c,o])
endf

fu! InsertLanguagePragma(ps,...)
    if a:0 == 0
        call InsertPragma("LANGUAGE",a:ps)
    else
        call InsertPragma("LANGUAGE",a:ps,a:1)
    endif
endf

fu! InputList(prompt, sep, ...)
    if a:0 == 0
        let l:inp = input(a:prompt)
    else
        let l:inp = input(a:prompt,"","customlist,".a:1)
    endif
    return split(l:inp, a:sep)
endf

" }}}

" imports {{{

fu! ImportQualData()
    call inputsave()
    let modl = input("Module: ")
    let typ  = input("Type: ",modl)
    let qual = typ[0]
    let imp  = "import Data.".modl." (".typ.")"
    let impq = "import qualified Data.".modl." as ".qual
    call inputrestore()
    call feedkeys("O".imp."\<cr>".impq."\<esc>j")
endf

" }}}

" quasi/anti quotation {{{

fu! QuasiAntiQuotes(genReg,quasiReg,antiReg,type,quasis,antis)
    call QuasiQuotes(a:quasiReg,a:type,a:quasis)
    let rs = AntiQuotes(a:genReg,a:antiReg,a:type,a:antis)
endf

fu! QuasiQuoteSyntax(quotReg,type, quot)
    let open  = '\['.a:quot.'|'
    let close = '|\]'
    call SyntaxRange#Include(open, close, a:type, a:quotReg)
endf

fu! QuasiQuotes(quotReg,type,qs)
    for q in a:qs
        call QuasiQuoteSyntax(a:quotReg,a:type,q)
    endfor
endf

let g:var_end = "\\(\\s\\|\\.\\|(\\|;\\)\\@1="

fu! AntiQuoteSyntax(genReg,quotReg,synNm,type,quot)
    let open = "\\$".a:quot.":"
    let cmd1 = "syntax region ".a:quotReg." contains=".a:genReg." contained containedin=".a:synNm." start=+".open."+ end=+".g:var_end."+"
    let cmd2 = "syntax match ".a:quotReg." contains=".a:genReg." contained containedin=".a:synNm." +".open."([^)]*)+"
    " let cmd3 = "syntax match ".a:quotReg." containedin=".a:regNm.",".a:parRegNm." +".open."+"
    " echom cmd1
    execute cmd1
    " echom cmd2
    execute cmd2
    " echom cmd3
    " execute cmd3
endf

fu! AntiQuotes(genReg,quotReg,type,qs)
    let type = toupper(a:type)
    " let regNm = "Haskell_".type
    " let parRegNm = regNm."_Parens"
    let synNm = "synInclude".type.",cUserCont"
    "                               ^^^ XXX: hack
    let cmd1 = "syntax region ".a:quotReg." contains=".a:genReg." contained containedin=".synNm." start=+\\$+ end=+".g:var_end."+"
    " let cmd2 = "syntax match ".a:quotReg." containedin=".regNm." +\\$+"
    execute cmd1
    " execute cmd2
    for q in a:qs
        call AntiQuoteSyntax(a:genReg,a:quotReg,synNm,a:type,q)
    endfor
    " return [regNm,parRegNm]
endf

let g:c_quoters =
  \ [ "cdecl"
  \ , "cedecl"
  \ , "cenum"
  \ , "cexp"
  \ , "cstm"
  \ , "cstms"
  \ , "citem"
  \ , "cfun"
  \ , "cinit"
  \ , "cparam"
  \ , "cparams"
  \ , "csdecl"
  \ , "cty"
  \ , "cunit"
  \ ]

let g:c_antiquoters =
  \ [ "id"
  \ , "const"
  \ , "int"
  \ , "uint"
  \ , "lint"
  \ , "ulint"
  \ , "llint"
  \ , "ullint"
  \ , "float"
  \ , "double"
  \ , "long double"
  \ , "char"
  \ , "string"
  \ , "exp"
  \ , "func"
  \ , "args"
  \ , "decl"
  \ , "decls"
  \ , "sdecl"
  \ , "sdecls"
  \ , "enum"
  \ , "enums"
  \ , "esc"
  \ , "edecl"
  \ , "edecls"
  \ , "item"
  \ , "items"
  \ , "stm"
  \ , "stms"
  \ , "ty"
  \ , "spec"
  \ , "param"
  \ , "params"
  \ , "pragma"
  \ , "init"
  \ , "inits"
  \ ]

" }}}

