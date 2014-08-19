
setl lispwords+=pmatch,syntax-rules,syntax-case,let-values,match
syn keyword schemeSyntax ->

" ParentheC keywords
setl lispwords+=define-label,define-union,union-case,define-registers,define-program-counter,matche
syn keyword schemeSyntax define-label define-union union-case define-registers define-program-counter
syn keyword schemeFunc mount-trampoline dismount-trampoline

" miniKanren keywords
setl lispwords+=run,run*,exist,conde
syn keyword schemeSyntax run run* exist conde conda ifa condu ifu
syn keyword schemeFunc == =/= take

