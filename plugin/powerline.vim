if has('python')
python <<EOPY
try:
  from powerline.vim import setup as powerline_setup
  powerline_setup()
  del powerline_setup
  vim.command('set noshowmode')
except Exception as e:
  print e
EOPY
endif
