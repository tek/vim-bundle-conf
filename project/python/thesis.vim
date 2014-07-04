command! -bang -range SennaToYaml silent <line1>,<line2>call tek_yaml#senna_to_yaml()
command! -bang -nargs=+ Senna silent call tek_yaml#senna_sentence(<q-args>)
command! -bang -range FormatSenna silent <line1>,<line2>call tek_yaml#format_senna()
