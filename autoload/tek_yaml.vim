
function! tek_yaml#format_senna() abort range "{{{
  let range = a:firstline . ',' . a:lastline
  execute range . 'call tek_yaml#senna_to_yaml()'
  execute range . 'normal! guu'
  execute range . 'Tabularize /,\zs\s\+/'
  execute a:firstline .'put! =''-'''
endfunction "}}}

function! tek_yaml#senna_sentence(sent) abort "{{{
  if len(getline('$')) > 0
    $put =''
  end
  let begin = line('$') + 1
  execute '$r! zsh -ic ''senna ' . a:sent . ''''
  execute begin . ',$ FormatSenna'
endfunction "}}}
