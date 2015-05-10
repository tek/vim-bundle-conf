let current_path = expand('%')
if current_path =~ '/integration/'
  call maque#util#scala#set_android_test()
elseif current_path =~ '/unit/'
  call maque#util#scala#set_scalatest()
endif
