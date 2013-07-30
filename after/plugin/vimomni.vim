if expand('%:p') =~ $HOME.'/.vim'
  if !exists('g:skip_caching_autoload')
    silent! runtime! autoload/maque/**/*.vim
  endif
endif
