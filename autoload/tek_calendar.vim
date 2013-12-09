function! tek_calendar#open(day, month, year, week, dir) "{{{
  wincmd w
  execute 'edit log/'.a:year.'_'.a:month.'_'.a:day.'.tex'
endfunction "}}}
