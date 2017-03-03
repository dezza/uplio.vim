if exists('g:loaded_uplio')
  finish
endif
let g:loaded_uplio = 1
 
if exists('g:uplio_strftime')
  let s:strftime = g:uplio_strftime
else
  let s:strftime = substitute(strftime('%x_%X'), '/\|:', '_', 'g')
endif

if !exists('g:uplio_echo_url')
  let g:uplio_echo_url = 1
endif

" :help write-plugin
"if !hasmapto('<Plug>Uplio_File')
"  nmap <unique> UU <Plug>Uplio_File
"endif
"if !hasmapto('<Plug>Uplio_Visual')
"  vmap <unique> UU <Plug>Uplio_Visual
"endif
" ^ Do not auto-map longer as newer vim plugins don't do that

nnoremap <unique> <script> <Plug>Uplio_File <SID>Uplio
nnoremap <SID>Uplio :call uplio#snippet#Uplio("n")<Enter>
vnoremap <unique> <script> <Plug>Uplio_Visual <SID>Uplio
vnoremap <SID>Uplio y:call uplio#snippet#Uplio("v")<Enter>
" y:call prevents call on every fkn line
