function! tek_airline#init() abort "{{{
  call airline#parts#define_function('sbt_project', 'tek_airline#sbt_project')
  call airline#parts#define_function('root_dir', 'tek_airline#root_dir')
  call airline#parts#define_function('trunc_file', 'tek_airline#file')
  call airline#parts#define_function('modified', 'tek_airline#modified')
  call airline#parts#define_function('modifiable', 'tek_airline#modifiable')
  call airline#parts#define_accent('modified', 'red')
  call airline#parts#define_accent('modifiable', 'red')
  call airline#parts#define_raw('linenr',
        \ '%{g:airline_symbols.linenr} %#__accent_bold#%l%#__restore__#')
  let g:airline_section_x = ''
  let g:airline_section_c =
        \ airline#section#create(['trunc_file', ' ', 'modified', 'modifiable']
        \ )
  let g:airline_section_y =
        \ airline#section#create_left(['sbt_project', 'root_dir'])
endfunction "}}}

function! tek_airline#root_dir() abort "{{{
  return get(g:, 'root_dir_name', '')
endfunction "}}}

function! tek_airline#sbt_project() abort "{{{
  return get(g:, 'sbt_prefix', '')
endfunction "}}}

let s:any = 'ANY_PROJECT'
let s:home_pre = '^' . $HOME

let g:tek_airline_file_truncations = [
      \ ['scala', s:home_pre . '/code/scala/'],
      \ [s:any, s:home_pre . '/code/'],
      \ ['scala', 'src/'],
      \ ['', getcwd() . '/', ''],
      \ ['', s:home_pre, '~'],
      \ ]

function! tek_airline#file() abort "{{{
  let f = expand('%')
  if len(f)
    let f = tek_bundle_misc#abspath(f)
    for item in g:tek_airline_file_truncations
      let pro = get(item, 0, s:any)
      let target = get(item, 1, '')
      let repl = get(item, 2, '')
      if target != '' && (
            \ pro == '' ||
            \ (pro == s:any && exists('g:project_type')) ||
            \ pro == get(g:, 'project_type', '')
            \ )
        let f = substitute(f, target, repl, 'g')
      endif
    endfor
  endif
  return f
endfunction "}}}

function! tek_airline#modified() abort "{{{
  if &modified
    return '+'
  else
    return ''
  end
endfunction "}}}

function! tek_airline#modifiable() abort "{{{
  if &modifiable
    return ''
  else
    return '-'
  end
endfunction "}}}
