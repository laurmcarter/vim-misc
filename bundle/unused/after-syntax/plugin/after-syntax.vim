" Call this with something like
"
" :AddAttrToGroup perlRepeat
"

fu! FindHiAttrs(group)
    " Redirect the output of the "hi" command into a variable
    " and find the highlighting
    redir => GroupDetails
    exe "silent hi " . a:group
    redir END

    " Resolve linked groups to find the root highlighting scheme
    while GroupDetails =~ "links to"
        let index = stridx(GroupDetails, "links to") + len("links to")
        let LinkedGroup =  strpart(GroupDetails, index + 1)
        redir => GroupDetails
        exe "silent hi " . LinkedGroup
        redir END
    endwhile

    " Extract the highlighting details (the bit after "xxx")
    let MatchGroups = matchlist(GroupDetails, '\<xxx\>\s\+\(.*\)')
    return MatchGroups[1]
endf

command! -complete=highlight -nargs=+ AddAttrToGroup call AddAttrToGroup(<f-args>)

fu! AddAttrToGroup(group,attr,val)
    let ExistingHighlight = FindHiAttrs(a:group)

    " Check whether there's an existing "a:attr=" block
    let MatchGroups = matchlist(ExistingHighlight, '^\(.\{-}\) '.a:attr.'=\([^ ]\+\)\( .\{-}\)\?$')
    if MatchGroups != []
        " If there is, check whether a:val is already in it
        let StartHighlight = MatchGroups[1]
        let AttrHighlight = MatchGroups[2]
        let EndHighlight = MatchGroups[3]
        if AttrHighlight =~ '.*'.a:val.'.*'
        " Already done
        return
        endif
        " Add val to the attr block
        let AttrHighlight .= ','.a:val
        let NewHighlight = StartHighlight . AttrHighlight . EndHighlight
    else
        " If there's no block for a:attr, just add one with a:val in it
        let NewHighlight = ExistingHighlight . " ".a:attr."=".a:val
    endif

    " Create the highlighting group
    exe "hi " . a:group . " " NewHighlight
endf

