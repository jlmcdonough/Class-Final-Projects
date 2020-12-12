(module interp (lib "eopl.ss" "eopl")
  
  (require "drscheme-init.scm")

  (require "lang.scm")
  (require "data-structures.scm")
  (require "environments.scm")
  (require "store.scm")

  (provide value-of-program result-of)

;;;;;;;;;;;;;;;; the interpreter ;;;;;;;;;;;;;;;;
  ;; value-of-program : Program -> Expval
  (define value-of-program 
    (lambda (pgm)
      (initialize-store!)
      (cases program pgm
        (a-program (stmt1)
          (result-of stmt1 (init-env))))))

    (define values-of-exps
    (lambda (exps env)
      (map
        (lambda (exp) (value-of exp env))
        exps)))
  
  (define expval->repVal
    (lambda (val)
      (cases expval val
        (undefined-val () "#<undefined>")
        (num-val (num) num)
        (string-val (str) str)
        (bool-val (bool) bool)
        (proc-val (proc) "#<procedure>")
        (ref-val (ref) ref)
        (list-val (lst) (map expval->repVal lst)))))

  
  ;; value-of-program : Program -> ExpVal
  (define result-of 
    (lambda (stmt env)
      (cases statement stmt
       
        (log-stmt (exp1)
          (let ((val1 (value-of exp1 env)))
            (display (expval->repVal val1))))

         (newLog-stmt (exp1)
          (let ((val1 (value-of exp1 env)))
            (newline)
            (display (expval->repVal val1))
            ))
        
        (set-stmt (var1 exp1)
            (setref! (apply-env env var1) (value-of exp1 env))
            (values))

        (let-stmt (var1 stmt1)
          (let ((refs (map (lambda (var) (newref (undefined-val))) var1)))
            (result-of stmt1 (extend-env* var1 refs env))
            (values)))
             
            


      (empty-stmt ()
         (" "))

       (multi-stmt (stmts)
         (if (null? stmts)
              (values)
              (begin
                (result-of (car stmts) env)
                (result-of (multi-stmt (cdr stmts)) env))))
        
        (if-stmt (exp1 stmt1 exps stmts)
          (begin
            (if (expval->bool (value-of exp1 env))
              (result-of stmt1 env)
              (if (null? exps)
                  999  
                  (result-of (if-stmt (car exps) (car stmts) (cdr exps) (cdr stmts)) env)
               )
             )
          )
          (values)
        )

    
         (if-else-stmt (exp1 stmt1 exps stmts stmt2)
          (begin
            (if (expval->bool (value-of exp1 env))
              (result-of stmt1 env)
              (if (null? exps)
                  (result-of stmt2 env)
                  (result-of (if-else-stmt (car exps) (car stmts) (cdr exps) (cdr stmts) stmt2) env)
               )
             )
          )
          (values)
        )
        
        (while-stmt (exp1 stmt1)
          (if (expval->bool (value-of exp1 env))
              (begin
                (result-of stmt1 env)
                (result-of stmt env)) ; recursion on the while-stmt
              (values)))

        )))

  ;; value-of : Exp * Env -> ExpVal
  (define value-of
    (lambda (exp env)
      (cases expression exp

  	(const-exp (num) (num-val num))

        (var-exp (var) (deref (apply-env env var)))

        (str-exp (str) (string-val str))
 
        (true-exp ()
            (bool-val #t))
        
        (false-exp ()
            (bool-val #f))

        (emptyList-exp ()
            (list-val '()))

         (list-exp (exp exps)
          (list-val
            (cons (value-of exp env)
              (values-of-exps exps env))))

        (null-exp (exp1)
              (let ((val1 (expval->list (value-of exp1 env))))
                  (if (null? val1)
                      (bool-val #t)
	              (bool-val #f)
                      )))

        (and-exp (exp1 exp2)
              (let ((val1 (expval->bool (value-of exp1 env)))
                    (val2 (expval->bool (value-of exp2 env))))
                (bool-val (and val1 val2))))

        (or-exp (exp1 exp2)
              (let ((val1 (expval->bool (value-of exp1 env)))
                    (val2 (expval->bool (value-of exp2 env))))
                (bool-val (or val1 val2))))

         (not-exp (exp1)
              (let ((val1 (expval->bool (value-of exp1 env))))
                (bool-val (not val1))))

        (sub-exp (rand1 rand2)
            (let ((val1
                    (expval->num
		    (value-of rand1 env)))
        	  (val2
		     (expval->num
                     (value-of rand2 env))))
                  (num-val
	    	    (- val1 val2))))
 
        (div-exp (rand1 rand2)
  	     (let ((val1
                    (expval->num
		    (value-of rand1 env)))
        	  (val2
                    (expval->num
		    (value-of rand2 env))))
    	          (num-val
	    	    (/ val1 val2))))

        (intDiv-exp (rand1 rand2)
  	     (let ((val1
                    (expval->num
		    (value-of rand1 env)))
        	  (val2
                    (expval->num
		    (value-of rand2 env))))
    	          (num-val
	    	    (floor
                      (/ val1 val2)))))
                 
 
 	(isZero?-exp (rand)
             (let ((val1 (expval->num (value-of rand env))))
	           (if (zero? val1)
	               (bool-val #t)
	               (bool-val #f))))

        (lessThan-exp (rand1 rand2)
            (let ((val1
                    (expval->num
		    (value-of rand1 env)))
        	  (val2
                    (expval->num
		    (value-of rand2 env))))
    	          (if (< val1 val2)
	    	    (bool-val #t)
                    (bool-val #f)
              )))

         (lessThanEqual-exp (rand1 rand2)
            (let ((val1
                    (expval->num
		    (value-of rand1 env)))
        	  (val2
                    (expval->num
		    (value-of rand2 env))))
    	          (if (<= val1 val2)
	    	    (bool-val #t)
                    (bool-val #f)
              )))

         (greaterThan-exp (rand1 rand2)
            (let ((val1
                    (expval->num
		    (value-of rand1 env)))
        	  (val2
                    (expval->num
		    (value-of rand2 env))))
    	          (if (> val1 val2)
	    	    (bool-val #t)
                    (bool-val #f)
              )))

         (greaterThanEqual-exp (rand1 rand2)
            (let ((val1
                    (expval->num
		    (value-of rand1 env)))
        	  (val2
                    (expval->num
		    (value-of rand2 env))))
    	          (if (>= val1 val2)
	    	    (bool-val #t)
                    (bool-val #f)
              )))

         (equalTo-exp (rand1 rand2)
            (let ((val1
                    (expval->num
		    (value-of rand1 env)))
        	  (val2
                    (expval->num
		    (value-of rand2 env))))
    	          (if (equal? val1 val2)
	    	    (bool-val #t)
                    (bool-val #f)
              )))

          (notEqualTo-exp (rand1 rand2)
            (let ((val1
                    (expval->num
		    (value-of rand1 env)))
        	  (val2
                    (expval->num
		    (value-of rand2 env))))
    	          (if (equal? val1 val2)
	    	    (bool-val #f)
                    (bool-val #t)
              )))

        (proc-exp (var body)
          (proc-val (procedure var body env)))

        (call-exp (rator rand)
          (let ((proc (expval->proc (value-of rator env)))
                (arg (value-of rand env)))
            (apply-procedure proc arg)))
             
        )))

  (define apply-procedure
    (lambda (proc1 arg)
      (cases proc proc1
        (procedure (var body saved-env)
          (let ((r (newref arg)))
            (let ((new-env (extend-env var r saved-env)))
              (value-of body new-env)))))))  
  )