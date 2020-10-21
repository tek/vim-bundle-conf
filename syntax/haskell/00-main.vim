if exists("b:current_syntax")
  finish
endif

setlocal maxmempattern=10000

function! s:q(a) abort "{{{
  return " /" . a:a . "/ "
endfunction "}}}

function! s:qv(key, value) abort "{{{
  return ' ' . a:key . "=/" . a:value . "/ "
endfunction "}}}

let s:keywords_basic = [
  \ 'case',
  \ 'class',
  \ 'data',
  \ 'default',
  \ 'deriving',
  \ 'do',
  \ 'else',
  \ 'family',
  \ 'forall',
  \ 'foreign',
  \ 'if',
  \ 'import',
  \ 'in',
  \ 'infix',
  \ 'infixl',
  \ 'infixr',
  \ 'instance',
  \ 'module',
  \ 'newtype',
  \ 'of',
  \ 'then',
  \ 'type',
  \ 'via',
  \ ]
let s:keywords = s:keywords_basic + ['let', 'where']

let s:op_char = '[\-∀!#$%&*+/<=>?@\\^|~:.]'
let s:keyword_re = '\v<%(' . join(s:keywords, '|') . ')>'
let s:no_keyword = '\v%(' . s:keyword_re . ')@!'
let s:opts = ' contained skipwhite skipnl '
let s:var_re = s:no_keyword . '\v<[a-z_]\k*#?>'
let s:sym_var_re = '\v\(' . s:op_char . '+\)'
let s:sym_or_var_re = '\v%(' . s:sym_var_re . '|' . s:var_re . ')'
let s:conid_re = '\v<''?''?\u\k*>'
let s:conid_re_q = s:q(s:conid_re)
let s:wli = '\v%(<%(where|let|in)>\s+)'
let s:comment_re = '\v\s*%(' . s:op_char . ')@<!--+%(\k|\s|$).*$'
let s:inline_comment = '\v%(\s*--+%(\k|\s).*\n\s*)?'
let s:till_comment = '.*\ze' . s:comment_re
let s:operator = '\v%(--|::|<-)@!' . s:op_char . '+'
let s:exclude_strings = ' containedin=ALLBUT,HsComment,HsBlockComment,HsQQ,HsString,HsPragma,HsLiquid'

function! s:optional(name, value) abort "{{{
  return empty(a:value) ? '' : ' ' . a:name . '=' . a:value . ' '
endfunction "}}}

function! s:no_op_around(main) abort "{{{
  return '\v' . s:op_char . '@<!' . a:main . '' . s:op_char . '@!'
endfunction "}}}

function! s:with_comment(main) abort "{{{
  return a:main . '\v(' . s:comment_re . ')?'
endfunction "}}}

function! s:syn(main, contains, nextgroup) abort "{{{
  execute 'syntax ' . a:main .
    \ (empty(a:contains) ? '' : ' contains=' . a:contains) .
    \ (empty(a:nextgroup) ? '' : ' nextgroup=' . a:nextgroup)
endfunction "}}}

function! s:keyword(name, values, extra) abort "{{{
  return s:syn('keyword ' . a:name . ' ' . join(a:values, ' ') . ' contained ' . a:extra, '', '')
endfunction "}}}

function! s:match_top(name, pattern, extra, contains, nextgroup) abort "{{{
  return s:syn('match ' . a:name . s:q(a:pattern) . a:extra, a:contains, a:nextgroup)
endfunction "}}}

function! s:match(name, pattern, extra, contains, nextgroup) abort "{{{
  return s:match_top(a:name, a:pattern, s:opts . a:extra, a:contains, a:nextgroup)
endfunction "}}}

function! s:region_top(name, mg_start, start, mg_end, end, extra, contains, nextgroup) abort "{{{
  return s:syn(
    \ 'region ' . a:name . s:optional('matchgroup', a:mg_start) . s:qv('start', a:start) .
    \   s:optional('matchgroup', a:mg_end) . s:qv('end', a:end) . a:extra,
    \ a:contains,
    \ a:nextgroup,
    \ )
endfunction "}}}

function! s:region(name, mg_start, start, mg_end, end, extra, contains, nextgroup) abort "{{{
  return s:region_top(a:name, a:mg_start, a:start, a:mg_end, a:end, s:opts . a:extra, a:contains, a:nextgroup)
endfunction "}}}

function! s:indent_region_zero(name, matchgroup, start, extra, contains, nextgroup) abort "{{{
  return s:region_top(
    \ a:name,
    \ a:matchgroup,
    \ a:start,
    \ '',
    \ '\v\ze^\S',
    \ a:extra . ' keepend ',
    \ a:contains,
    \ a:nextgroup,
    \ )
endfunction "}}}

function! s:indent_region_top(name, matchgroup, pre, start, extra, contains, nextgroup) abort "{{{
  return s:region_top(
    \ a:name,
    \ a:matchgroup,
    \ '\v(^\z(\s*)' . a:pre . ')@<=' . a:start,
    \ '',
    \ '\v\ze(' . s:comment_re . ')?\n\s*(^\z1\s+)@<!\S',
    \ a:extra . ' keepend ',
    \ a:contains,
    \ a:nextgroup,
    \ )
endfunction "}}}

function! s:indent_region(name, matchgroup, pre, start, extra, contains, nextgroup) abort "{{{
  return s:indent_region_top(a:name, a:matchgroup, a:pre, a:start, s:opts . a:extra, a:contains, a:nextgroup)
endfunction "}}}

function! s:indent_region_eq_top(name, matchgroup, pre, start, extra, contains, nextgroup) abort "{{{
  return s:region_top(
    \ a:name,
    \ a:matchgroup,
    \ '\v(^\z(\s*)' . a:pre . ')@<=' . a:start,
    \ '',
    \ '\v\ze^\s*(^\z1\s*)@<!\S',
    \ a:extra,
    \ a:contains,
    \ a:nextgroup,
    \ )
endfunction "}}}

function! s:indent_region_eq(name, matchgroup, pre, start, extra, contains, nextgroup) abort "{{{
  return s:indent_region_eq_top(a:name, a:matchgroup, a:pre, a:start, s:opts . a:extra, a:contains, a:nextgroup)
endfunction "}}}

" Consume everything until the 'end' pattern, but require newlines to be followed by the indent of the start location
" Since this doesn't use a region, it can be used multiple times at the same location
function! s:indented_till_top(name, end, extra, contains, nextgroup) abort "{{{
  return s:match_top(
    \ a:name,
    \ '\v%(^(\s*)\S.*)@<=\s*\S.*%(\n\s*%(^\1\s+)@<=\S.*)*\ze' . a:end,
    \ a:extra . ' keepend ',
    \ a:contains,
    \ a:nextgroup,
    \ )
endfunction "}}}

function! s:indented_till(name, end, extra, contains, nextgroup) abort "{{{
  return s:indented_till_top(a:name, a:end, s:opts . a:extra, a:contains, a:nextgroup)
endfunction "}}}

function! s:brak_top(name, matchgroup, l, r, extra, contains, nextgroup) abort "{{{
  return s:region_top(
    \ a:name,
    \ a:matchgroup,
    \ a:l,
    \ '',
    \ a:r,
    \ a:extra,
    \ a:contains,
    \ a:nextgroup,
    \ )
endfunction "}}}

function! s:parens(name, matchgroup, contains, nextgroup) abort "{{{
  return s:brak_top(a:name, a:matchgroup, '(', ')', s:opts, a:contains, a:nextgroup)
endfunction "}}}

function! s:braces_top(name, extra, contains, nextgroup) abort "{{{
  return s:brak_top(a:name, 'HsDiscreetBrackets', '\v\{(-)@!', '}', a:extra, a:contains, a:nextgroup)
endfunction "}}}

function! s:braces(name, extra, contains, nextgroup) abort "{{{
  return s:braces_top(a:name, s:opts . a:extra, a:contains, a:nextgroup)
endfunction "}}}

function! s:brackets_top(name, matchgroup, extra, contains, nextgroup) abort "{{{
  return s:brak_top(a:name, a:matchgroup, '\v''?\[', '\]', a:extra, a:contains, a:nextgroup)
endfunction "}}}

function! s:brackets(name, matchgroup, contains, nextgroup) abort "{{{
  return s:brackets_top(a:name, a:matchgroup, s:opts, a:contains, a:nextgroup)
endfunction "}}}

function! s:NameWith(name, extra, contains, nextgroup) abort "{{{
  return s:syn('match ' . a:name . s:conid_re_q . a:extra, a:contains, a:nextgroup)
endfunction "}}}

function! s:Name(name, contains, nextgroup) abort "{{{
  return s:NameWith(a:name, s:opts, a:contains, a:nextgroup)
endfunction "}}}

function! s:Name_top(name, contains, nextgroup) abort "{{{
  return s:NameWith(a:name, '', a:contains, a:nextgroup)
endfunction "}}}

function! s:nameWith(name, extra, contains, nextgroup) abort "{{{
  return s:syn('match ' . a:name . s:q(s:var_re) . a:extra, a:contains, a:nextgroup)
endfunction "}}}

function! s:name(name, contains, nextgroup) abort "{{{
  return s:nameWith(a:name, s:opts, a:contains, a:nextgroup)
endfunction "}}}

function! s:symOrNameWith(name, extra, contains, nextgroup) abort "{{{
  return s:syn('match ' . a:name . s:q(s:sym_or_var_re) . a:extra, a:contains, a:nextgroup)
endfunction "}}}

function! s:symOrName(name, contains, nextgroup) abort "{{{
  return s:symOrNameWith(a:name, s:opts, a:contains, a:nextgroup)
endfunction "}}}

function! s:top_decl(name, keyword, head, where_body, eq_body) abort "{{{
  let prefix = 'Hs' . a:name
  let main_name = 'HsTopDecl' . a:name
  let where_name = prefix . 'Where'
  let eq_name = prefix . 'Eq'
  let plain_name = prefix . 'Plain'
  let bodies = where_name . ',' . eq_name . ',' . plain_name
  call s:match_top(main_name, '\v^' . a:keyword . '>', 'skipwhite skipnl', 'HsTopDeclKeyword', bodies)
  call s:indent_region(plain_name, '', '\S.*', ' ', '', a:head, '')
  call s:indented_till(eq_name, '\v\_s\=\_s', '', a:head, a:eq_body)
  call s:indented_till(where_name, '\v<where>', '', a:head, a:where_body)
endfunction "}}}

syntax spell notoplevel
syntax sync match HsSyncEmptyLine grouphere NONE "\n\n"

" fallbacks and generics

call s:Name('HsTycon', '', '')
highlight def link HsTycon Type

call s:Name('HsFunParamType', '', '')
highlight! link HsFunParamType HsTycon

syntax match HsConId '\<\u\k*\>' contained
highlight def link HsConId Type

syntax match HsStrongBrackets '[({})]' contained
highlight def link HsStrongBrackets Delimiter

syntax match HsDiscreetBrackets '[({})]' contained
highlight def link HsDiscreetBrackets Delimiter

syntax match HsQualifyingModule '\v<\u\k*\ze\.' contained contains=HsModId,HsModuleDot
highlight def link HsQualifyingModule Type

syntax match HsQualifiedCtor '\v%(\u\k*\.)*\u\k*' contained contains=HsQualifyingModule,HsConId

call s:match('HsQualifiedType', '\v%(' . s:conid_re . ')*' . s:conid_re, '', 'HsQualifyingModule,HsTycon', '')

syntax match HsQualifiedVar '\v%(\u\k*\.)+[a-z_]\k*' contains=HsQualifyingModule,HsVar

call s:match(
  \ 'HsOperator',
  \ s:operator,
  \ s:exclude_strings . ',HsImportSymbolicTypeName,HsImportSymbolicCtorName,HsLambda,HsDeclName,HsFunName,HsFunNameSym',
  \ '',
  \ '',
  \ )
highlight def link HsOperator Operator

call s:keyword('HsKeywordBasic', s:keywords_basic, '')
highlight def link HsKeywordBasic HsKeyword

syntax keyword HsKeywordLetWhere where let contained
highlight def link HsKeywordLetWhere HsKeyword

syntax cluster HsKeyword contains=HsKeywordBasic,HsKeywordLetWhere
highlight def link HsKeyword Keyword

call s:Name('HsClassName', '', '')

call s:match_top('HsDefaultDecl', '\v^default\s*\(.*\)\s*$', '', 'HsKeywordBasic,@HsType', '')

call s:match_top('HsTHTop', '^' . s:var_re, 'skipwhite', '', '@HsType')

" concealed characters

call s:match('HsLambda', '\v%(' . s:op_char . ')@<!\\%(' . s:op_char . ')@!', ' conceal cchar=λ' . s:exclude_strings, '', '')

call s:keyword('HsForall', ['forall'], 'conceal cchar=∀' . s:exclude_strings)

call s:keyword('HsBottom', ['undefined'], 'conceal cchar=⟂' . s:exclude_strings)
highlight def link HsBottom Macro

" comments

call s:match_top('HsComment', s:comment_re, s:exclude_strings, 'HsTODO,@Spell', '')
highlight def link HsComment Comment

call s:region_top('HsBlockComment', '', '{-', '', '-}', 'keepend extend', 'HsBlockComment,HsTodo,@Spell', '')
highlight def link HsBlockComment Comment

call s:region_top('HsPragma', '', '{-#', '', '#-}', 'keepend' . s:exclude_strings, '', '')
highlight def link HsPragma SpecialComment

call s:region_top('HsLiquid', '', '{-@', '', '@-}', 'keepend' . s:exclude_strings, '', '')
highlight def link HsLiquid HsPragma

" literals

function! s:lit(name, pattern) abort "{{{
  call s:match(a:name, a:pattern, s:exclude_strings, '', '')
endfunction "}}}

call s:lit('HsNumber', '\v<[0-9]+>|<0[xX][0-9a-fA-F]+>|<0[oO][0-7]+>|<0[bB][10]+>')
highlight def link HsNumber Number

call s:lit('HsFloat', '\v<\d+\.\d+([eE][-+]=[0-9]+)=>')
highlight def link HsFloat HsNumber

call s:region_top('HsString', '', '"', '', '"', 'skip=/\v\\\\|\\"/ contains=@Spell ' . s:exclude_strings, '', '')
highlight def link HsString String

" expressions

call s:Name( 'HsExpCtor', 'HsQualifiedCtor', '')
call s:parens('HsExpParens', 'HsDiscreetBrackets', '@HsExp,@HsKeyword', '')
call s:brackets('HsExpBrackets', 'HsStrongBrackets', '@HsExp,@HsKeyword', '')
call s:match('HsExpSymVar', s:sym_var_re, '', 'HsStrongBrackets,HsOperator', '')
call s:syn('match HsExpVar ' . s:q(s:wli . '@!' . s:var_re) . s:opts, '', 'HsInlineSig')
call s:match('HsExpTypeApp', '\v\@\ze\k', 'keepend', '', 'HsQualifiedType')
call s:region('HsExpTypeAppBrackets', '', '\v( )@<=\@''?\[', '', ']', 'keepend', 'HsDiscreetBrackets,@HsType', '')
call s:region('HsExpTypeAppParens', '', '\v( )@<=\@''?\(', '', ')', 'keepend', 'HsDiscreetBrackets,@HsType', '')

syntax cluster HsExp
  \ contains=HsExpVar,HsExpCtor,HsExpParens,HsExpBrackets,HsExpTypeApp,HsExpTypeAppParens,HsExpTypeAppBrackets,HsExpSymVar

" type signature

call s:match('HsInlineSig', '::', '', '', '@HsType')
highlight def link HsInlineSig HsOperator

" TODO
call s:match('HsTypeLiteral', '\v\d+', '', 'HsNumber', '@HsType')
call s:parens('HsTypeParens', 'HsDiscreetBrackets', '@HsType,HsComment', '@HsType')
call s:brackets('HsTypeBrackets', 'HsStrongBrackets', '@HsType,HsComment', '@HsType')
call s:Name('HsTypeType', 'HsQualifiedType', '@HsType')
call s:name('HsTypeTypeParam', '', '@HsType')
call s:match('HsTypeOperator', s:operator, '', 'HsOperator', '@HsType')
call s:match('HsTypeKind', s:no_op_around('\*'), '', '', '@HsType')
call s:match('HsTypeKind', '\v<Type>', '', '', '@HsType')
call s:match('HsTypeComment', '\v%(^(\s*).*)@<=' . s:comment_re . '\n\1\s+', '', 'HsComment', '@HsType')
call s:match('HsTypeForall', '\v%(<forall>|∀)[^.]+%(\n\s+)?\.', '', '', '@HsType')

highlight def link HsKind HsTycon
highlight def link HsTypeKind HsKind
highlight def link HsTypeQuote HsTycon

syntax cluster HsType
  \ contains=HsTypeParens,HsTypeBrackets,HsTypeType,HsTypeTypeParam,HsTypeOperator,HsTypeKind,HsTypeComment,HsTypeForall

" module

call s:match_top('HsModule', '\v\s*\zsmodule>', 'skipwhite skipnl', '@HsKeyword', 'HsModuleId')

call s:match(
  \ 'HsModuleId',
  \ s:conid_re . '\v(\.' . s:conid_re . ')*',
  \ '',
  \ 'HsModId,HsModuleDot',
  \ 'HsExports,HsKeywordLetWhere',
  \ )

call s:parens('HsExports', 'HsStrongBrackets', 'HsTycon', 'HsKeywordLetWhere')

" imports

syntax match HsImport '\v^\s*import>' skipwhite skipnl
  \ contains=HsImportKeyword
  \ nextgroup=HsImportModule,HsImportPreQualifier,HsImportPackage

syntax match HsImportModule '\v\u\k*(\.\u\k*)*' contained skipwhite skipnl
  \ contains=HsModId,HsModuleDot
  \ nextgroup=HsImportAs,HsImportHiding,HsImportList

syntax match HsImportPreQualifier '\v[a-z]+' contained skipwhite skipnl
  \ contains=HsImportQualifier
  \ nextgroup=HsImportModule,HsImportQualifier,HsImportPackage

syntax match HsImportPackage '\v"[^"]+"' contained skipwhite skipnl
  \ contains=HsString
  \ nextgroup=HsImportModule

syntax match HsModId '\v<\u\k*>' contained
syntax match HsModuleDot '\.' contained

syntax region HsImportList matchgroup=HsImportParens start='(' end=')' contained
  \ contains=HsImportPrefixedItem,HsImportType,HsImportSymbolicType,HsImportFunc

syntax match HsImportAs 'as\>' contained skipwhite skipnl
  \ contains=HsImportQualifier
  \ nextgroup=HsImportAsName

syntax match HsImportAsName '\v\u\k*' contained skipwhite skipnl
  \ contains=HsModId
  \ nextgroup=HsImportList

syntax match HsImportHiding 'hiding\>' contained skipwhite skipnl
  \ contains=HsImportQualifier
  \ nextgroup=HsImportList

syntax match HsImportType '\v\u\k*' contained skipwhite skipnl
  \ nextgroup=HsImportCtors,HsImportComma

call s:parens('HsImportSymbolicType', 'HsDiscreetBrackets', 'HsImportSymbolicTypeName', 'HsImportCtors,HsImportComma')

syntax region HsImportCtors matchgroup=HsImportParens start='(' end=')' contained skipwhite skipnl
  \ contains=HsImportSymbolicCtor,HsImportCtor
  \ nextgroup=HsImportComma

syntax match HsImportSymbolicCtor '\v\((\k@![^)])+\)' contained skipwhite skipnl
  \ contains=HsImportSymbolicCtorName,HsImportParens
  \ nextgroup=HsImportCtorComma

syntax match HsImportCtor '\v\u\k*' contained skipwhite skipnl
  \ nextgroup=HsImportCtorComma

syntax match HsImportCtorComma ',' contained skipwhite skipnl
  \ nextgroup=HsImportSymbolicCtor,HsImportCtor

syntax match HsImportFunc '\v[a-z]\k*' contained skipwhite skipnl
  \ nextgroup=HsImportComma

syntax match HsImportPrefixedItem '\v(type|pattern)>' contained skipwhite skipnl
  \ contains=HsImportItemKeyword
  \ nextgroup=HsImportSymbolicType,HsImportType

syntax match HsImportComma ',' contained skipwhite skipnl
  \ nextgroup=HsImportPrefixedItem,HsImportType,HsImportSymbolicType,HsImportFunc

syntax match HsImportParens '[()]' contained
syntax match HsImportSymbolicTypeName '\v(\k@![^()])+' contained
syntax match HsImportSymbolicCtorName '\v(\k@![^()])+' contained

call s:keyword('HsImportKeyword', ['import'], '')
call s:keyword('HsImportQualifier', ['qualified', 'safe', 'as', 'hiding'], '')
call s:keyword('HsImportItemKeyword', ['type', 'pattern'], '')

highlight def link HsImportKeyword Include
highlight def link HsImportQualifier Keyword
highlight def link HsImportModule Type
highlight def link HsModId Type
highlight def link HsImportCtor HsConId
highlight def link HsImportType HsTycon
highlight def link HsImportItemKeyword Keyword
highlight def link HsImportSymbolicTypeName HsTycon
highlight def link HsImportSymbolicCtorName HsConId
highlight def link HsImportParens HsStrongBrackets

" function equation

call s:match_top('HsFun', '\v\ze.*(\{[^}]*)@<!\=\_s', '', '', 'HsFunSymPat,HsFunName')

call s:symOrName('HsFunName', '', 'HsFunArgs')

call s:match('HsFunSymPat', '\v.*\s+' . s:operator . '\s+.*\ze\=', '', '@HsExp,HsFunNameSym', 'HsFunBody')

call s:match('HsFunNameSym', s:operator, '', '', '')

call s:match('HsFunArgs', '\v.*(\{[^}]*)@<!\ze\=\_s', '', '@HsExp', 'HsFunBody')

call s:indent_region('HsFunBody', '', '\S.*', '\v\=', '', 'HsStmt,HsKeywordBasic,@HsExp,HsLetWhere', '')

call s:match('HsStmt', '\v\s*\zs.{-1,}\s+\ze\<-\_s', '', '@HsExp', 'HsStmtArrow')

call s:indent_region('HsStmtArrow', 'HsOperator', '\S.*', '\<-\s*\_s\s*', '', '@HsExp', '')

call s:indent_region('HsLetWhere', 'HsKeywordLetWhere', '', '<(where|let)>', '', 'HsDecl,HsFun,HsComment', '')

highlight def link HsFunName HsIdentifier
highlight def link HsFunNameSym HsIdentifier

" function declaration

call s:match_top(
  \ 'HsDecl',
  \ '\v(default\s*)?' . s:sym_or_var_re . '(,\s*' . s:sym_or_var_re . ')*\ze\s*\_s\s*::\_s',
  \ 'skipwhite skipnl',
  \ 'HsDeclName,HsSeparator',
  \ 'HsDeclBody1,HsDeclBody2',
  \ )

call s:indent_region(
  \ 'HsDeclBody1',
  \ 'HsSig',
  \ '.*',
  \ '::\s*',
  \ '',
  \ '@HsType,HsOperator,HsComment,HsContext',
  \ 'HsFun',
  \ )

call s:indent_region_eq(
  \ 'HsDeclBody2',
  \ 'HsSig',
  \ '\s+',
  \ '::',
  \ '',
  \ '@HsType,HsOperator,HsComment,HsContext',
  \ 'HsFun',
  \ )

call s:symOrNameWith('HsDeclName', 'contained', '', '')

call s:match('HsSig', '::', '', '', '')

highlight def link HsSig HsOperator
highlight def link HsDeclName HsIdentifier

" data

call s:top_decl(
  \ 'Data',
  \ '\v(data%( family)?|newtype)',
  \ 'HsDataContext,HsDataSimpletype,HsInlineSig,HsComment',
  \ 'HsGadtBody',
  \ 'HsDataBody',
  \ )

call s:match('HsDataSimpletype', '\v\u.{-}(\=|$)', '', 'HsTycon', '')

call s:match('HsDataContext', '\v\u.{-}\=\>', '', 'HsClassContextClass', 'HsDataSimpletype')

" TODO HsConOp, doesn't work like this since HsCon already parses a Name
call s:Name('HsCon', 'HsConId', 'HsConRecord,HsConAtypes,HsConOp')

call s:match('HsConAtypes', '\v(\s*\{[^-]|deriving)@!\S.{-}\ze($|\|)', 'keepend', '@HsType', 'HsConSum,HsDataDeriving')

call s:braces('HsConRecord', '', 'HsConRecordField,HsComment', 'HsConSum,HsDataDeriving')

call s:region(
  \ 'HsConRecordField',
  \ '',
  \ '[a-z_]',
  \ 'HsSeparator',
  \ '\v%(,\ze\s*' . s:inline_comment . s:var_re . '\_s+::\_s|\ze\s*(-)@<!})',
  \ 'keepend',
  \ 'HsDecl',
  \ 'HsConRecordField'
  \ )

call s:match('HsConSum', '|', '', 'HsOperator', 'HsCon')

call s:indent_region(
  \ 'HsDataBody',
  \ '',
  \ '.*',
  \ '.',
  \ 'keepend skipwhite skipnl',
  \ 'HsCon,HsDataDeriving,HsComment',
  \ '',
  \ )

call s:region(
  \ 'HsGadtType',
  \ '',
  \ '\s',
  \ '',
  \ '\v\ze<where>',
  \ 'containedin=HsTopDeclGadt',
  \ 'HsInlineSig,@HsType',
  \ 'HsGadtBody'
  \ )

call s:indent_region('HsGadtBody', 'HsKeyword', '\S.*', 'where', '', 'HsGadtCon,HsComment', '')

call s:indent_region('HsGadtCon', 'HsConId', '', s:conid_re, '', 'HsGadtSig', '')

call s:match('HsGadtSig', '::', '', 'HsSig', 'HsGadtConRecord,@HsType,HsComment')

call s:braces('HsGadtConRecord', 'extend', 'HsConRecordField,HsComment', '@HsType')

call s:match(
  \ 'HsDataDeriving',
  \ '\v<deriving>(\s+<(anyclass|newtype|stock)>)?\s+',
  \ '',
  \ 'HsDataDerivingKeyword',
  \ 'HsClassName,HsDataDerivingClassParens',
  \ )

call s:parens('HsDataDerivingClassParens', 'HsDiscreetBrackets', 'HsClassName,HsSeparator', '')

syntax keyword HsTopDeclKeyword data newtype type class instance family contained
highlight def link HsTopDeclKeyword HsKeyword

syntax keyword HsDataDerivingKeyword deriving anyclass stock newtype via contained
highlight def link HsDataDerivingKeyword HsKeyword

" type

call s:region_top(
  \ 'HsTopDeclType',
  \ '',
  \ '\v<type>',
  \ '',
  \ '\v\_s\=\_s',
  \ 'keepend skipwhite skipnl',
  \ '@HsType,HsOperator,HsTopDeclKeyword',
  \ '@HsType',
  \ )

" TODO make this an indent region for both closed and open families, then decide based on the presence of `where` which
" one to parse
call s:region_top(
  \ 'HsTopDeclClosedTypeFamily',
  \ 'HsTopDeclKeyword',
  \ '\v<type family>',
  \ '',
  \ '\v\ze<where>',
  \ 'keepend',
  \ '@HsType,HsOperator,HsTopDeclKeyword,HsKeywordLetWhere',
  \ 'HsTypeFamilyBody',
  \ )

call s:indent_region('HsTypeFamilyBody', 'HsKeywordLetWhere', '.*', 'where', '', 'HsTypeFamilyEqn,HsComment', '')

call s:match('HsTypeFamilyEqn', s:with_comment('\v.*\_s\=\_s'), 'skipwhite skipnl', '@HsType,HsComment', '@HsType')

call s:match_top(
  \ 'HsTopDeclOpenTypeFamily',
  \ '\v^\s*type family.*(<where>)@<!$',
  \ 'skipwhite skipnl',
  \ '@HsType,HsOperator,HsTopDeclKeyword',
  \ '',
  \ )

" class

call s:Name('HsClassContextClass', 'HsClassName', '@HsType')

call s:match('HsClassContext', '\v((<where>)@!\_.)+\=\>', '', 'HsClassContextClass,HsOperator,HsStrongBrackets,HsComment', 'HsClassHead')

call s:Name('HsClassHead', 'HsClassName', '@HsType')

call s:top_decl(
  \ 'Class',
  \ '\v(class|%(<deriving>%(\s+<%(anyclass|newtype|stock)>)?\s+)?instance)',
  \ 'HsClassContext,HsClassHead,HsComment',
  \ 'HsClassBody',
  \ '',
  \ )

call s:match('HsClassAssocType', '\v^\s+type\s+\ze.*::.*', '', '@HsKeyword', 'HsClassAssocTypeLhs')

call s:match('HsClassAssocTypeLhs', '\S.*\s*::', '', '@HsType', '@HsType')

syntax cluster HsClassContent contains=HsClassAssocType,HsTopDeclType,HsDecl,HsFun

call s:indent_region('HsClassBody', 'HsKeywordLetWhere', '.*', 'where', '', '@HsClassContent,HsComment', '')

" TH

call s:region_top('HsQQ', '', '\v\[\K\k*\|', '', '\v\|\]', 'containedin=ALL', 'HsQQInterpolate', '')
highligh def link HsQQ HsString

call s:region('HsQQInterpolate', 'Delimiter', '\v#\{', 'Delimiter', '\}', '', '@HsExp,HsInlineSig', '')

syntax region HsTHBlock matchgroup=HsTH start="\[\(d\|t\|p\)\?|" end="|]" contains=TOP
syntax region HsTHDoubleBlock matchgroup=HsTH start="\[||" end="||]" contains=TOP

" comment line override

call s:match_top('HsCommentLine', '^' . s:comment_re, '', 'HsComment', '')

" misc

syntax keyword HsForeignKeywords foreign export import ccall safe unsafe interruptible capi prim contained
syntax region HsForeignImport start="\<foreign\>" end="\_s\+::\s" keepend
  \ contains=
  \ HsString,
  \ HsOperator,
  \ HsForeignKeywords,
  \ HsIdentifier
if get(g:, 'haskell_enable_static_pointers', 0)
  syntax keyword HsStatic static
endif
syntax match HsSeparator  '[,;]'
syntax match HsQuote "\<'\+" contained
syntax match HsBacktick "`[A-Za-z_][A-Za-z0-9_\.']*#\?`"
" syntax match HsIdentifier "[_a-z][a-zA-z0-9_']*" contained
syntax match HsChar "\<'[^'\\]'\|'\\.'\|'\\u[0-9a-fA-F]\{4}'\>"
syntax match HsPreProc "^#.*$" keepend
syntax keyword HsTodo TODO FIXME contained
" Treat a shebang line at the start of the file as a comment
syntax match HsShebang "\%^#!.*$"
if get(g:, 'haskell_enable_typeroles', 0)
  syntax keyword HsTypeRoles phantom representational nominal contained
  syntax region HsTypeRoleBlock matchgroup=HsTypeRoles start="type\s\+role" end="$" keepend
    \ contains=
    \ HsTycon,
    \ HsTypeRoles
endif
if get(g:, 'haskell_enable_arrowsyntax', 0)
  syntax keyword HsArrowSyntax proc
endif

highlight def link HsTH HsString
highlight def link HsIdentifier Identifier
highlight def link HsForeignKeywords Structure
highlight def link HsDefault Keyword
highlight def link HsSeparator Delimiter
highlight def link HsQuote Operator
highlight def link HsShebang Comment
highlight def link HsLineComment Comment
highlight def link HsChar HsString
highlight def link HsBacktick Operator
highlight def link HsTodo Todo
highlight def link HsPreProc PreProc
highlight def link HsTypeRoles Structure

if get(g:, 'haskell_enable_arrowsyntax', 0)
  highlight def link HsArrowSyntax Keyword
endif
if get(g:, 'haskell_enable_static_pointers', 0)
  highlight def link HsStatic Keyword
endif

if get(g:, 'haskell_backpack', 0)
  highlight def link HsBackpackStructure Structure
  highlight def link HsBackpackDependency Include
endif
let b:current_syntax = "haskell"
