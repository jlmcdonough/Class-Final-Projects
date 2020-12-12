(module data-structures (lib "eopl.ss" "eopl")

  (require "lang.scm")                  ; for expression
  (require "store.scm")                 ; for implicit-refs

  (provide (all-defined-out))               ; too many things to list

;;;;;;;;;;;;;;;; expressed values ;;;;;;;;;;;;;;;;

;;; an expressed value is either a number, a boolean, a string, a procval, a listval, a refval, or undefined.

  (define-datatype expval expval?
    (num-val
      (value number?))
    (bool-val
      (boolean boolean?))
    (string-val
        (str string?))
    (proc-val 
      (proc proc?))
    (list-val
      (lst (list-of expval?)))
     (ref-val
      (ref reference?))
    (undefined-val)
    )
;;; extractors:

  (define expval->num
    (lambda (v)
      (cases expval v
	(num-val (num) num)
	(else (expval-extractor-error 'num v)))))

  (define expval->bool
    (lambda (v)
      (cases expval v
	(bool-val (bool) bool)
	(else (expval-extractor-error 'bool v)))))

  (define expval->str
    (lambda (v)
      (cases expval v
	(string-val (str) str)
	(else (expval-extractor-error 'str v)))))

  (define expval->proc
    (lambda (v)
      (cases expval v
	(proc-val (proc) proc)
	(else (expval-extractor-error 'proc v)))))

   (define expval->list
    (lambda (v)
      (cases expval v
	(list-val (lst) lst)
	(else (expval-extractor-error 'list v)))))

   (define expval->ref
    (lambda (v)
      (cases expval v
	(ref-val (ref) ref)
	(else (expval-extractor-error 'reference v)))))

  (define expval-extractor-error
    (lambda (variant value)
      (eopl:error 'expval-extractors "Looking for a ~s, found ~s"
	variant value)))

;;;;;;;;;;;;;;;; procedures ;;;;;;;;;;;;;;;;

  (define-datatype proc proc?
    (procedure
      (bvar symbol?)
      (body expression?)
      (env environment?)))
  
  (define-datatype environment environment?
    (empty-env)
    (extend-env 
      (bvar symbol?)
      (bval reference?)                
      (saved-env environment?))
    (extend-env*
      (b-vars (list-of symbol?))
      (b-vals (list-of reference?))
      (saved-env environment?))
    (extend-env-rec*
      (proc-names (list-of symbol?))
      (b-vars (list-of symbol?))
      (proc-bodies (list-of expression?))
      (saved-env environment?)))

  

)
