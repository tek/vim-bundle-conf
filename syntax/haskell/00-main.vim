if exists("b:current_syntax")
  finish
endif

if get(g:, 'haskell_backpack', 0)
  syn keyword HsBackpackStructure unit signature
  syn keyword HsBackpackDependency dependency
endif

function! s:q(a) abort "{{{
  return " '" . a:a . "' "
endfunction "}}}

let s:opts = ' contained skipwhite skipnl '
let s:var_re = '\v[a-z_]\k*'
let s:var_re_q = s:q(s:var_re)
let s:conid_re = '\v[A-Z]\k*'
let s:conid_re_q = s:q(s:conid_re)
let s:wli = '\v(<(where|let|in)>\s+)'

function! s:syn(main, contains, nextgroup) abort "{{{
  execute 'syn ' . a:main .
        \ (empty(a:contains) ? '' : ' contains=' . a:contains) .
        \ (empty(a:nextgroup) ? '' : ' nextgroup=' . a:nextgroup)
endfunction "}}}

function! s:parens_top(name, contains, nextgroup) abort "{{{
  return s:syn(
        \ 'region ' . a:name . " matchgroup=HsParens start='(' end=')'",
        \ a:contains, a:nextgroup
        \ )
endfunction "}}}

function! s:parens(name, contains, nextgroup) abort "{{{
  return s:syn(
        \ 'region ' . a:name . " matchgroup=HsParens start='(' end=')'" . s:opts,
        \ a:contains, a:nextgroup
        \ )
endfunction "}}}

function! s:Name_top(name, contains, nextgroup) abort "{{{
  return s:syn('match ' . a:name . s:conid_re_q, a:contains, a:nextgroup)
endfunction "}}}

function! s:Name(name, contains, nextgroup) abort "{{{
  return s:syn('match ' . a:name . s:conid_re_q . s:opts, a:contains, a:nextgroup)
endfunction "}}}

function! s:name(name, contains, nextgroup) abort "{{{
  return s:syn('match ' . a:name . s:var_re_q . s:opts, a:contains, a:nextgroup)
endfunction "}}}

syn spell notoplevel
syn sync fromstart

syn match HsRecordField contained containedin=HsBlock
  \ "[_a-z][a-zA-Z0-9_']*\(,\s*[_a-z][a-zA-Z0-9_']*\)*\_s\+::\_s"
  \ contains=
  \ HsIdentifier,
  \ HsOperators,
  \ HsSeparator,
  \ HsParens
" syn match HsTypeSig
"   \ "\v^\s*(where\s+|let\s+|default\s+)?[_a-z][a-zA-Z0-9_']*#?(,\s*[_a-z][a-zA-Z0-9_']*#?)*\_s+::\_s"
"   \ contains=
"   \ HsWhere,
"   \ HsLet,
"   \ HsDefault,
"   \ HsIdentifier,
"   \ HsOperators,
"   \ HsSeparator,
"   \ HsParens

" syn keyword HsWhere where
" syn keyword HsLet let
syn match HaskellDerive "\<deriving\>\(\s\+\<\(anyclass\|instance\|newtype\|stock\)\>\)\?"
syn keyword HsDeclKeyword module class instance newtype in
syn match HsDecl "\<\(type\|data\)\>\s\+\(\<family\>\)\?"
syn keyword HsDefault default

" fallbacks and generics

syn match HsType '\<[A-Z]\k*\>' contained
syn match HsResultType '\<[A-Z]\k*\>' contained
syn match HsCtor '\<[A-Z]\k*\>' contained
syn match HsParens '[()]' contained

syn match HsInlineSig '\v::\s*<.*' contained contains=HsType

syn match HsQualifyingModule '\v<[A-Z]\k*\ze\.' contained contains=HsModuleName,HsModuleDot

syn match HsQualifiedCtor '\v([A-Z]\k*\.)*[A-Z]\k*' contained contains=HsQualifyingModule,HsCtor

syn match HsQualifiedType '\v([A-Z]\k*\.)*[A-Z]\k*' contained contains=HsQualifyingModule,HsType

syn match HsQualifiedVar '\v([A-Z]\k*\.)+[a-z_]\k*' contains=HsQualifyingModule,HsVar

highlight def link HsType Type
highlight def link HsResultType Type
highlight def link HsCtor Type
highlight def link HsQualifyingModule Type

" terms

call s:parens_top(
      \ 'HsTermParens',
      \ 'HsTermParens,HsTermCtor,HsTermVar',
      \ '',
      \ )

call s:Name_top(
      \ 'HsTermCtor',
      \ 'HsQualifiedCtor',
      \ '',
      \ )

call s:syn(
      \ 'match HsTermVar ' . s:q(s:wli . '@!' . s:var_re) . s:opts,
      \ '',
      \ 'HsTermParens,HsTermVar,HsInlineSig',
      \ )

syn match HsInlineSig '::' contained skipwhite skipnl
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

syn match HsImport '\v^\s*import>' skipwhite skipnl
      \ contains=HsImportKeyword
      \ nextgroup=HsImportModule,HsImportPreQualifier,HsImportPackage

syn match HsImportModule '\v[A-Z]\k*(\.[A-Z]\k*)*' contained skipwhite skipnl
      \ contains=HsModuleName,HsModuleDot
      \ nextgroup=HsImportAs,HsImportHiding,HsImportList

syn match HsImportPreQualifier '\v[a-z]+' contained skipwhite skipnl
      \ contains=HsImportQualifier
      \ nextgroup=HsImportModule,HsImportQualifier,HsImportPackage

syn match HsImportPackage '\v"[^"]+"' contained skipwhite skipnl
      \ contains=HsString
      \ nextgroup=HsImportModule

syn match HsModuleName '\v<[A-Z]\k*>' contained
syn match HsModuleDot '\.' contained

syn region HsImportList matchgroup=HsImportParens start='(' end=')' contained
      \ contains=HsImportPrefixedItem,HsImportType,HsImportSymbolicType,HsImportFunc

syn match HsImportAs 'as\>' contained skipwhite skipnl
      \ contains=HsImportQualifier
      \ nextgroup=HsImportAsName

syn match HsImportAsName '\v[A-Z]\k*' contained skipwhite skipnl
      \ contains=HsModuleName
      \ nextgroup=HsImportList

syn match HsImportHiding 'hiding\>' contained skipwhite skipnl
      \ contains=HsImportQualifier
      \ nextgroup=HsImportList

syn match HsImportType '\v[A-Z]\k*' contained skipwhite skipnl
      \ nextgroup=HsImportCtors,HsImportComma

syn match HsImportSymbolicType '\v\([^\k)]+\)' contained skipwhite skipnl
      \ contains=HsImportSymbolicTypeName,HsImportParens
      \ nextgroup=HsImportCtors,HsImportComma

syn region HsImportCtors matchgroup=HsImportParens start='(' end=')' contained skipwhite skipnl
      \ contains=HsImportSymbolicCtor,HsImportCtor
      \ nextgroup=HsImportComma

syn match HsImportSymbolicCtor '\v\([^\k)]+\)' contained skipwhite skipnl
      \ contains=HsImportSymbolicCtorName,HsImportParens
      \ nextgroup=HsImportCtorComma

syn match HsImportCtor '\v[A-Z]\k*' contained skipwhite skipnl
      \ nextgroup=HsImportCtorComma

syn match HsImportCtorComma ',' contained skipwhite skipnl
      \ nextgroup=HsImportSymbolicCtor,HsImportCtor

syn match HsImportFunc '\v[a-z]\k*' contained skipwhite skipnl
      \ nextgroup=HsImportComma

syn match HsImportPrefixedItem '\v(type|pattern)>' contained skipwhite skipnl
      \ contains=HsImportItemKeyword
      \ nextgroup=HsImportSymbolicType,HsImportType

syn match HsImportComma ',' contained skipwhite skipnl
      \ nextgroup=HsImportPrefixedItem,HsImportType,HsImportSymbolicType,HsImportFunc

syn match HsImportParens '[()]' contained
syn match HsImportSymbolicTypeName '[^\k()]' contained
syn match HsImportSymbolicCtorName '[^\k()]' contained

syn keyword HsImportKeyword import contained
syn keyword HsImportQualifier qualified safe as hiding contained
syn keyword HsImportItemKeyword type pattern

highlight def link HsImportKeyword Include
highlight def link HsImportQualifier Keyword
highlight def link HsImportModule Type
highlight def link HsModuleName Type
highlight def link HsImportCtor HsCtor
highlight def link HsImportType Type
highlight def link HsImportItemKeyword Keyword
highlight def link HsImportSymbolicTypeName Type
highlight def link HsImportSymbolicCtorName HsCtor
highlight def link HsImportParens HsParens

" function signature

syn match HsDeclStart '\v(^|<(where|let|default)>)\s*\ze[_a-z]\k*#?(,\s*[_a-z]\k*#?)*\_s*::\_s'
      \ contains=HsDeclPreKeyword
      \ nextgroup=HsDeclName

syn match HsDeclName '\v\S+#?' contained skipwhite skipnl
      \ nextgroup=HsDeclComma,HsSigStart

syn match HsSigStart '::' contained skipwhite skipnl
      \ nextgroup=HsSig

syn match HsSig '' contained skipwhite skipnl
      \ nextgroup=HsSigForall,HsSigConstraints,HsSigConstraint,HsSigParam,HsSigResultType

syn match HsSigResultType '\v[A-Z].*' contained skipwhite skipnl
      \ contains=HsResultType,HsOperators,HsParens
      \ nextgroup=HsEqnStart

syn match HsSigConstraintClass '\v[A-Z]\k*' contained skipwhite skipnl
      \ nextgroup=HsSigConstraintRest

syn match HsSigConstraintRest '\v.*(\n\s*)?\=\>' contained skipwhite skipnl
      \ contains=HsTypeArg,HsOperators
      \ nextgroup=HsSigConstraint,HsSigParam,HsSigResultType

syn match HsTypeArg '\ze\S' contained
      \ nextgroup=HsType,HsParensSig

syn region HsParensSig matchgroup=HsParens start='(' end=')' contained keepend extend
      \ contains=HsType,HsForall,HsOperators
      " \ contains=HsSig

syn match HsSigConstraintParam '\v[a-z_]\k*' contained skipwhite skipnl
      \ nextgroup=HsSigConstraintParam,HsSigConstraintArg,HsSigConstraintParen,HsSigConstraintBrack

syn match HsSigConstraintArg '\v[A-Z]\k*' contained skipwhite skipnl
      \ nextgroup=HsSigConstraintParam,HsSigConstraintArg,HsSigConstraintParen,HsSigConstraintBrack

syn match HsSigParam '\v\S.{-}\n?.{-}(\([^)]*)@<!\-\>' contained skipwhite skipnl
      \ contains=HsType,HsOperators
      \ nextgroup=HsSigConstraint,HsSigParam,HsSigResultType

syn match HsSigConstraint '\v\ze\S.*(\n\s*)?\=\>' contained skipwhite skipnl
      \ nextgroup=HsSigConstraintClass

syn match HsSigForall '\v(∀|forall)\s+.{-}(\n\s*)?\.' contained skipwhite skipnl
      \ contains=HsForall,HsOperators,HsType
      \ nextgroup=HsSigConstraints,HsSigConstraint,HsSigParam,HsSigResultType

syn match HsDeclComma ',' contained skipwhite skipnl
      \ nextgroup=HsDeclName

syn keyword HsDeclPreKeyword where let default contained
syn match HsForall '\v(∀|forall)' contained

highlight def link HsDeclPreKeyword Keyword
highlight def link HsSigConstraintClass HsType
highlight def link HsSigConstraintArg HsType
highlight def link HsSigStart HsOperators
highlight def link HsDeclName HsIdentifier
highlight def link HsForall Keyword

" function equation

syn match HsEqnStart '\v(<(where|let|default)>\_s*|^)\s*\ze.*(\{[^}]*)@<!\=\_s'
      \ contains=HsDeclPreKeyword
      \ nextgroup=HsEqnName

syn match HsEqnName '\v\S+#?' contained skipwhite skipnl
      \ nextgroup=HsTermParens,HsTermVar

syn match HsPatternParens '[()]' contained

highlight def link HsEqnName HsIdentifier
highlight def link HsPatternParens HsParens

" misc

syn keyword HsForeignKeywords foreign export import ccall safe unsafe interruptible capi prim contained
syn region HsForeignImport start="\<foreign\>" end="\_s\+::\s" keepend
  \ contains=
  \ HsString,
  \ HsOperators,
  \ HsForeignKeywords,
  \ HsIdentifier
syn keyword HsKeyword do case of
if get(g:, 'haskell_enable_static_pointers', 0)
  syn keyword HsStatic static
endif
syn keyword HsConditional if then else
syn match HsNumber "\<[0-9]\+\>\|\<0[xX][0-9a-fA-F]\+\>\|\<0[oO][0-7]\+\>\|\<0[bB][10]\+\>"
syn match HsFloat "\<[0-9]\+\.[0-9]\+\([eE][-+]\=[0-9]\+\)\=\>"
" syn match HsSeparator  "[,;]"
" syn region HsParens matchgroup=HsDelimiter start="(" end=")" contains=TOP,HsTypeSig,@Spell
" syn region HsBrackets matchgroup=HsDelimiter start="\[" end="]" contains=TOP,HsTypeSig,@Spell
syn region HsBlock matchgroup=HsDelimiter start="{" end="}" contains=TOP,@Spell
syn keyword HsInfix infix infixl infixr
syn keyword HsBottom undefined
syn match HsOperators "[-!#$%&\*\+/<=>\?@\\^|~:.]\+\|\<_\>"
syn match HsQuote "\<'\+" contained
syn match HsQuotedType "[A-Z][a-zA-Z0-9_']*\>" contained
syn region HsQuoted start="\<'\+" end="\>"
  \ contains=
  \ HsType,
  \ HsQuote,
  \ HsQuotedType,
  \ HsSeparator,
  \ HsParens,
  \ HsOperators,
  \ HsIdentifier
syn match HsLineComment "---*\([^-!#$%&\*\+./<=>\?@\\^|~].*\)\?$"
  \ contains=
  \ HsTodo,
  \ @Spell
syn match HsBacktick "`[A-Za-z_][A-Za-z0-9_\.']*#\?`"
syn region HsString start=+"+ skip=+\\\\\|\\"+ end=+"+
  \ contains=@Spell
" syn match HsIdentifier "[_a-z][a-zA-z0-9_']*" contained
syn match HsChar "\<'[^'\\]'\|'\\.'\|'\\u[0-9a-fA-F]\{4}'\>"
" " syn match HsType "\<[A-Z][a-zA-Z0-9_']*\>"
syn region HsBlockComment start="{-" end="-}"
  \ contains=
  \ HsBlockComment,
  \ HsTodo,
  \ @Spell
syn region HsPragma start="{-#" end="#-}"
syn region HsLiquid start="{-@" end="@-}"
syn match HsPreProc "^#.*$"
syn keyword HsTodo TODO FIXME contained
" Treat a shebang line at the start of the file as a comment
syn match HsShebang "\%^#!.*$"
if !get(g:, 'haskell_disable_TH', 0)
    syn match HsQuasiQuoted "." containedin=HsQuasiQuote contained
    syn region HsQuasiQuote matchgroup=HsTH start="\[[_a-zA-Z][a-zA-z0-9._']*|" end="|\]"
    syn region HsTHBlock matchgroup=HsTH start="\[\(d\|t\|p\)\?|" end="|]" contains=TOP
    syn region HsTHDoubleBlock matchgroup=HsTH start="\[||" end="||]" contains=TOP
endif
if get(g:, 'haskell_enable_typeroles', 0)
  syn keyword HsTypeRoles phantom representational nominal contained
  syn region HsTypeRoleBlock matchgroup=HsTypeRoles start="type\s\+role" end="$" keepend
    \ contains=
    \ HsType,
    \ HsTypeRoles
endif
if get(g:, 'haskell_enable_recursivedo', 0)
  syn keyword HsRecursiveDo mdo rec
endif
if get(g:, 'haskell_enable_arrowsyntax', 0)
  syn keyword HsArrowSyntax proc
endif
if get(g:, 'haskell_enable_pattern_synonyms', 0)
  syn keyword HsPatternKeyword pattern
endif

highlight def link HsBottom Macro
highlight def link HsTH Boolean
highlight def link HsIdentifier Identifier
highlight def link HsForeignKeywords Structure
highlight def link HsKeyword Keyword
highlight def link HsDefault Keyword
highlight def link HsConditional Conditional
highlight def link HsNumber Number
highlight def link HsFloat Float
" highlight def link HsSeparator Delimiter
" highlight def link HsDelimiter Delimiter
highlight def link HsInfix Keyword
highlight def link HsOperators Operator
highlight def link HsQuote Operator
highlight def link HsShebang Comment
highlight def link HsLineComment Comment
highlight def link HsBlockComment Comment
highlight def link HsPragma SpecialComment
highlight def link HsLiquid SpecialComment
highlight def link HsString String
highlight def link HsChar String
highlight def link HsBacktick Operator
highlight def link HsQuasiQuoted String
highlight def link HsTodo Todo
highlight def link HsPreProc PreProc
highlight def link HsAssocType Type
highlight def link HsQuotedType Type
" highlight def link HsType Type
highlight def link HsDeclKeyword Structure
highlight def link HaskellDerive Structure
highlight def link HsDecl Structure
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
