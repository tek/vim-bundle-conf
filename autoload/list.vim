function! list#exists(fa, f) abort "{{{
  for a in a:fa
    if call(a:f, [a])
      return v:true
    endif
  endfor
  return v:false
endfunction "}}}

function! list#fmap(fa, f) abort "{{{
  return map(copy(a:fa), { i, a -> call(a:f, [a]) })
endfunction "}}}

function! list#fold_left(f, z, fa) abort "{{{
  let agg = a:z
  for a in a:fa
    let agg = call(a:f, [agg, a])
  endfor
  return agg
endfunction "}}}

function! list#concat(fs) abort "{{{
  return list#fold_left({ z, a -> z + a }, [], a:fs)
endfunction "}}}
