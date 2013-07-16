if has('python')
python <<EOPY
try:
  from powerline.vim import setup as powerline_setup
  powerline_setup()
  del powerline_setup
except Exception as e:
  print e
EOPY
endif
