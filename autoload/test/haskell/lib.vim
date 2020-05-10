function! test#haskell#lib#meta(file) abort "{{{
  let project_map = get(g:, 'haskell_project_map', {})
  let name = get(g:, 'hedgehog_project_name', g:proteome_main_name)
  let meta = matchlist(a:file, '\v%(%(modules|packages)/([^/]+)/)?(app|test|unit|integration)/%(\l+/)?(.*).hs')
  let dir = get(meta, 1, '')
  let type = get(meta, 2, 'test')
  let module = substitute(get(meta, 3, 'Main'), '/', '.', 'g')
  let skip = type == 'integration' ? 'unit' : 'integration'
  let package = get(project_map, dir, dir)
  let suite = empty(package) ? name : package
  return {
        \ 'type': type,
        \ 'name': name,
        \ 'suite': suite,
        \ 'dir': dir,
        \ 'skip': skip,
        \ 'module': module,
        \ }
endfunction "}}}
