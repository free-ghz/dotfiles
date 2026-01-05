" DreamWiki syntax (custom)

if exists("b:current_syntax")
  finish
endif

" Commands:
"   ^CMD^ARG^
syntax match dreamwikiCommandLine /\v^\^[^^]*\^[^^]*\^\s*$/ contains=dreamwikiCommandName,dreamwikiCommandArg
syntax match dreamwikiCommandName /\v^\^\zs[^^]*\ze\^/ contained
syntax match dreamwikiCommandArg /\v^\^[^^]*\^\zs[^^]*\ze\^\s*$/ contained

" Comments (whole-line caret, but NOT command-shape above):
"   ^this is a comment
syntax match dreamwikiCommentLine /\v^\^[^^]*$/

" Links: ALL_CAPS and UNDERSCORES
syntax match dreamwikiLinkWord /\v<[A-Z_]{2,}[A-Z_]*>/

" Numbers: accent color
syntax match dreamwikiNumber /\v\d+/

highlight default link dreamwikiCommandLine PreProc
highlight default link dreamwikiCommandName Keyword
highlight default link dreamwikiCommandArg String
highlight default link dreamwikiCommentLine Comment
highlight default link dreamwikiLinkWord Identifier
highlight default link dreamwikiNumber Number

let b:current_syntax = "dreamwiki"


