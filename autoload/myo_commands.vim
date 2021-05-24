function! myo_commands#add(cmds) abort "{{{
  if !exists('g:myo_commands')
    let g:myo_commands = {}
  endif
  if !exists('g:myo_commands[''system'']')
    let g:myo_commands['system'] = a:cmds
  elseif count(g:myo_commands['system'], a:cmds[0]) == 0
    let g:myo_commands['system'] += a:cmds
  endif
endfunction "}}}
