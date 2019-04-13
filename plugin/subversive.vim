nmap gr <plug>(SubversiveSubstitute)
xmap gr <plug>(SubversiveSubstitute)
nmap grr <plug>(SubversiveSubstituteLine)
nmap gR <plug>(SubversiveSubstituteToEndOfLine)

nmap cr <plug>(SubversiveSubstituteRange)
nmap crr <plug>(SubversiveSubstituteWordRange)
nmap <silent> <leader>rw :<c-u>call subversive#doubleMotion#preSubstitute(v:register, 1, 0, 1, 0)<cr>:set opfunc=subversive#doubleMotion#selectTextMotion<cr>g@iwae
nmap <silent> <leader>rW :<c-u>call subversive#doubleMotion#preSubstitute(v:register, 1, 0, 1, 0)<cr>:set opfunc=subversive#doubleMotion#selectTextMotion<cr>g@iwae
nmap <leader>rW <plug>(SubversiveSubstituteRange)iWae
xmap <leader>cr <plug>(SubversiveSubstituteRange)
xmap <leader>r <plug>(SubversiveSubstituteRange)ae
