finish
if exists("b:current_syntax")
  finish
endif

if get(g:, 'haskell_backpack', 0)
  syn keyword haskellBackpackStructure unit signature
  syn keyword haskellBackpackDependency dependency
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

function! s:parens(name, contains, nextgroup) abort "{{{
  execute 'syn region ' . a:name . " matchgroup=haskellPatternParens start='(' end=')'" . s:opts .
        \ 'contains=' . a:contains . ' nextgroup=' . a:nextgroup
endfunction "}}}

function! s:Name(name, contains, nextgroup) abort "{{{
  execute 'syn match ' . a:name . s:conid_re_q . s:opts .
        \ 'contains=' . a:contains . ' nextgroup=' . a:nextgroup
endfunction "}}}

function! s:name(name, nextgroup) abort "{{{
  execute 'syn match ' . a:name . s:var_re_q . s:opts .
        \ 'nextgroup=' . a:nextgroup
endfunction "}}}

syn spell notoplevel
syn sync fromstart

syn match haskellRecordField contained containedin=haskellBlock
  \ "[_a-z][a-zA-Z0-9_']*\(,\s*[_a-z][a-zA-Z0-9_']*\)*\_s\+::\_s"
  \ contains=
  \ haskellIdentifier,
  \ haskellOperators,
  \ haskellSeparator,
  \ haskellParens
" syn match haskellTypeSig
"   \ "\v^\s*(where\s+|let\s+|default\s+)?[_a-z][a-zA-Z0-9_']*#?(,\s*[_a-z][a-zA-Z0-9_']*#?)*\_s+::\_s"
"   \ contains=
"   \ haskellWhere,
"   \ haskellLet,
"   \ haskellDefault,
"   \ haskellIdentifier,
"   \ haskellOperators,
"   \ haskellSeparator,
"   \ haskellParens

" syn keyword haskellWhere where
" syn keyword haskellLet let
syn match HaskellDerive "\<deriving\>\(\s\+\<\(anyclass\|instance\|newtype\|stock\)\>\)\?"
syn keyword haskellDeclKeyword module class instance newtype in
syn match haskellDecl "\<\(type\|data\)\>\s\+\(\<family\>\)\?"
syn keyword haskellDefault default

" fallbacks and generics

syn match haskellType '\<[A-Z]\k*\>' contained
syn match haskellCtor '\<[A-Z]\k*\>' contained
syn match haskellParens '[()]' contained

syn match haskellInlineSig '\v::\s*<.*' contained contains=haskellType

syn match haskellQualifyingModule '\v<[A-Z]\k*\ze\.' contained contains=haskellModuleName,haskellModuleDot

syn match haskellQualifiedCtor '\v([A-Z]\k*\.)*[A-Z]\k*' contained contains=haskellQualifyingModule,haskellCtor

syn match haskellQualifiedType '\v([A-Z]\k*\.)*[A-Z]\k*' contained contains=haskellQualifyingModule,haskellType

syn match haskellQualifiedVar '\v([A-Z]\k*\.)+[a-z_]\k*' contains=haskellQualifyingModule,haskellVar

" TODO generalize the contained groups
syn region haskellParenValue matchgroup=haskellPatternParens start='(' end=')' skipwhite skipnl
      \ contains=haskellEqnPatternParen,haskellEqnPatternCtor,haskellEqnPatternBind
      \ nextgroup=haskellEqnPatternParen,haskellEqnPatternBind

highlight def link haskellCtor Type
highlight def link haskellQualifyingModule Type

" imports

syn match haskellImport '\v^\s*import>' skipwhite skipnl
      \ contains=haskellImportKeyword
      \ nextgroup=haskellImportModule,haskellImportPreQualifier,haskellImportPackage

syn match haskellImportModule '\v[A-Z]\k*(\.[A-Z]\k*)*' contained skipwhite skipnl
      \ contains=haskellModuleName,haskellModuleDot
      \ nextgroup=haskellImportAs,haskellImportHiding,haskellImportList

syn match haskellImportPreQualifier '\v[a-z]+' contained skipwhite skipnl
      \ contains=haskellImportQualifier
      \ nextgroup=haskellImportModule,haskellImportQualifier,haskellImportPackage

syn match haskellImportPackage '\v"[^"]+"' contained skipwhite skipnl
      \ contains=haskellString
      \ nextgroup=haskellImportModule

syn match haskellModuleName '\v<[A-Z]\k*>' contained
syn match haskellModuleDot '\.' contained

syn region haskellImportList matchgroup=haskellImportParens start='(' end=')' contained
      \ contains=haskellImportPrefixedItem,haskellImportType,haskellImportSymbolicType,haskellImportFunc

syn match haskellImportAs 'as\>' contained skipwhite skipnl
      \ contains=haskellImportQualifier
      \ nextgroup=haskellImportAsName

syn match haskellImportAsName '\v[A-Z]\k*' contained skipwhite skipnl
      \ contains=haskellModuleName
      \ nextgroup=haskellImportList

syn match haskellImportHiding 'hiding\>' contained skipwhite skipnl
      \ contains=haskellImportQualifier
      \ nextgroup=haskellImportList

syn match haskellImportType '\v[A-Z]\k*' contained skipwhite skipnl
      \ nextgroup=haskellImportCtors,haskellImportComma

syn match haskellImportSymbolicType '\v\([^\k)]+\)' contained skipwhite skipnl
      \ contains=haskellImportSymbolicTypeName,haskellImportParens
      \ nextgroup=haskellImportCtors,haskellImportComma

syn region haskellImportCtors matchgroup=haskellImportParens start='(' end=')' contained skipwhite skipnl
      \ contains=haskellImportSymbolicCtor,haskellImportCtor
      \ nextgroup=haskellImportComma

syn match haskellImportSymbolicCtor '\v\([^\k)]+\)' contained skipwhite skipnl
      \ contains=haskellImportSymbolicCtorName,haskellImportParens
      \ nextgroup=haskellImportCtorComma

syn match haskellImportCtor '\v[A-Z]\k*' contained skipwhite skipnl
      \ nextgroup=haskellImportCtorComma

syn match haskellImportCtorComma ',' contained skipwhite skipnl
      \ nextgroup=haskellImportSymbolicCtor,haskellImportCtor

syn match haskellImportFunc '\v[a-z]\k*' contained skipwhite skipnl
      \ nextgroup=haskellImportComma

syn match haskellImportPrefixedItem '\v(type|pattern)>' contained skipwhite skipnl
      \ contains=haskellImportItemKeyword
      \ nextgroup=haskellImportSymbolicType,haskellImportType

syn match haskellImportComma ',' contained skipwhite skipnl
      \ nextgroup=haskellImportPrefixedItem,haskellImportType,haskellImportSymbolicType,haskellImportFunc

syn match haskellImportParens '[()]' contained
syn match haskellImportSymbolicTypeName '[^\k()]' contained
syn match haskellImportSymbolicCtorName '[^\k()]' contained

syn keyword haskellImportKeyword import contained
syn keyword haskellImportQualifier qualified safe as hiding contained
syn keyword haskellImportItemKeyword type pattern

highlight def link haskellImportKeyword Include
highlight def link haskellImportQualifier Keyword
highlight def link haskellImportModule Type
highlight def link haskellImportCtor haskellCtor
highlight def link haskellImportType Type
highlight def link haskellImportItemKeyword Keyword
highlight def link haskellImportSymbolicTypeName Type
highlight def link haskellImportSymbolicCtorName Type
highlight def link haskellImportParens haskellParens

" function signature

syn match haskellDeclStart '\v(^|<(where|let|default)>)\s*\ze[_a-z]\k*#?(,\s*[_a-z]\k*#?)*\_s*::\_s'
      \ contains=haskellDeclPreKeyword
      \ nextgroup=haskellDeclName

syn match haskellDeclName '\v\S+#?' contained skipwhite skipnl
      \ nextgroup=haskellDeclComma,haskellSigStart

syn match haskellSigStart '::' contained skipwhite skipnl
      \ nextgroup=haskellSigForall,haskellSigConstraints,haskellSigConstraint,haskellSigParam,haskellSigReturnType

syn match haskellSigReturnType '\v[A-Z]\k*' contained skipwhite skipnl
      \ nextgroup=haskellEqnStart

syn match haskellSigConstraintClass '\v[A-Z]\k*' contained skipwhite skipnl
      \ nextgroup=haskellSigConstraintRest

syn match haskellSigConstraintRest '\v\_.{-1,}(\([^)]*)@<!\=\>' contained skipwhite skipnl
      \ contains=haskellType,haskellOperators,haskellParens
      \ nextgroup=haskellSigConstraint,haskellSigParam,haskellSigReturnType

syn match haskellSigConstraintParam '\v[a-z_]\k*' contained skipwhite skipnl
      \ nextgroup=haskellSigConstraintParam,haskellSigConstraintArg,haskellSigConstraintParen,haskellSigConstraintBrack

syn match haskellSigConstraintArg '\v[A-Z]\k*' contained skipwhite skipnl
      \ nextgroup=haskellSigConstraintParam,haskellSigConstraintArg,haskellSigConstraintParen,haskellSigConstraintBrack

syn match haskellSigParam '\v\S{-}\n?.{-}(\([^)]*)@<!\-\>' contained skipwhite skipnl
      \ contains=haskellType,haskellOperators
      \ nextgroup=haskellSigConstraint,haskellSigParam,haskellSigReturnType

syn match haskellSigConstraint '\v\ze\S.{-}\n?.{-}(\([^)]*)@<!\=\>' contained skipwhite skipnl
      \ nextgroup=haskellSigConstraintClass

syn match haskellSigForall '\v(∀|forall)\s+.{-}\.' contained skipwhite skipnl
      \ nextgroup=haskellSigConstraints,haskellSigConstraint,haskellSigParam,haskellSigReturnType

syn match haskellDeclComma ',' contained skipwhite skipnl
      \ nextgroup=haskellDeclName

syn keyword haskellDeclPreKeyword where let default contained
syn keyword hsDeclForall ∀ forall contained

highlight def link haskellDeclPreKeyword Keyword
highlight def link haskellSigConstraintClass haskellType
highlight def link haskellSigConstraintArg haskellType
highlight def link haskellSigReturnType haskellType
highlight def link haskellSigStart haskellOperators
highlight def link haskellDeclName haskellIdentifier
highlight def link hsDeclForall Keyword

" function equation

syn match haskellEqnStart '\v(<(where|let|default)>\_s*|^)\s*\ze.*(\{[^}]*)@<!\=\_s'
      \ contains=haskellDeclPreKeyword
      \ nextgroup=haskellEqnName

syn match haskellEqnName '\v\S+#?' contained skipwhite skipnl
      \ nextgroup=haskellEqnPatternParen,haskellEqnPatternBind

call s:parens(
      \ 'haskellEqnPatternParen',
      \ 'haskellEqnPatternParen,haskellEqnPatternCtor,haskellEqnPatternBind',
      \ 'haskellEqnPatternParen,haskellEqnPatternBind',
      \ )

call s:Name(
      \ 'haskellEqnPatternCtor',
      \ 'haskellQualifiedCtor',
      \ 'haskellEqnPatternParen,haskellEqnPatternBind,haskellEqnPatternSig',
      \ )

call s:syn(
      \ 'match haskellEqnPatternBind ' . s:q(s:wli . '@!' . s:var_re) . s:opts,
      \ '',
      \ 'haskellEqnPatternParen,haskellEqnPatternBind,haskellEqnPatternSig',
      \ )

syn match haskellEqnPatternSig '::' contained skipwhite skipnl
      \ contains=haskellOperators
      \ nextgroup=haskellEqnPatternTypeParen,haskellEqnPatternType

call s:parens(
      \ 'haskellEqnPatternTypeParen',
      \ 'haskellEqnPatternTypeParen,haskellEqnPatternType,haskellEqnPatternTypeParam',
      \ 'haskellEqnPatternTypeParen,haskellEqnPatternType,haskellEqnPatternTypeParam',
      \ )

call s:Name(
      \ 'haskellEqnPatternType',
      \ 'haskellQualifiedType',
      \ 'haskellEqnPatternTypeParen,haskellEqnPatternType,haskellEqnPatternTypeParam',
      \ )

call s:name(
      \ 'haskellEqnPatternTypeParam',
      \ 'haskellEqnPatternTypeParen,haskellEqnPatternType,haskellEqnPatternTypeParam',
      \ )

syn match haskellPatternParens '[()]' contained

highlight def link haskellEqnName haskellIdentifier
highlight def link haskellPatternParens haskellParens

" misc

syn keyword haskellForeignKeywords foreign export import ccall safe unsafe interruptible capi prim contained
syn region haskellForeignImport start="\<foreign\>" end="\_s\+::\s" keepend
  \ contains=
  \ haskellString,
  \ haskellOperators,
  \ haskellForeignKeywords,
  \ haskellIdentifier
syn keyword haskellKeyword do case of
if get(g:, 'haskell_enable_static_pointers', 0)
  syn keyword haskellStatic static
endif
syn keyword haskellConditional if then else
syn match haskellNumber "\<[0-9]\+\>\|\<0[xX][0-9a-fA-F]\+\>\|\<0[oO][0-7]\+\>\|\<0[bB][10]\+\>"
syn match haskellFloat "\<[0-9]\+\.[0-9]\+\([eE][-+]\=[0-9]\+\)\=\>"
" syn match haskellSeparator  "[,;]"
" syn region haskellParens matchgroup=haskellDelimiter start="(" end=")" contains=TOP,haskellTypeSig,@Spell
" syn region haskellBrackets matchgroup=haskellDelimiter start="\[" end="]" contains=TOP,haskellTypeSig,@Spell
syn region haskellBlock matchgroup=haskellDelimiter start="{" end="}" contains=TOP,@Spell
syn keyword haskellInfix infix infixl infixr
syn keyword haskellBottom undefined
syn match haskellOperators "[-!#$%&\*\+/<=>\?@\\^|~:.]\+\|\<_\>"
syn match haskellQuote "\<'\+" contained
syn match haskellQuotedType "[A-Z][a-zA-Z0-9_']*\>" contained
syn region haskellQuoted start="\<'\+" end="\>"
  \ contains=
  \ haskellType,
  \ haskellQuote,
  \ haskellQuotedType,
  \ haskellSeparator,
  \ haskellParens,
  \ haskellOperators,
  \ haskellIdentifier
syn match haskellLineComment "---*\([^-!#$%&\*\+./<=>\?@\\^|~].*\)\?$"
  \ contains=
  \ haskellTodo,
  \ @Spell
syn match haskellBacktick "`[A-Za-z_][A-Za-z0-9_\.']*#\?`"
syn region haskellString start=+"+ skip=+\\\\\|\\"+ end=+"+
  \ contains=@Spell
" syn match haskellIdentifier "[_a-z][a-zA-z0-9_']*" contained
syn match haskellChar "\<'[^'\\]'\|'\\.'\|'\\u[0-9a-fA-F]\{4}'\>"
" " syn match haskellType "\<[A-Z][a-zA-Z0-9_']*\>"
syn region haskellBlockComment start="{-" end="-}"
  \ contains=
  \ haskellBlockComment,
  \ haskellTodo,
  \ @Spell
syn region haskellPragma start="{-#" end="#-}"
syn region haskellLiquid start="{-@" end="@-}"
syn match haskellPreProc "^#.*$"
syn keyword haskellTodo TODO FIXME contained
" Treat a shebang line at the start of the file as a comment
syn match haskellShebang "\%^#!.*$"
if !get(g:, 'haskell_disable_TH', 0)
    syn match haskellQuasiQuoted "." containedin=haskellQuasiQuote contained
    syn region haskellQuasiQuote matchgroup=haskellTH start="\[[_a-zA-Z][a-zA-z0-9._']*|" end="|\]"
    syn region haskellTHBlock matchgroup=haskellTH start="\[\(d\|t\|p\)\?|" end="|]" contains=TOP
    syn region haskellTHDoubleBlock matchgroup=haskellTH start="\[||" end="||]" contains=TOP
endif
if get(g:, 'haskell_enable_typeroles', 0)
  syn keyword haskellTypeRoles phantom representational nominal contained
  syn region haskellTypeRoleBlock matchgroup=haskellTypeRoles start="type\s\+role" end="$" keepend
    \ contains=
    \ haskellType,
    \ haskellTypeRoles
endif
if get(g:, 'haskell_enable_quantification', 0)
  syn keyword haskellForall forall
endif
if get(g:, 'haskell_enable_recursivedo', 0)
  syn keyword haskellRecursiveDo mdo rec
endif
if get(g:, 'haskell_enable_arrowsyntax', 0)
  syn keyword haskellArrowSyntax proc
endif
if get(g:, 'haskell_enable_pattern_synonyms', 0)
  syn keyword haskellPatternKeyword pattern
endif

highlight def link haskellBottom Macro
highlight def link haskellTH Boolean
highlight def link haskellIdentifier Identifier
highlight def link haskellForeignKeywords Structure
highlight def link haskellKeyword Keyword
highlight def link haskellDefault Keyword
highlight def link haskellConditional Conditional
highlight def link haskellNumber Number
highlight def link haskellFloat Float
" highlight def link haskellSeparator Delimiter
" highlight def link haskellDelimiter Delimiter
highlight def link haskellInfix Keyword
highlight def link haskellOperators Operator
highlight def link haskellQuote Operator
highlight def link haskellShebang Comment
highlight def link haskellLineComment Comment
highlight def link haskellBlockComment Comment
highlight def link haskellPragma SpecialComment
highlight def link haskellLiquid SpecialComment
highlight def link haskellString String
highlight def link haskellChar String
highlight def link haskellBacktick Operator
highlight def link haskellQuasiQuoted String
highlight def link haskellTodo Todo
highlight def link haskellPreProc PreProc
highlight def link haskellAssocType Type
highlight def link haskellQuotedType Type
" highlight def link haskellType Type
if get(g:, 'haskell_classic_highlighting', 0)
  highlight def link haskellDeclKeyword Keyword
  highlight def link HaskellDerive Keyword
  highlight def link haskellDecl Keyword
  highlight def link haskellWhere Keyword
  highlight def link haskellLet Keyword
else
  highlight def link haskellDeclKeyword Structure
  highlight def link HaskellDerive Structure
  highlight def link haskellDecl Structure
  highlight def link haskellWhere Structure
  highlight def link haskellLet Structure
endif

if get(g:, 'haskell_enable_quantification', 0)
  highlight def link haskellForall Operator
endif
if get(g:, 'haskell_enable_recursivedo', 0)
  highlight def link haskellRecursiveDo Keyword
endif
if get(g:, 'haskell_enable_arrowsyntax', 0)
  highlight def link haskellArrowSyntax Keyword
endif
if get(g:, 'haskell_enable_static_pointers', 0)
  highlight def link haskellStatic Keyword
endif
if get(g:, 'haskell_classic_highlighting', 0)
  if get(g:, 'haskell_enable_pattern_synonyms', 0)
    highlight def link haskellPatternKeyword Keyword
  endif
  if get(g:, 'haskell_enable_typeroles', 0)
    highlight def link haskellTypeRoles Keyword
  endif
else
  if get(g:, 'haskell_enable_pattern_synonyms', 0)
    highlight def link haskellPatternKeyword Structure
  endif
  if get(g:, 'haskell_enable_typeroles', 0)
    highlight def link haskellTypeRoles Structure
  endif
endif

if get(g:, 'haskell_backpack', 0)
  highlight def link haskellBackpackStructure Structure
  highlight def link haskellBackpackDependency Include
endif
let b:current_syntax = "haskell"
