let g:neomake_javascript_enabled_makers = ['eslint_d']

let g:neomake_javascript_eslint_d_args = ['--format=compact', '--ignore-pattern', '!.neomake*']

let g:output_patterns += ['\bconsole\.log']
let g:output_file_patterns += ['\.js']
