if isdirectory('free/debug')
  call tek#bundle#android#set_prefixes('debug', 'debug', 'unit')
else
  call tek#bundle#android#set_prefixes('', '', '')
endif

if g:project_name != 'droid'
  set tags+=~/code/scala/droid/.tags
endif
