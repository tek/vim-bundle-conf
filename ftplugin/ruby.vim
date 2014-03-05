nmap <buffer> <leader>tf <Plug>(save-all)<Plug>(maque-file)
nmap <buffer> <leader>tl <Plug>(save-all)<Plug>(maque-line)

nmap <buffer><silent> <LocalLeader>f }]<space>of<tab>

let b:maque_args_rspec = '--drb --format d'

inoremap <plug>(cr) <cr>
imap <s-cr> <plug>(cr)<plug>DiscretionaryEnd
setlocal shell=zsh\ -l
