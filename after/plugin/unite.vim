if !exists('g:unite_source_menu_menus')
  let g:unite_source_menu_menus = {}
endif
let g:unite_source_menu_menus.git = {
    \ 'description' : 'fugitive actions',
    \}
let g:unite_source_menu_menus.git.command_candidates = [
    \['▷ git status       (fugitive)', 'Gstatus'],
    \['▷ git diff         (fugitive)', 'Gdiff'],
    \['▷ git commit       (fugitive)', 'Gcommit'],
    \['▷ git log          (fugitive)', 'exe "silent Glog | Unite quickfix"'],
    \['▷ git blame        (fugitive)', 'Gblame'],
    \['▷ git stage        (fugitive)', 'Gwrite'],
    \['▷ git checkout     (fugitive)', 'Gread'],
    \['▷ git rm           (fugitive)', 'Gremove'],
    \['▷ git mv           (fugitive)', 'exe "Gmove " input("destination: ")'],
    \['▷ git push         (fugitive)', 'Git! push'],
    \['▷ git pull         (fugitive)', 'Git! pull'],
    \['▷ git prompt       (fugitive)', 'exe "Git! " input("git command: ")'],
    \['▷ git cd           (fugitive)', 'Gcd'],
    \]
nnoremap <silent> <leader>ug :Unite -silent menu:git<CR>

silent! unmap [u
silent! unmap [uu
silent! unmap ]u
silent! unmap ]uu
nmap <expr> <silent> ]u ':<c-u>UniteResume<cr>'.v:count.'<Plug>(unite_loop_cursor_down)<Plug>(unite_do_default_action)'
nmap <expr> <silent> [u ':<c-u>UniteResume<cr>'.v:count.'<Plug>(unite_loop_cursor_up)<Plug>(unite_do_default_action)'
