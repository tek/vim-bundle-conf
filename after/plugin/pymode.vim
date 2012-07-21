let gmaps = ['u', 'r', 'c', 'o', 'g', '4f', 'f', 'np', 'nm', 'nf', 'nd', 'k']
let lmaps = ['u', 'ad', 'ac', 'x', '1r', 'r', 'o', '1v', 'v', '1p', 'a?', 'aj', 'f', 'i', 'ag', 'nv', 'np', 'nm', 'nf', 'nc', 'af', 'ai', 'l', 'm', 'a/', 's', 'a']
let smaps = ['m', 'f', 'd', 'g']

if exists('g:pymode_rope_global_prefix')
  for [prefix, maps] in [[g:pymode_rope_global_prefix, gmaps], [g:pymode_rope_local_prefix, lmaps], [g:pymode_rope_short_prefix, smaps]]
    for m in maps
      let mapping = prefix.m
      if len(maparg(mapping))
        exe 'unmap '.mapping
      endif
    endfor
  endfor
endif
