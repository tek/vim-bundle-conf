(varid) @variable
(varsym) @operator
(exp (conid) @constructor)
(consym) @operator
(modid (conid) @module_name)
(tycon) @type
(tyclsid) @class
(constr_id) @constructor
(pragma) @pragma
(comment) @comment
(decl_sig name: (varid) @fun_type_name)
(funlhs name: (varid) @fun_name)
(context class: (tycon) @class)
(decl_class (head type_name: (tycon) @class))
(decl_instance (head type_name: (tycon) @class))
(integer) @literal
(float) @literal
(char) @literal
(tycon_unit) @literal
(tycon_list) @literal
(tycon_arrow) @operator
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
"(" @paren
")" @paren
