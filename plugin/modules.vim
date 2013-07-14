if has('python')
python << EOF
def pp_prepend(args):
    old_pp = os.environ.get('PYTHONPATH', '')
    os.environ['PYTHONPATH'] = ':'.join(args + [old_pp])
try:
    from sys import version_info, path
    import os
    import vim
    if version_info < (2, 5, 0):
        raise Exception('Python version %s too old!' % '.'.join(map(str, version_info)))
    mods = [vim.eval('g:python_modules_bundle_conf')]
    path[:0] = mods
    pp_prepend(mods)
except ImportError, e:
    print 'Python: Unable to import! ({})'.format(e)
except Exception, e:
    print e
EOF
endif
