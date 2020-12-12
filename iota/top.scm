(module top (lib "eopl.ss" "eopl")
  
  ;; top level module.  Loads all required pieces.

  (require "drscheme-init.scm")
  (require "data-structures.scm")       ; for expval constructors
  (require "lang.scm")                  ; for scan&parse
  (require "interp.scm")                ; for value-of-program
  (require "tests.scm")


  ;;;;;;;;;;;;;;;; interface to test harness ;;;;;;;;;;;;;;;;

  (define run
    (lambda (string)
      (value-of-program (scan&parse string))))
  
    (define run-num
      (lambda ()
        (run (car nums))))

      (define run-str
      (lambda ()
        (run (car str))))

      (define run-trueFalse
      (lambda ()
        (run (car trueFalse))))
  
      (define run-list
      (lambda ()
        (run (car list))))

      (define run-zero
      (lambda ()
        (run (car zero))))

      (define run-null
      (lambda ()
        (run (car null))))

      (define run-bool
      (lambda ()
        (run (car bool))))
  
      (define run-math
      (lambda ()
        (run (car math))))
  
      (define run-let
      (lambda ()
        (run (car let))))
  
      (define run-inequal
      (lambda ()
        (run (car inequal))))
  
      (define run-if
      (lambda ()
        (run (car if))))
  
      (define run-while
      (lambda ()
        (run (car while)))) 

     (define run-complex
      (lambda ()
        (run (car complex))))
  )
