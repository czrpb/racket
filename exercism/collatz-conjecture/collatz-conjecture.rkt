#lang racket

(provide collatz)

(define (collatz n)
  (if (or ((negate natural?) n) (zero? n))
      (error "Invalid input")
      (letrec ([n/2 (lambda (n) (/ n 2))]
               [3n+1 (lambda (n) (add1 (* n 3)))]
               [collatz (lambda (n c)
                          (cond
                            [(= n 1) c]
                            [(even? n) (collatz (n/2 n) (add1 c))]
                            [else (collatz (3n+1 n) (add1 c))]))])
        (collatz n 0)
        )))
