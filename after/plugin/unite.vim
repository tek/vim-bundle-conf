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
