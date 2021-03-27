(variable) @variable
(operator) @operator
(type_operator) @type_operator
(constructor) @constructor
(constructor_operator) @operator
(module) @module
(type) @type
(class_name (type) @class)
; (constr_id) @constructor
(pragma) @pragma
(comment) @comment
(signature name: (variable) @fun_type_name)
(function name: (variable) @fun_name)
(integer) @literal
(float) @literal
(char) @literal
"(" @brackets.parenthesis.left
")" @brackets.parenthesis.right
; "[" @bracket
; "]" @bracket
(type_literal (con_unit "(" @brackets.parenthesis.left.unit.type))
(type_literal (con_list) @type_bracket)
(type_list "[" @bracket)
(type_list "]" @bracket)
(type_parens "(" @parenthesis)
(type_parens ")" @parenthesis)
(tycon_arrow) @operator
"=>" @operator.carrow
"->" @operator.arrow
"<-" @operator.larrow
(where) @keyword
"module" @keyword
"let" @keyword
"in" @keyword
"class" @keyword
"instance" @keyword
"data" @keyword
"newtype" @keyword
"family" @keyword
"type" @keyword
"import" @keyword
"qualified" @keyword
"as" @keyword
"deriving" @keyword
"via" @keyword
"stock" @keyword
"anyclass" @keyword
"do" @keyword
"mdo" @keyword
"rec" @keyword
