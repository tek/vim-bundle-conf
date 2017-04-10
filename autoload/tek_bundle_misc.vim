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
  let session_dir = join([g:sessions_dir, g:proteome_main_type, g:proteome_main_name], '/')
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
  let g:root_dir = a:index % len(g:root_dirs)
  let root_dir = g:root_dirs[g:root_dir]
  " let g:ctrlp_cmd = 'CtrlP ' . root_dir
  let relative = root_dir[0] != '/'
  let target = relative ? $PWD . '/' . root_dir : root_dir
  execute 'cd ' . target
  if get(a:000, 0)
    if root_dir == $PWD
      let g:root_dir_name = ''
      let root_dir = '.'
    else
      let g:root_dir_name = fnamemodify(root_dir, ':t')
    endif
    echo 'New root: ' . root_dir
  endif
endfunction

function! tek_bundle_misc#home_root() abort "{{{
  return tek_bundle_misc#activate_root(0, 1)
endfunction "}}}

function! tek_bundle_misc#cycle_root_dir() abort "{{{
  call tek_bundle_misc#activate_root(g:root_dir + 1, 1)
endfunction "}}}

function! tek_bundle_misc#ctrlp() abort "{{{
  execute g:ctrlp_cmd
endfunction "}}}

function! tek_bundle_misc#abspath(rel) abort "{{{
  return substitute(fnamemodify(a:rel, ':p'), '/$', '', '')
endfunction "}}}

function! tek_bundle_misc#add_root_project(path) abort "{{{
  let abs = tek_bundle_misc#abspath(a:path)
  let g:root_dirs += [abs]
  call tek_bundle_misc#add_ctags_source(abs)
endfunction "}}}

function! tek_bundle_misc#add_ctags_source(path) abort "{{{
  let abs = tek_bundle_misc#abspath(a:path)
  let g:ctags_dirs += [abs]
  let &tags .= ',' . abs . '/.tags'
endfunction "}}}

function! tek_bundle_misc#post_save() abort "{{{
  silent! ProSave
endfunction "}}}
