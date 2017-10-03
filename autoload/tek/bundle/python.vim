let s:patterns = {
  \ 'test':      ['\v^    def %(setup|_)@<!(\w+)\(self>'],
  \ 'namespace': ['\v^class (\w+)'],
\}

function! tek#bundle#python#nearest_test(position) abort "{{{
  let data = test#base#nearest_test(a:position, s:patterns)
  if empty(data['namespace'])
    return ''
  elseif empty(data['test'])
    return data['namespace'][0]
  else
    return join([data['namespace'][0], data['test'][0]], '.')
  endif
endfunction "}}}

function! tek#bundle#python#coconut_mypy_process_output(context) abort "{{{
  python3 from amino.util.coconut_mypy import process_output
  let entries = py3eval('process_output(' . string(a:context.output) . ')')
  let bn = bufnr('%')
  for entry in entries
    let entry.bufnr = bn
  endfor
  return entries
endfunction "}}}
