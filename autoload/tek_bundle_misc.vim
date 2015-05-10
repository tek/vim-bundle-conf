try
python3 <<EOP
def jump_or_expand(manager):
  jumped = manager._jump()
  vim.command('let g:ulti_jumped = {}'.format(int(jumped)))
  if not jumped:
    manager.expand()
EOP
catch
endtry

function! tek_bundle_misc#ulti_snips_jump_or_expand() abort "{{{
  if pumvisible()
    py3 UltiSnips_Manager._cursor_moved()
  endif
  py3 jump_or_expand(UltiSnips_Manager)
  return g:ulti_jumped || g:ulti_expand_res ? '' : "\<tab>"
endfunction

function! tek_bundle_misc#kill_session() abort "{{{
  if exists('g:session_dir') && isdirectory(g:session_dir)
    execute 'silent !rm -rf ' . g:session_dir 
    redraw!
  else
    call tek_misc#warn('g:session_dir not a directory!')
  endif
endfunction "}}}

function! tek_bundle_misc#init_session_dir() abort "{{{
  let g:sessions_dir = get(g:, 'sessions_dir', expand('~/usr/var/tmp/vim/session'))
  let session_dir = join([g:sessions_dir, g:project_type, g:project_name], '/')
  silent! call mkdir(session_dir, 'p')
  let g:session_dir = get(g:, 'session_dir', session_dir)
endfunction "}}}

function! tek_bundle_misc#textobj_function_map() abort "{{{
  omap <buffer> af <Plug>(textobj-function-a)
  omap <buffer> if <Plug>(textobj-function-i)

  xmap <buffer> af <Plug>(textobj-function-a)
  xmap <buffer> if <Plug>(textobj-function-i)
endfunction "}}}

function! tek_bundle_misc#activate_root(index, ...) abort "{{{
  let root_dir = g:root_dirs[a:index]
  " let g:ctrlp_cmd = 'CtrlP ' . root_dir
  let relative = root_dir[0] != '/'
  let target = relative ? $PWD . '/' . root_dir : root_dir
  execute 'cd ' . target
  if get(a:000, 0)
    if root_dir == $PWD
      let root_dir = '.'
    endif
    echo 'New root: ' . root_dir
  endif
endfunction

function! tek_bundle_misc#cycle_root_dir() abort "{{{
  let g:root_dir = (g:root_dir + 1) % len(g:root_dirs)
  call tek_bundle_misc#activate_root(g:root_dir, 1)
endfunction "}}}

function! tek_bundle_misc#ctrlp() abort "{{{
  execute g:ctrlp_cmd
endfunction "}}}
