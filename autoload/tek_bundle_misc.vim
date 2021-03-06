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
  silent! call ProSave()
  silent! call MyoSave()
endfunction "}}}

function! tek_bundle_misc#set_sbtserver_address() abort "{{{
  let address = ''
  let info_file = 'project/target/active.json'
  if filereadable(info_file)
    silent! let data = json_decode(join(readfile(info_file), ''))
    if !empty(data) && has_key(data, 'uri')
      if data.uri[:5] == 'tcp://'
        let g:ale_scala_sbtserver_address = l:data.uri[6:]
      endif
    endif
  endif
endfunction "}}}
