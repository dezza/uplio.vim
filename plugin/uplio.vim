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

function! s:GetVisualSelection()
  let [l:lnum1, l:col1] = getpos("'<")[1:2]
  let [l:lnum2, l:col2] = getpos("'>")[1:2]
  let l:lines = getline(l:lnum1, l:lnum2)
  let l:lines[-1] = lines[-1][: l:col2 - (&selection ==# 'inclusive' ? 1 : 2)]
  let l:lines[0] = lines[0][l:col1 - 1:]
  return lines
  "return join(lines, "\n")
endfunction

function! s:Uplio(mode)
  if a:mode ==# 'v'
    let l:visual=<SID>GetVisualSelection()
  endif

  let l:buf_fpath = expand('%:p') "get full path
  let l:buf_fname = expand('%:t') "get buffer filename
  let l:buf_fext = expand('%:e') "get file extension
  let l:buf_ft = &filetype "get detected buffer/file filetype from vim

  let l:pipe_to_clipboard = ' | ' "gets overwritten when OS is unknown
  if exists('g:uplio_clipboard_insert')
      let l:clipboard_insert=g:uplio_clipboard_insert
  elseif ($SSH_CLIENT || $SSH_TTY) && exists('$DISPLAY') "X11 forwarding
      let l:clipboard_insert='xclip -f'
  elseif has('unix') && exists('$DISPLAY')
      let l:clipboard_insert='xclip -f -selection clipboard'
  elseif has('max') "Darwin"
      " TODO: a -f equivalent for this too?
      let l:clipboard_insert='pbcopy'
  elseif has('win32')
      let l:clipboard_insert='clip'
  else 
      let l:clipboard_insert=''
      let l:pipe_to_clipboard = ''
  endif

  " file extension missing or full path is empty (visual mode)
  " (need temporary file)
  if empty(l:buf_fext) || a:mode ==# 'v'
    if exists('$TMPDIR')
      let l:tmp = $TMPDIR
    elseif has('win32')
      let l:tmp=$TEMP.'\'
    else
      let l:tmp = '/tmp/' " set a default /tmp
    endif
    
    let l:fname = l:tmp


    " unnamed buffers with timestamp
    if empty(l:buf_fpath)
      let l:fname = l:fname.'unnamed'

      if exists('*strftime')
        let l:fname = l:fname.'_'.strftime(s:strftime)
      endif
    else
      " visual mode OR no file extension
      let l:fname = l:fname.l:buf_fname
      " add extension
      if empty(l:buf_fext)
        if !empty(l:buf_ft)
          let l:fname = l:fname.'.'.l:buf_ft
        endif
      endif
    endif

    " open a new buffer to put visual contents in
    if a:mode ==# 'v'
      new
      put =l:visual
    endif

    " silent write without naming and writing
    " an unnamed buffer
    if has('win32')
      silent! exe 'w !findstr x* >'.l:fname
    elseif has('unix')
      silent! exe 'w !cat >'.l:fname
    else
      silent! exe 'w! '.l:fname
    endif
    " why really? because 'github.com/klim8d' wanted it

    if a:mode ==# 'v'
      bdelete!
    endif
  else
    " full path
    let l:fname = l:buf_fpath
  endif


  let l:curl = 'curl -s -F file=@'.'"'.l:fname.'" '.
        \'-F key='.g:uplio_key.
        \' https://upl.io'.l:pipe_to_clipboard.l:clipboard_insert

  let l:sh_out = system(l:curl)

  " delete tmpfile we created for visual mode
  if a:mode ==# 'v' || empty(l:buf_fname)
    call delete(l:fname)
  endif

  if !exists('g:uplio_echo_url') || g:uplio_echo_url
    redraw | echom l:sh_out
  endif
endfunction

" :help write-plugin
if !hasmapto('<Plug>Uplio_File')
  nmap <unique> UU <Plug>Uplio_File
endif
if !hasmapto('<Plug>Uplio_Visual')
  vmap <unique> UU <Plug>Uplio_Visual
endif

nnoremap <unique> <script> <Plug>Uplio_File <SID>Uplio
nnoremap <SID>Uplio :call <SID>Uplio("n")<Enter>
vnoremap <unique> <script> <Plug>Uplio_Visual <SID>Uplio
vnoremap <SID>Uplio y:call <SID>Uplio("v")<Enter>
" y:call prevents call on every fkn line
