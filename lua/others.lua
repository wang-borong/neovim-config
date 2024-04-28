vim.cmd [[

" au ColorScheme * hi Normal ctermbg=none guibg=none
" au ColorScheme * hi SignColumn ctermbg=none guibg=none

set iskeyword+=-
tnoremap <Esc> <C-\><c-n>

try
  filetype on
  au BufNewFile *.sh,*.py,*.[ch],*.cc,*.cpp,*.hpp exec ":call SetTitle()"
  au BufWritePost *.[ch],*.cc,*.cpp,*.hpp exec ":call SubTitle(2)"
catch
endtry

" hide line numbers , statusline in specific buffers!
au BufEnter term://* setlocal nonumber
au BufEnter term://* set laststatus=0
" au BufEnter,BufWinEnter,WinEnter,CmdwinEnter * if bufname('%') == "NvimTree" | set laststatus=0 | else | set laststatus=2 | endif

" au FileType python setlocal textwidth=120
" au BufNewFile,BufRead *.[ch],*.cc,*.cpp,*.hpp set noexpandtab tabstop=8 shiftwidth=8 textwidth=120
" au BufNewFile,BufRead *.md set tabstop=2 shiftwidth=2
" au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" clean extra spaces
" autocmd BufWritePre *.c,*.h,*.py,*.sh,*.rs,*.txt,*.wiki,*.v,*.scala :call CleanExtraSpaces()
noremap <silent> ;cs :call CleanExtraSpaces()<CR>

" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

" When you press ;r you can search and replace the selected text
vnoremap <silent> ;r :call VisualSelection('replace', '')<CR>


function! CleanExtraSpaces()
  let save_cursor = getpos(".")
  let old_query = getreg('/')
  silent! %s/\s\+$//e
  call setpos('.', save_cursor)
  call setreg('/', old_query)
endfun

" visual selection operations
function! CmdLine(str)
  call feedkeys(":" . a:str)
endfunction

function! VisualSelection(direction, extra_filter) range
  let l:saved_reg = @"
  execute "normal! vgvy"

  let l:pattern = escape(@", "\\/.*'$^~[]")
  let l:pattern = substitute(l:pattern, "\n$", "", "")

  if a:direction == 'replace'
      call CmdLine("%s" . '/'. l:pattern . '/')
  endif

  let @/ = l:pattern
  let @" = l:saved_reg
endfunction

" set title for serval sources
function! SetTitle()
  let l:author = trim(system('git config user.name'))
  if l:author == ''
    let l:author = '[your name]'
  endif
  let l:curdate = strftime('%Y')
  let l:copyright = 'Copyright © ' . l:curdate . ' ' . l:author . '. All Rights Reserved.'
  let l:script_env = '#!/usr/bin/env '

  if &filetype == 'sh'
    call setline(1, l:script_env . 'bash')
    call append(line("."), "")
    call append(line(".")+1, "")
  elseif &filetype == 'python'
    call setline(1, l:script_env . 'python')
    call append(line("."),"")
    call append(line(".")+1, "")
  else
    call setline(1, "/*")
    call append(line("."), ' * ' . l:copyright)
    call append(line(".")+1," */")
    call append(line(".")+2, "")
    call append(line(".")+3, "")
  endif

  if expand("%:e") == 'c'
    call append(line(".")+4, '#include <stdio.h>')
    call append(line(".")+5, "")
    call append(line(".")+6, "")
  endif
  if expand("%:e") == 'h'
    call append(line(".")+4, "#ifndef __".toupper(substitute(expand("%:t"), "\\.h", "_h", "")))
    call append(line(".")+5, "#define __".toupper(substitute(expand("%:t"), "\\.h", "_h", "")))
    call append(line(".")+6, "")
    call append(line(".")+7, "")
    call append(line(".")+8, "")
    call append(line(".")+9, "#endif")
  endif
  if expand("%:e") == 'cpp'
    call append(line(".")+4, "#include <iostream>")
    call append(line(".")+5, "using namespace std;")
    call append(line(".")+6, "")
    call append(line(".")+7, "")
  endif
  if expand("%:e") == 'hpp'
    call append(line(".")+4, "#pragma once")
    call append(line(".")+5, "")
    call append(line(".")+6, "")
  endif
  " move cursor to appreciate line
  let l:line_num = line('$')
  if expand("%:e") == 'h'
    call cursor(l:line_num - 2, 1)
  else
    call cursor(l:line_num, 1)
  endif
endfunc

function! SubTitle(lineno)
  let l:author = trim(system('git config user.name'))
  if l:author == ''
    let l:author = '[your name]'
  endif
  let l:curdate = strftime('%Y')
  let l:crline = getline(a:lineno)
  let l:olddate_h = matchstr(l:crline, ' [0-9]\{4}', 3)
  let l:olddate_t = matchstr(l:crline, '-[0-9]\{4}', 3)
  let l:newdate_h = ' ' . l:curdate
  let l:newdate_t = '-' . l:curdate
  if match(l:crline, l:author) > 0
    if l:olddate_t != '' && l:olddate_t < l:newdate_t
      let l:new_data_str = l:newdate_t
      call setline(a:lineno, substitute(l:crline, l:olddate_t, l:new_data_str, ''))
    elseif l:olddate_h != '' && l:olddate_h < l:newdate_h
      if match(l:crline, '[0-9]\{4}-') < 0
        let l:new_data_str = l:olddate_h . l:newdate_t
        call setline(a:lineno, substitute(l:crline, l:olddate_h, l:new_data_str, ''))
      endif
    endif
  endif
endfunc

]]
