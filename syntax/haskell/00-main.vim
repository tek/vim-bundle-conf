if exists("b:current_syntax")
  finish
endif

if get(g:, 'haskell_backpack', 0)
  syntax keyword HsBackpackStructure unit signature
  syntax keyword HsBackpackDependency dependency
endif

function! s:q(a) abort "{{{
  return " '" . a:a . "' "
endfunction "}}}

function! s:qv(key, value) abort "{{{
  return ' ' . a:key . "='" . a:value . "' "
endfunction "}}}

let s:opts = ' contained skipwhite skipnl '
let s:var_re = '\v[a-z_]\k*'
let s:var_re_q = s:q(s:var_re)
let s:conid_re = '\v[A-Z]\k*'
let s:conid_re_q = s:q(s:conid_re)
let s:wli = '\v(<(where|let|in)>\s+)'

function! s:optional(name, value) abort "{{{
  return empty(a:value) ? '' : ' ' . a:name . '=' . a:value . ' '
endfunction "}}}

function! s:syn(main, contains, nextgroup) abort "{{{
  echom 'syntax ' . a:main .
        \ (empty(a:contains) ? '' : ' contains=' . a:contains) .
        \ (empty(a:nextgroup) ? '' : ' nextgroup=' . a:nextgroup)
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

function! s:region(name, mg_start, start, mg_end, end, extra, contains, nextgroup) abort "{{{
  return s:syn(
        \ 'region ' . a:name . s:optional('matchgroup', a:mg_start) . s:qv('start', a:start) .
        \   s:optional('matchgroup', a:mg_end) . s:qv('end', a:end) . a:extra,
        \ a:contains,
        \ a:nextgroup,
        \ )
endfunction "}}}

function! s:region_top(name, pre, start, end, extra, contains, nextgroup) abort "{{{
  return s:syn(
        \ 'region ' . a:name . ' ' . a:pre . ' start=' . s:q(a:start) . ' end=' . s:q(a:end) . a:extra,
        \ a:contains,
        \ a:nextgroup,
        \ )
endfunction "}}}

function! s:indent_region(name, matchgroup, pre, start, extra, contains, nextgroup) abort "{{{
  return s:region(
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

function! s:parens_top(name, extra, contains, nextgroup) abort "{{{
  return s:region_top(
        \ a:name,
        \ 'matchgroup=HsParens',
        \ '(',
        \ ')',
        \ a:extra,
        \ a:contains,
        \ a:nextgroup,
        \ )
endfunction "}}}

function! s:parens(name, contains, nextgroup) abort "{{{
  return s:parens_top(a:name, s:opts, a:contains, a:nextgroup)
endfunction "}}}

function! s:braces(name, contains, nextgroup) abort "{{{
  return s:region_top(
        \ a:name,
        \ 'matchgroup=HsParens',
        \ '{',
        \ '}',
        \ s:opts,
        \ a:contains,
        \ a:nextgroup,
        \ )
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

syntax match HsType '\<[A-Z]\k*\>' contained
highlight def link HsType Type

call s:Name('HsFunParamType', '', '')
highlight! link HsFunParamType Type

syntax match HsResultType '\<[A-Z]\k*\>' contained
highlight def link HsResultType Type

syntax match HsConId '\<[A-Z]\k*\>' contained
highlight def link HsConId Type

syntax match HsParens '[()]' contained

syntax match HsInlineSig '\v::\s*<.*' contained contains=HsType

syntax match HsQualifyingModule '\v<[A-Z]\k*\ze\.' contained contains=HsModuleName,HsModuleDot
highlight def link HsQualifyingModule Type

syntax match HsQualifiedCtor '\v([A-Z]\k*\.)*[A-Z]\k*' contained contains=HsQualifyingModule,HsConId

syntax match HsQualifiedType '\v([A-Z]\k*\.)*[A-Z]\k*' contained contains=HsQualifyingModule,HsType

syntax match HsQualifiedVar '\v([A-Z]\k*\.)+[a-z_]\k*' contains=HsQualifyingModule,HsVar

syntax match HsOperators "[-!#$%&*+/<=>?@\\^|~:.]\+\|\<_\>" containedin=ALL
highlight def link HsOperators Operator

syntax keyword HsKeyword do case of in default containedin=ALL
highlight def link HsKeyword Keyword

syntax keyword HsLetWhereKeyword where let contained
highlight def link HsLetWhereKeyword Keyword

syntax cluster HsKeywords contains=HsKeyword,HsLetWhereKeyword

syntax match HsNumber "\<[0-9]\+\>\|\<0[xX][0-9a-fA-F]\+\>\|\<0[oO][0-7]\+\>\|\<0[bB][10]\+\>" containedin=ALL
highlight def link HsNumber Number

syntax match HsFloat "\<[0-9]\+\.[0-9]\+\([eE][-+]\=[0-9]\+\)\=\>" containedin=ALL
highlight def link HsFloat Float

syntax region HsString start='"' skip='\v\\\\|\\"' end='"' containedin=ALLBUT,HsString
  \ contains=@Spell
highlight def link HsString String

syntax keyword HsDeclKeyword module class instance newtype in
syntax keyword HsDefault default

call s:Name('HsClassName', '', '')

" expressions

call s:parens_top(
      \ 'HsExpParens',
      \ '',
      \ 'HsExpParens,HsExpCtor,HsExpVar',
      \ '',
      \ )

call s:Name_top(
      \ 'HsExpCtor',
      \ 'HsQualifiedCtor',
      \ '',
      \ )

call s:syn(
      \ 'match HsExpVar ' . s:q(s:wli . '@!' . s:var_re) . s:opts,
      \ '',
      \ 'HsInlineSig',
      \ )

" inline signature

syntax match HsInlineSig '::' contained skipwhite skipnl
      \ contains=HsOperators
      \ nextgroup=HsInlineSigParens,HsInlineSigType

call s:parens(
      \ 'HsInlineSigParens',
      \ 'HsInlineSigParens,HsInlineSigType,HsInlineSigTypeParam',
      \ 'HsInlineSigParens,HsInlineSigType,HsInlineSigTypeParam',
      \ )

call s:Name(
      \ 'HsInlineSigType',
      \ 'HsQualifiedType',
      \ 'HsInlineSigParens,HsInlineSigType,HsInlineSigTypeParam',
      \ )

call s:name(
      \ 'HsInlineSigTypeParam',
      \ '',
      \ 'HsInlineSigParens,HsInlineSigType,HsInlineSigTypeParam',
      \ )

" imports

syntax match HsImport '\v^\s*import>' skipwhite skipnl
      \ contains=HsImportKeyword
      \ nextgroup=HsImportModule,HsImportPreQualifier,HsImportPackage

syntax match HsImportModule '\v[A-Z]\k*(\.[A-Z]\k*)*' contained skipwhite skipnl
      \ contains=HsModuleName,HsModuleDot
      \ nextgroup=HsImportAs,HsImportHiding,HsImportList

syntax match HsImportPreQualifier '\v[a-z]+' contained skipwhite skipnl
      \ contains=HsImportQualifier
      \ nextgroup=HsImportModule,HsImportQualifier,HsImportPackage

syntax match HsImportPackage '\v"[^"]+"' contained skipwhite skipnl
      \ contains=HsString
      \ nextgroup=HsImportModule

syntax match HsModuleName '\v<[A-Z]\k*>' contained
syntax match HsModuleDot '\.' contained

syntax region HsImportList matchgroup=HsImportParens start='(' end=')' contained
      \ contains=HsImportPrefixedItem,HsImportType,HsImportSymbolicType,HsImportFunc

syntax match HsImportAs 'as\>' contained skipwhite skipnl
      \ contains=HsImportQualifier
      \ nextgroup=HsImportAsName

syntax match HsImportAsName '\v[A-Z]\k*' contained skipwhite skipnl
      \ contains=HsModuleName
      \ nextgroup=HsImportList

syntax match HsImportHiding 'hiding\>' contained skipwhite skipnl
      \ contains=HsImportQualifier
      \ nextgroup=HsImportList

syntax match HsImportType '\v[A-Z]\k*' contained skipwhite skipnl
      \ nextgroup=HsImportCtors,HsImportComma

syntax match HsImportSymbolicType '\v\([^\k)]+\)' contained skipwhite skipnl
      \ contains=HsImportSymbolicTypeName,HsImportParens
      \ nextgroup=HsImportCtors,HsImportComma

syntax region HsImportCtors matchgroup=HsImportParens start='(' end=')' contained skipwhite skipnl
      \ contains=HsImportSymbolicCtor,HsImportCtor
      \ nextgroup=HsImportComma

syntax match HsImportSymbolicCtor '\v\([^\k)]+\)' contained skipwhite skipnl
      \ contains=HsImportSymbolicCtorName,HsImportParens
      \ nextgroup=HsImportCtorComma

syntax match HsImportCtor '\v[A-Z]\k*' contained skipwhite skipnl
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
syntax keyword HsImportItemKeyword type pattern

highlight def link HsImportKeyword Include
highlight def link HsImportQualifier Keyword
highlight def link HsImportModule Type
highlight def link HsModuleName Type
highlight def link HsImportCtor HsConId
highlight def link HsImportType Type
highlight def link HsImportItemKeyword Keyword
highlight def link HsImportSymbolicTypeName Type
highlight def link HsImportSymbolicCtorName HsConId
highlight def link HsImportParens HsParens

" function signature

syntax match HsDecl '\v\s*(default\s*)?\zs\ze[_a-z]\k*#?(,\s*[_a-z]\k*#?)*\_s*::\_s'
      \ contains=@HsKeywords
      \ nextgroup=HsDeclName

syntax match HsDeclName '\v\S+#?' contained skipwhite skipnl
      \ nextgroup=HsDeclComma,HsSig

syntax match HsSig '::' contained skipwhite skipnl
      \ nextgroup=HsSigRhs

syntax match HsSigRhs '' contained skipwhite skipnl
      \ nextgroup=HsSigForall,HsSigConstraints,HsSigConstraint,HsSigParam,@HsSigResultType

call s:match('HsSigResultTypeEnd', '\v($|,)', '', '', 'HsFun')

call s:NameWith('HsSigResultTypeAtype', 'contained skipwhite', 'HsType', '@HsSigResultType')
call s:nameWith('HsSigResultTypeTyvar', 'contained skipwhite', 'HsTypeParam', '@HsSigResultType')
call s:parens_top('HsSigResultTypeParens', 'contained skipwhite extend', '@HsSigResultType', '@HsSigResultType')

syntax cluster HsSigResultType contains=HsSigResultTypeTyvar,HsSigResultTypeAtype,HsSigResultTypeParens

call s:Name('HsSigConstraintClass', 'HsClassName', 'HsSigConstraintRest')

let s:constraint_rest = '\v((::)@!..){-}.?(\n\s*)?(\([^)]*)@<!\=\>'

call s:match(
      \ 'HsSigConstraintRest',
      \ s:constraint_rest,
      \ '',
      \ 'HsTypeArg,HsOperators',
      \ 'HsSigConstraint,HsSigParam,@HsSigResultType',
      \ )

syntax match HsTypeArg '\ze\S' contained
      \ nextgroup=HsType,HsParensSig

syntax region HsParensSig matchgroup=HsParens start='(' end=')' contained skipwhite
      \ contains=HsType,HsForall,HsOperators

syntax match HsSigConstraintParam '\v[a-z_]\k*' contained skipwhite skipnl
      \ nextgroup=HsSigConstraintParam,HsSigConstraintArg,HsSigConstraintParen,HsSigConstraintBrack

syntax match HsSigConstraintArg '\v[A-Z]\k*' contained skipwhite skipnl
      \ nextgroup=HsSigConstraintParam,HsSigConstraintArg,HsSigConstraintParen,HsSigConstraintBrack

syntax match HsSigParam '\v\S((::)@!..){-}.?(\n\s*)?-\>' contained skipwhite skipnl
      \ contains=HsFunParamType,HsOperators
      \ nextgroup=HsSigConstraint,HsSigParam,@HsSigResultType

call s:match('HsSigConstraint', '\v\ze\S' . s:constraint_rest, '', '', 'HsSigConstraintClass')

syntax match HsSigForall '\v(∀|forall)\s+.{-}(\n\s*)?\.' contained skipwhite skipnl
      \ contains=HsForall,HsOperators,HsType
      \ nextgroup=HsSigConstraints,HsSigConstraint,HsSigParam,@HsSigResultType

syntax match HsDeclComma ',' contained skipwhite skipnl
      \ nextgroup=HsDeclName

syntax match HsForall '\v(∀|forall)' contained

highlight def link HsSigConstraintClass HsType
highlight def link HsSigConstraintArg HsType
highlight def link HsSig HsOperators
highlight def link HsDeclName HsIdentifier
highlight def link HsForall Keyword

" function equation

syntax match HsFun '\v\s*(default\s*)?\ze.*(\{[^}]*)@<!\=\_s'
      \ contains=HsKeyword
      \ nextgroup=HsFunName

syntax match HsFunName '\v\S+#?' contained skipwhite skipnl
      \ nextgroup=HsFunArgs

call s:match('HsFunArgs', '\v.*(\{[^}]*)@<!\ze\=\_s', '', '@HsExp', 'HsFunBody')

call s:indent_region('HsFunBody', '', '\S.*', '\=', '', 'HsStmt,HsLetWhere,@HsExp', '')

syntax cluster HsExp contains=HsExpVar,HsExpCtor,HsExpParens

call s:match('HsStmt', '\v\s*\zs.{-1,}\s+\ze\<-\_s', '', '@HsExp', 'HsStmtArrow')

call s:indent_region('HsStmtArrow', 'HsOperators', '\S.*', '\<-\s*\_s\s*', '', '@HsExp', '')

call s:indent_region('HsLetWhere', 'HsKeyword', '', '<(where|let)>', '', 'HsDecl,HsFun', '')

syntax match HsPatternParens '[()]' contained

highlight def link HsFunName HsIdentifier
highlight def link HsPatternParens HsParens

" data

call s:region_top(
      \ 'HsTopDeclData',
      \ '',
      \ '\v^\s*data',
      \ '\_s=\_s',
      \ 'keepend skipwhite skipnl',
      \ 'HsSigRhs,HsOperators,HsTopDeclKeyword',
      \ 'HsTopDeclCon,HsDataDeriving',
      \ )

call s:Name('HsTopDeclCon', 'HsConId', 'HsConRecord,HsTopDeclConTypes')

call s:braces('HsConRecord', 'HsConRecordField', 'HsConSum,HsDataDeriving')

call s:region('HsConRecordField', '', '[a-z_]', 'HsDelimiter', '\v(,|\ze\s*})', s:opts . 'keepend', 'HsDecl', 'HsConRecordField')

call s:match('HsConSum', '|', '', 'HsOperators', 'HsTopDeclCon')

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

" misc

syntax keyword HsForeignKeywords foreign export import ccall safe unsafe interruptible capi prim contained
syntax region HsForeignImport start="\<foreign\>" end="\_s\+::\s" keepend
  \ contains=
  \ HsString,
  \ HsOperators,
  \ HsForeignKeywords,
  \ HsIdentifier
if get(g:, 'haskell_enable_static_pointers', 0)
  syntax keyword HsStatic static
endif
syntax keyword HsConditional if then else
syntax match HsSeparator  "[,;]"
" syntax match HsRecordField contained containedin=HsBlock
"   \ "[_a-z][a-zA-Z0-9_']*\(,\s*[_a-z][a-zA-Z0-9_']*\)*\_s\+::\_s"
"   \ contains=
"   \ HsIdentifier,
"   \ HsOperators,
"   \ HsSeparator,
"   \ HsParens
" syntax region HsBlock matchgroup=HsDelimiter start="{" end="}" contains=TOP,@Spell
syntax keyword HsInfix infix infixl infixr
syntax keyword HsBottom undefined
syntax match HsQuote "\<'\+" contained
syntax match HsQuotedType "[A-Z][a-zA-Z0-9_']*\>" contained
syntax region HsQuoted start="\<'\+" end="\>"
  \ contains=
  \ HsType,
  \ HsQuote,
  \ HsQuotedType,
  \ HsSeparator,
  \ HsParens,
  \ HsOperators,
  \ HsIdentifier
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
syntax region HsPragma start="{-#" end="#-}"
syntax region HsLiquid start="{-@" end="@-}"
syntax match HsPreProc "^#.*$"
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
    \ HsType,
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
" highlight def link HsType Type
highlight def link HsDeclKeyword Structure
" highlight def link HsTopDecl Structure
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
