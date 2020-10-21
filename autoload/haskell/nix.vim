function! haskell#nix#versions(pkg) abort "{{{
  let cmd = ['http', '-b', '--pretty', 'none', 'http://hackage.haskell.org/package/' . a:pkg . '/preferred', 'accept:application/json']
  let output = []
  let id = jobstart(cmd, { 'pty': v:true, 'on_stdout': { i, data, name -> extend(output, data) } })
  call jobwait([id])
  let result = json_decode(get(output, 0, '{"normal-version": []}'))
  return result['normal-version']
endfunction "}}}

function! haskell#nix#guess_version(pkg, prefix, bump) abort "{{{
  let all = haskell#nix#versions(a:pkg)
  let matching = a:bump ? all : filter(all, { i, v -> v =~ '^' . a:prefix . '.*' })
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

function! haskell#nix#hash_line(bump) abort "{{{
  let parts = matchlist(getline('.'), '\vpack "([^"]+)" "([^"]+)"')
  let pkg = get(parts, 1, '')
  let prefix = get(parts, 2, '')
  if empty(pkg)
    echo 'invalid line'
  else
    let guess = haskell#nix#guess_version(pkg, prefix, a:bump)
    if empty(guess)
      echo 'no matching version'
    else
      let hash = haskell#nix#hash(pkg . '-' . guess)
      if empty(hash)
        echo 'no output'
      else
        execute 'substitute /\vpack "[^"]+" "\zs[^"]+\ze"/' . guess
        execute 'substitute /\vpack "[^"]+" "[^"]+" "\zs[^"]+\ze"/' . hash
      endif
    endif
  endif
endfunction "}}}
