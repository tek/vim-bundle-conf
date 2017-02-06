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
