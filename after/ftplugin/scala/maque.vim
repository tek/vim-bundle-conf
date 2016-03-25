let current_path = expand('%')
if current_path =~ '/integration/'
  if tek#bundle#project#is('android')
    call maque#util#scala#set_android_test()
  else
    call maque#util#scala#set_scalatest()
  endif
elseif current_path =~ '/unit/'
  call maque#util#scala#set_scalatest()
endif

setlocal makeprg=make
