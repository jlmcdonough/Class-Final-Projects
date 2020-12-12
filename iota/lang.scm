(module lang (lib "eopl.ss" "eopl")
  
  (require "drscheme-init.scm")
  
  (provide (all-defined-out))

  ;;;;;;;;;;;;;;;; grammatical specification ;;;;;;;;;;;;;;;;
  
  (define the-lexical-spec
    '((whitespace (whitespace) skip)
      (comment ("\\" (arbno (not #\newline))) skip)
      
      (ident 
       ("_" (arbno (or letter digit "=" "=>")))
       symbol)

     (str
      ("#" (arbno (or letter digit " " "." "!" "?" ":" ";" "," "(" ")" "-" "_" "[" "]" "&" "|" "#" "=" "<" ">" "/" "{" "}" "~")))
       string)

      (number (digit (arbno digit)) number)
      (number ("-" digit (arbno digit)) number)
      ))

  (define the-grammar
    '((program ("{" statement "}") a-program)

      ; statements

      (statement
       ("log" expression)
         log-stmt)

      (statement
       ("nlog" expression)
         newLog-stmt)
      
      (statement
       ("set" ident "=" expression)
         set-stmt)

      (statement
       ("let" (separated-list ident ",") "in" statement)
       let-stmt)

      (statement
       ("emptyStmt")
         empty-stmt)

      (statement
       ("{" (separated-list statement ";") "}")
         multi-stmt)

      (statement
       ("while" expression "{" statement "}")
         while-stmt)

       (statement
        ("iff" expression "{" statement "}" (arbno "elif" expression "{" statement "}" ) )
          if-stmt)

       (statement
        ("if" expression "{" statement "}" (arbno "elif" expression "{" statement "}" ) "else" "{" statement "}")
          if-else-stmt)
      

      ; expressions
      
      (expression (number) const-exp)

      (expression (ident) var-exp)
      
      (expression
       ("'" str "'")
          str-exp)

      (expression
        ("True")
       true-exp)
      
      (expression
        ("False")
          false-exp)

      (expression
       ("emptyList")
         emptyList-exp)

      (expression
        ("[" expression (arbno "," expression) "]" )
        list-exp)

      (expression
       ("isNull?" "(" expression ")" )
         null-exp)

      (expression
       ("&&" "(" expression "," expression ")" )
          and-exp)

      (expression
       ("||" "(" expression "," expression ")" )
          or-exp)

      (expression
       ("!" "(" expression ")" )
          not-exp)
    
      (expression
       ("sub" "(" expression "," expression ")" )
          sub-exp)

      (expression
       ("div" "(" expression "," expression ")" )
          div-exp)

      (expression
       ("intDiv" "(" expression "," expression ")" )
          intDiv-exp)

      (expression
       ("isZero?" "(" expression ")" )
          isZero?-exp)

      (expression
       ("<" "(" expression "," expression ")" )
         lessThan-exp)

      (expression
       ("<=" "(" expression "," expression ")" )
         lessThanEqual-exp)

      (expression
       (">" "(" expression "," expression ")" )
         greaterThan-exp)

      (expression
       (">=" "(" expression "," expression ")" )
         greaterThanEqual-exp)

      (expression
       ("==" "(" expression "," expression ")" )
         equalTo-exp)

      (expression
       ("!=" "(" expression "," expression ")" )
         notEqualTo-exp)

      (expression
       ("proc" ident "=>" "{" expression "}")
          proc-exp)

      (expression
       ("->" expression "(" expression ")")
       call-exp)
      ))

  ;;;;;;;;;;;;;;;; sllgen boilerplate ;;;;;;;;;;;;;;;;
  
  (sllgen:make-define-datatypes the-lexical-spec the-grammar)
  
  (define show-the-datatypes
    (lambda () (sllgen:list-define-datatypes the-lexical-spec the-grammar)))
  
  (define scan&parse
    (sllgen:make-string-parser the-lexical-spec the-grammar))
  
  (define just-scan
    (sllgen:make-string-scanner the-lexical-spec the-grammar))

  

  )
