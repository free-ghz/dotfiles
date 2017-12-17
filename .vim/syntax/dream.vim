" dreamwiki syntax file
" https://sixey.es/dreamwiki

" this thing quits if there is already
" a syntax file loaded, so we dont jamble
" things to a horrible degree
if exists("b:current_syntax")
    finish
endif



" DEFINING THINGS

" we want it to find these command lines:
" ^ command ^ parameter ^
" so it's nice that we can use regex.
syn match dreamCommand '^\^.*\^.*\^$'

" we want to find numbers because why not
syn match dreamNumber '\d'

" and caps things because they are LINKS
syn match dreamLink '[_A-Z]'



" THEN

" telling them we are here
let b:current_syntax = "dreamwiki"

" setting colors to the stuff
hi def link dreamCommand    Comment
hi def link dreamNumber     Type
hi def link dreamLink       Statement



" THATS IT, FOLKS
" dec 2017
