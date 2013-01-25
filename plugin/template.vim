fun! s:template_keywords() "{{{
  for var in ['year', 'author']
    let val = eval('g:template_'.var)
    exe '%s/<'.var.'>/'.val.'/e'
  endfor
  python << END
try:
    import vim
    from os import path
    from tek.tools import camelcaseify
    name = path.splitext(path.basename(vim.current.buffer.name))[0]
    name = camelcaseify(name)
    vim.command('let l:pytestname="{}"'.format(name))
except:
    pass
try:
    import re
    import vim
    from os import path
    from tek.tools import camelcaseify
    match = re.search('([^/]+)_controller.coffee$', vim.current.buffer.name)
    if match:
      ctrl = match.group(1)
      vim.command('let l:coffee_ctrl = "{}"'.format(camelcaseify(ctrl)))
except:
    pass
END
  if exists('l:pytestname')
    exe '%s#<pythontestname>#'.l:pytestname.'#e'
  endif
  if exists('l:coffee_ctrl')
    exe '%s#<coffee_ctrl_name>#'.l:coffee_ctrl.'#e'
  endif
	if search('<+CURSOR+>')
	  execute 'normal! "_da>'
	endif
endfunction "}}}

" skeletons
let g:template_basedir = '~/.vim/tek'
let g:template_year = strftime('%Y')
let g:template_author = 'Torsten Schmits'

augroup tek_global
  " after the template for a new file has been loaded, replace keywords like
  " date and name
  autocmd User plugin-template-loaded call s:template_keywords()
augroup end
