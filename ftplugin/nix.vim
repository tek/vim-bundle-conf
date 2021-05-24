command! Hash call haskell#nix#hash_line(v:false, v:false)
command! HashExact call haskell#nix#hash_line(v:false, v:true)
command! Bump call haskell#nix#hash_line(v:true, v:false)
