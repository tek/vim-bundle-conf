function! haskell#nix#versions(pkg) abort "{{{
  let cmd = ['http', '-b', '--pretty', 'none', 'http://hackage.haskell.org/package/' . a:pkg . '/preferred', 'accept:application/json']
  let output = []
  let id = jobstart(cmd, { 'pty': v:true, 'on_stdout': { i, data, name -> extend(output, data) } })
  call jobwait([id])
  let result = json_decode(get(output, 0, '{"normal-version": []}'))
  return result['normal-version']
endfunction "}}}

function! haskell#nix#guess_version(pkg, prefix, bump, exact) abort "{{{
  let all = haskell#nix#versions(a:pkg)
  let rex = a:exact ? a:prefix . '$' : a:prefix . '.*'
  let matching = a:bump ? all : filter(all, { i, v -> v =~ '^' . rex })
  return get(matching, 0, '')
endfunction "}}}

function! haskell#nix#hash(pkg) abort "{{{
  let output = systemlist(['nix-prefetch-url', '--unpack', 'https://hackage.haskell.org/package/' . a:pkg . '/' . a:pkg . '.tar.gz'])
  if v:shell_error
    return ''
  else
    return get(output, -1, '')
  endif
endfunction "}}}

function! haskell#nix#hash_line_new(bump, exact) abort "{{{
  let parts = matchlist(getline('.'), '\v(\S+) \= .*hackage "([^"]*)"')
  let pkg = get(parts, 1, '')
  let prefix = get(parts, 2, '')
  if empty(pkg)
    echo 'invalid line'
  else
    let guess = haskell#nix#guess_version(pkg, prefix, a:bump, a:exact)
    if empty(guess)
      echo 'no matching version'
    else
      let hash = haskell#nix#hash(pkg . '-' . guess)
      if empty(hash)
        echo 'no output'
      else
        execute 'substitute /\vhackage "\zs[^"]*\ze"/' . guess
        execute 'substitute /\vhackage "[^"]*" "\zs[^"]*\ze"/' . hash
      endif
    endif
  endif
endfunction "}}}

function! haskell#nix#hash_line(bump, exact) abort "{{{
  let parts = matchlist(getline('.'), '\v%(pack|version) "([^"]+)" "([^"]+)"')
  let pkg = get(parts, 1, '')
  let prefix = get(parts, 2, '')
  if empty(pkg)
    return haskell#nix#hash_line_new(a:bump, a:exact)
  else
    let guess = haskell#nix#guess_version(pkg, prefix, a:bump, a:exact)
    if empty(guess)
      echo 'no matching version'
    else
      let hash = haskell#nix#hash(pkg . '-' . guess)
      if empty(hash)
        echo 'no output'
      else
        execute 'substitute /\v%(pack|version) "[^"]+" "\zs[^"]+\ze"/' . guess
        execute 'substitute /\v%(pack|version) "[^"]+" "[^"]+" "\zs[^"]+\ze"/' . hash
      endif
    endif
  endif
endfunction "}}}
