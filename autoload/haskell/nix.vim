function! haskell#nix#hash(pkg) abort "{{{
  let output = systemlist(['nix-prefetch-url', '--unpack', 'http://hackage.haskell.org/package/' . a:pkg . '/' . a:pkg . '.tar.gz'])
  return get(output, -1)
endfunction "}}}

function! haskell#nix#hash_line() abort "{{{
  let parts = matchlist(getline('.'), '\vpack "([^"]+)" "([^"]+)"')
  let name = get(parts, 1, '')
  let ver = get(parts, 2, '')
  if empty(name) || empty(ver)
    echo 'invalid line'
  else
    let hash = haskell#nix#hash(name . '-' . ver)
    if empty(hash)
      echo 'no output'
    else
      execute 'substitute /\vpack "[^"]+" "[^"]+" "\zs[^"]+\ze"/' . hash
    endif
  endif
endfunction "}}}
