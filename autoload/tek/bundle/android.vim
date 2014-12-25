function! tek#bundle#android#set_prefixes(compile, run, test) abort "{{{
  let g:sbt_prefix = a:compile
  let c_pref = len(a:compile) > 0 ? a:compile . '/' : ''
  let r_pref = len(a:run) > 0 ? a:run . '/' : ''
  let t_pref = len(a:test) > 0 ? a:test . '/' : ''
  let g:sbt_compile = c_pref . 'compile'
  let g:sbt_run = r_pref . 'android:run'
  let g:sbt_test = t_pref . 'test'
endfunction "}}}
