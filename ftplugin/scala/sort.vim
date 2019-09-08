if !g:readonly_project
  autocmd BufWrite <buffer> call scala#imports#sort_save()
endif
