if has('python')
python << EOF
from __future__ import print_function
try:
    from sys import path
    import vim
    path.insert(0, vim.eval('g:python_modules_bundle_conf'))
except ImportError as e:
    print('Python: Unable to import! ({})'.format(e))
except Exception as e:
    print(e)
EOF
endif

if has('python3')
python3 << EOF
try:
    from sys import path
    import vim
    path.insert(0, vim.eval('g:python_modules_bundle_conf'))
except ImportError as e:
    print('Python: Unable to import! ({})'.format(e))
except Exception as e:
    print(e)
EOF
endif
