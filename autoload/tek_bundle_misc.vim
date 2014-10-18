python3 <<EOP
def jump_or_expand(manager):
  jumped = manager._jump()
  vim.command('let g:ulti_jumped = {}'.format(int(jumped)))
  if not jumped:
    manager.expand()
EOP

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
  let s:session_dir = join([g:sessions_dir, g:project_type, g:project_name], '/')
  silent! call mkdir(s:session_dir, 'p')
  let g:session_dir = get(g:, 'session_dir', s:session_dir)
endfunction "}}}
