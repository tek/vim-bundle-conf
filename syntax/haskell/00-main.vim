if exists("b:current_syntax")
  finish
endif

function! s:q(a) abort "{{{
  return " /" . a:a . "/ "
endfunction "}}}

function! s:qv(key, value) abort "{{{
  return ' ' . a:key . "=/" . a:value . "/ "
endfunction "}}}

let s:keyword_re = '\v<(where|let|in|deriving|via|import|module|class|type|data|family|instance|case|of|foreign|default)>'
let s:no_keyword = '\v(' . s:keyword_re . ')@!'
let s:opts = ' contained skipwhite skipnl '
let s:var_re = s:no_keyword . '\v<[a-z_]\k*#?>'
let s:var_re_q = s:q(s:var_re)
let s:conid_re = '\v<''?''?\u\k*>'
let s:conid_re_q = s:q(s:conid_re)
let s:wli = '\v(<(where|let|in)>\s+)'
let s:comment_re = '\v\s*--+(\k|\s).*$'
let s:till_comment = '.*\ze' . s:comment_re
let s:op_char = '[-!#$%&*+/<=>?@\\^|~:.]'
let s:operator = '\v(--|::|<-)@!' . s:op_char . '+'

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

function! s:indent_region_top(name, matchgroup, pre, start, extra, contains, nextgroup) abort "{{{
  return s:region_top(
        \ a:name,
        \ a:matchgroup,
        \ '\v(^\z(\s*)' . a:pre . ')@<=' . a:start,
        \ '',
        \ '\v\ze^\s*(^\z1\s+)@<!\S',
        \ a:extra,
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

function! s:brak_top(name, l, r, extra, contains, nextgroup) abort "{{{
  return s:region_top(
        \ a:name,
        \ 'HsBrackets',
        \ a:l,
        \ '',
        \ a:r,
        \ a:extra,
        \ a:contains,
        \ a:nextgroup,
        \ )
endfunction "}}}

function! s:parens_top(name, extra, contains, nextgroup) abort "{{{
  return s:brak_top(a:name, '(', ')', a:extra, a:contains, a:nextgroup)
endfunction "}}}

function! s:parens(name, contains, nextgroup) abort "{{{
  return s:parens_top(a:name, s:opts, a:contains, a:nextgroup)
endfunction "}}}

function! s:braces_top(name, extra, contains, nextgroup) abort "{{{
  return s:brak_top(a:name, '{', '}', a:extra, a:contains, a:nextgroup)
endfunction "}}}

function! s:braces(name, contains, nextgroup) abort "{{{
  return s:braces_top(a:name, s:opts, a:contains, a:nextgroup)
endfunction "}}}

function! s:brackets_top(name, extra, contains, nextgroup) abort "{{{
  return s:brak_top(a:name, '\[', '\]', a:extra, a:contains, a:nextgroup)
endfunction "}}}

function! s:brackets(name, contains, nextgroup) abort "{{{
  return s:brackets_top(a:name, s:opts, a:contains, a:nextgroup)
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
  return s:syn('match ' . a:name . s:var_re_q . a:extra, a:contains, a:nextgroup)
endfunction "}}}

function! s:name(name, contains, nextgroup) abort "{{{
  return s:nameWith(a:name, s:opts, a:contains, a:nextgroup)
endfunction "}}}

syntax spell notoplevel
syntax sync fromstart

" fallbacks and generics

call s:match('HsComment', s:comment_re, '', '', '')
highlight def link HsComment Comment

call s:Name('HsTycon', '', '')
highlight def link HsTycon Type

call s:Name('HsFunParamType', '', '')
highlight! link HsFunParamType HsTycon

syntax match HsConId '\<\u\k*\>' contained
highlight def link HsConId Type

syntax match HsBrackets '[({})]' contained

syntax match HsQualifyingModule '\v<\u\k*\ze\.' contained contains=HsModId,HsModuleDot
highlight def link HsQualifyingModule Type

syntax match HsQualifiedCtor '\v(\u\k*\.)*\u\k*' contained contains=HsQualifyingModule,HsConId

syntax match HsQualifiedType '\v(\u\k*\.)*\u\k*' contained contains=HsQualifyingModule,HsTycon

syntax match HsQualifiedVar '\v(\u\k*\.)+[a-z_]\k*' contains=HsQualifyingModule,HsVar

call s:match('HsOperator', s:operator, '', '', '')
highlight def link HsOperator Operator

syntax keyword HsKeywordBasic
      \ case class data default deriving do else if import in infix infixl infixr
      \ instance module newtype of then type family role mdo rec qualified pattern
      \ contained
highlight def link HsKeywordBasic HsKeyword

syntax keyword HsKeywordLetWhere where let contained
highlight def link HsKeywordLetWhere HsKeyword

syntax cluster HsKeyword contains=HsKeywordBasic,HsKeywordLetWhere
highlight def link HsKeyword Keyword

" literals

syntax match HsNumber "\<[0-9]\+\>\|\<0[xX][0-9a-fA-F]\+\>\|\<0[oO][0-7]\+\>\|\<0[bB][10]\+\>" containedin=ALL
highlight def link HsNumber Number

syntax match HsFloat "\<[0-9]\+\.[0-9]\+\([eE][-+]\=[0-9]\+\)\=\>" containedin=ALL
highlight def link HsFloat Float

syntax region HsString start='"' skip='\v\\\\|\\"' end='"' containedin=ALLBUT,HsString
  \ contains=@Spell
highlight def link HsString String

call s:Name('HsClassName', '', '')

" expressions

call s:parens(
      \ 'HsExpParens',
      \ 'HsExpParens,HsExpCtor,HsExpVar',
      \ '',
      \ )

call s:Name(
      \ 'HsExpCtor',
      \ 'HsQualifiedCtor',
      \ '',
      \ )

call s:syn(
      \ 'match HsExpVar ' . s:q(s:wli . '@!' . s:var_re) . s:opts,
      \ '',
      \ 'HsInlineSig',
      \ )

syntax cluster HsExp contains=HsExpVar,HsExpCtor,HsExpParens,HsComment

highlight def link HsKind HsTycon

" inline signature

call s:match('HsInlineSig', '::', '', '', '@HsType')
highlight def link HsInlineSig Operator

" TODO
call s:match('HsTypeLiteral', '\v\d+', '', 'HsNumber', '@HsClassArg')
call s:parens('HsTypeParens', '@HsType,HsComment', '@HsType')
call s:brackets('HsTypeBrackets', '@HsType,HsComment', '@HsType')
call s:Name('HsTypeType', 'HsQualifiedType', '@HsType')
call s:name('HsTypeTypeParam', '', '@HsType')
call s:match('HsTypeOperator', s:operator, '', 'HsOperator', '@HsType')
call s:match('HsTypeKind', s:no_op_around('\*'), '', '', '')

highlight def link HsTypeKind HsKind

syntax cluster HsType
      \ contains=HsTypeParens,HsTypeBrackets,HsTypeType,HsTypeTypeParam,HsTypeOperator,HsTypeKind

" module

call s:match_top('HsModule', '\v\s*\zsmodule>', 'skipwhite skipnl', '@HsKeyword', 'HsModuleId')

call s:match(
      \ 'HsModuleId',
      \ s:conid_re . '\v(\.' . s:conid_re . ')*',
      \ '',
      \ 'HsModId,HsModuleDot',
      \ 'HsExports,HsKeywordLetWhere',
      \ )

call s:parens('HsExports', 'HsTycon', 'HsKeywordLetWhere')

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

syntax match HsImportSymbolicType '\v\((\k@![^)])+\)' contained skipwhite skipnl
      \ contains=HsImportSymbolicTypeName,HsImportParens
      \ nextgroup=HsImportCtors,HsImportComma

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
syntax match HsImportSymbolicTypeName '[^\k()]' contained
syntax match HsImportSymbolicCtorName '[^\k()]' contained

syntax keyword HsImportKeyword import contained
syntax keyword HsImportQualifier qualified safe as hiding contained
syntax keyword HsImportItemKeyword type pattern contained

highlight def link HsImportKeyword Include
highlight def link HsImportQualifier Keyword
highlight def link HsImportModule Type
highlight def link HsModId Type
highlight def link HsImportCtor HsConId
highlight def link HsImportType HsTycon
highlight def link HsImportItemKeyword Keyword
highlight def link HsImportSymbolicTypeName HsTycon
highlight def link HsImportSymbolicCtorName HsConId
highlight def link HsImportParens HsBrackets

" function equation

call s:match_top('HsFun', '\v\ze.*(\{[^}]*)@<!\=\_s', '', '', 'HsFunName')

call s:name('HsFunName', '', 'HsFunArgs')

call s:match('HsFunArgs', '\v.*(\{[^}]*)@<!\ze\=\_s', '', '@HsExp', 'HsFunBody')

call s:indent_region('HsFunBody', '', '\S.*', '\=', '', 'HsStmt,HsKeywordBasic,@HsExp,HsLetWhere', '')

call s:match('HsStmt', '\v\s*\zs.{-1,}\s+\ze\<-\_s', '', '@HsExp', 'HsStmtArrow')

call s:indent_region('HsStmtArrow', 'HsOperator', '\S.*', '\<-\s*\_s\s*', '', '@HsExp', '')

call s:indent_region('HsLetWhere', 'HsKeywordLetWhere', '', '<(where|let)>', '', 'HsDecl,HsFun,HsComment', '')

highlight def link HsFunName HsIdentifier

" function declaration

call s:match_top(
      \ 'HsDecl',
      \ '\v(default\s*)?' . s:var_re . '(,\s*' . s:var_re . ')*\ze\s*\_s\s*::\_s',
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
      \ 'HsTycon,HsOperator,HsComment',
      \ 'HsFun',
      \ )

call s:indent_region_eq(
      \ 'HsDeclBody2',
      \ 'HsSig',
      \ '\s+',
      \ '::',
      \ '',
      \ 'HsTycon,HsOperator,HsComment',
      \ 'HsFun',
      \ )

call s:nameWith('HsDeclName', 'contained', '', '')

highlight def link HsSig Operator
highlight def link HsDeclName HsIdentifier
highlight def link HsForall Keyword

" syntax match HsDecl '\v\s*(default\s*)?\ze[_a-z]\k*#?(,\s*[_a-z]\k*#?)*\_s*::\_s'
"       \ contains=@HsKeyword
"       \ nextgroup=HsDeclName

" syntax match HsDeclName '\v\S+#?' contained skipwhite skipnl
"       \ nextgroup=HsDeclComma,HsSig

" syntax match HsSig '::' contained skipwhite skipnl
"       \ nextgroup=@HsSigRhs

" syntax cluster HsSigRhs contains=HsSigForall,HsSigContexts,HsSigContext,HsSigParam,@HsSigResultType

" " TODO doesn't work
" call s:match('HsSigResultTypeEnd', '\v($|,)', '', '', 'HsFun')
" call s:NameWith('HsSigResultTypeAtype', 'contained skipwhite', 'HsTycon', '@HsSigResultType')
" call s:nameWith('HsSigResultTypeTyvar', 'contained skipwhite', 'HsTypeParam', '@HsSigResultType')
" call s:parens_top('HsSigResultTypeParens', 'contained skipwhite extend keepend', '@HsSigResultType', '@HsSigResultType')
" call s:brackets_top('HsSigResultTypeBrackets', 'contained skipwhite extend keepend', '@HsSigResultType', '@HsSigResultType')

" syntax cluster HsSigResultType
"       \ contains=HsSigResultTypeTyvar,HsSigResultTypeAtype,HsSigResultTypeParens,HsSigResultTypeBrackets,HsSigResultTypeEnd

" call s:Name('HsSigContextClass', 'HsClassName', 'HsSigContextRest')

" let s:constraint_rest = '\v((::|\_s\=\_s)@!.){-}(\n\s*)?(\([^)]*)@<!\=\>'

" call s:match(
"       \ 'HsSigContextRest',
"       \ s:constraint_rest,
"       \ '',
"       \ 'HsTypeArg,HsOperator',
"       \ 'HsSigContext,HsSigParam,@HsSigResultType',
"       \ )

" syntax match HsTypeArg '\ze\S' contained
"       \ nextgroup=HsTycon,HsParensSig,HsBracketsSig

" call s:parens('HsParensSig', 'HsTycon,HsForall,HsOperator', '')
" call s:brackets('HsBracketsSig', 'HsTycon,HsForall,HsOperator', '')

" syntax match HsSigParam '\v\S((::|\_s\=\_s)@!.){-}(\n\s*)?-\>' contained skipwhite skipnl
"       \ contains=HsFunParamType,HsOperator
"       \ nextgroup=HsSigContext,HsSigParam,@HsSigResultType

" call s:match('HsSigContext', '\v\ze\S' . s:constraint_rest, '', '', 'HsSigContextClass')

" syntax match HsSigForall '\v(∀|forall)\s+.{-}(\n\s*)?\.' contained skipwhite skipnl
"       \ contains=HsForall,HsOperator,HsTycon
"       \ nextgroup=HsSigContexts,HsSigContext,HsSigParam,@HsSigResultType

" syntax match HsDeclComma ',' contained skipwhite skipnl
"       \ nextgroup=HsDeclName

" syntax match HsForall '\v(∀|forall)' contained

" highlight def link HsSigContextClass HsTycon
" highlight def link HsSigContextArg HsTycon
" highlight def link HsSig HsOperator
" highlight def link HsDeclName HsIdentifier
" highlight def link HsForall Keyword

" " data

call s:match('HsDataSimpletype', '\v\u.{-}(\=|$)', '', 'HsTycon', 'HsDataBody')

call s:match('HsDataContext', '\v\u.{-}\=\>', '', 'HsClassContextClass', 'HsDataSimpletype')

call s:indent_region_top(
      \ 'HsTopDeclData',
      \ 'HsTopDeclKeyword',
      \ '',
      \ '\v^data>',
      \ 'keepend skipwhite skipnl',
      \ 'HsDataContext,HsDataSimpletype,HsComment',
      \ '',
      \ )

call s:Name('HsCon', 'HsConId', 'HsConRecord,HsConAtypes,HsConOp')

call s:braces('HsConRecord', 'HsConRecordField,HsComment', 'HsConSum,HsDataDeriving')

call s:region(
      \ 'HsConRecordField',
      \ '',
      \ '[a-z_]',
      \ 'HsDelimiter',
      \ '\v(,|\ze\s*})',
      \ 'keepend',
      \ 'HsDecl',
      \ 'HsConRecordField'
      \ )

call s:match('HsConAtypes', '\v\u.{-}\ze($|\|)', 'keepend', 'HsTycon', 'HsConSum,HsDataDeriving')

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

call s:match_top(
      \ 'HsTopDeclGadt',
      \ '\v^\s*data>.*\ze<where>',
      \ '',
      \ 'HsSig,@HsSigRhs,HsOperator,HsTopDeclKeyword',
      \ 'HsGadtConBody',
      \ )

call s:indent_region('HsGadtConBody', 'HsKeyword', '.*', 'where', '', 'HsGadtCon,HsDataDeriving', '')

call s:Name('HsGadtCon', 'HsConId', 'HsSig')

call s:match(
      \ 'HsDataDeriving',
      \ '\v<deriving>(\s+<(anyclass|newtype|stock|via)>)?\s+',
      \ '',
      \ 'HsDataDerivingKeyword',
      \ 'HsClassName,HsDataDerivingClassParens',
      \ )

call s:parens('HsDataDerivingClassParens', 'HsClassName,HsDelimiter', '')

syntax keyword HsTopDeclKeyword data type class instance family contained
highlight def link HsTopDeclKeyword HsKeyword

syntax keyword HsDataDerivingKeyword deriving anyclass stock newtype via contained
highlight def link HsDataDerivingKeyword HsKeyword

" " type

call s:region_top(
      \ 'HsTopDeclType',
      \ '',
      \ '\v<type>',
      \ '',
      \ '\_s=\_s',
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

call s:match('HsTypeFamilyEqn', s:with_comment('.*\_s=\_s'), 'skipwhite skipnl', '@HsType,HsComment', '@HsType')

call s:match_top(
      \ 'HsTopDeclOpenTypeFamily',
      \ '\v^\s*type family.*(<where>)@<!$',
      \ 'skipwhite skipnl',
      \ '@HsType,HsOperator,HsTopDeclKeyword',
      \ '',
      \ )

" class

call s:Name('HsClassContextClass', 'HsClassName', '@HsType')

call s:match('HsClassContext', '\v((<where>)@!\_.)+\=\>', '', 'HsClassContextClass', 'HsClassHead')

call s:Name('HsClassHead', 'HsClassName', '@HsType')

call s:region_top(
      \ 'HsTopDeclClass',
      \ 'HsTopDeclKeyword',
      \ '\v^\s*(class|instance)>',
      \ '',
      \ '\v\ze<where>',
      \ 'keepend',
      \ 'HsClassContext,HsClassHead,HsComment',
      \ 'HsClassBody',
      \ )

call s:match('HsClassAssocType', '\v^\s+type\s+\ze.*::.*', '', '@HsKeyword', 'HsClassAssocTypeLhs')

call s:match('HsClassAssocTypeLhs', '\S.*\s*::', '', '@HsType', '@HsType')

syntax cluster HsClassContent contains=HsClassAssocType,HsTopDeclType,HsDecl,HsFun

call s:indent_region('HsClassBody', 'HsKeywordLetWhere', '.*', 'where', '', '@HsClassContent,HsComment', '')

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
syntax keyword HsConditional if then else
syntax match HsSeparator  '[,;]'
syntax keyword HsInfix infix infixl infixr
syntax keyword HsBottom undefined containedin=ALL
syntax match HsQuote "\<'\+" contained
syntax match HsLineComment "---*\([^-!#$%&\*\+./<=>\?@\\^|~].*\)\?$"
  \ contains=
  \ HsTodo,
  \ @Spell
syntax match HsBacktick "`[A-Za-z_][A-Za-z0-9_\.']*#\?`"
" syntax match HsIdentifier "[_a-z][a-zA-z0-9_']*" contained
syntax match HsChar "\<'[^'\\]'\|'\\.'\|'\\u[0-9a-fA-F]\{4}'\>"
syntax region HsBlockComment start="{-" end="-}"
  \ contains=
  \ HsBlockComment,
  \ HsTodo,
  \ @Spell
syntax region HsPragma start="{-#" end="#-}" keepend
syntax region HsLiquid start="{-@" end="@-}" keepend
syntax match HsPreProc "^#.*$" keepend
syntax keyword HsTodo TODO FIXME contained
" Treat a shebang line at the start of the file as a comment
syntax match HsShebang "\%^#!.*$"
if !get(g:, 'haskell_disable_TH', 0)
    syntax match HsQuasiQuoted "." containedin=HsQuasiQuote contained
    syntax region HsQuasiQuote matchgroup=HsTH start="\[[_a-zA-Z][a-zA-z0-9._']*|" end="|\]"
    syntax region HsTHBlock matchgroup=HsTH start="\[\(d\|t\|p\)\?|" end="|]" contains=TOP
    syntax region HsTHDoubleBlock matchgroup=HsTH start="\[||" end="||]" contains=TOP
endif
if get(g:, 'haskell_enable_typeroles', 0)
  syntax keyword HsTypeRoles phantom representational nominal contained
  syntax region HsTypeRoleBlock matchgroup=HsTypeRoles start="type\s\+role" end="$" keepend
    \ contains=
    \ HsTycon,
    \ HsTypeRoles
endif
if get(g:, 'haskell_enable_recursivedo', 0)
  syntax keyword HsRecursiveDo mdo rec
endif
if get(g:, 'haskell_enable_arrowsyntax', 0)
  syntax keyword HsArrowSyntax proc
endif
if get(g:, 'haskell_enable_pattern_synonyms', 0)
  syntax keyword HsPatternKeyword pattern
endif

highlight def link HsBottom Macro
highlight def link HsTH Boolean
highlight def link HsIdentifier Identifier
highlight def link HsForeignKeywords Structure
highlight def link HsDefault Keyword
highlight def link HsConditional Conditional
highlight def link HsSeparator Delimiter
highlight def link HsDelimiter Delimiter
highlight def link HsInfix Keyword
highlight def link HsQuote Operator
highlight def link HsShebang Comment
highlight def link HsLineComment Comment
highlight def link HsBlockComment Comment
highlight def link HsPragma SpecialComment
highlight def link HsLiquid SpecialComment
highlight def link HsChar String
highlight def link HsBacktick Operator
highlight def link HsQuasiQuoted String
highlight def link HsTodo Todo
highlight def link HsPreProc PreProc
highlight def link HsAssocType Type
highlight def link HsQuotedType Type
highlight def link HsDeclKeyword Structure
highlight def link HsWhere Structure
highlight def link HsLet Structure
highlight def link HsRecursiveDo Keyword
highlight def link HsPatternKeyword Structure
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
