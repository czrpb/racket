#lang racket

(provide collatz)

(define (collatz n)
  (if (not (positive-integer? n))
      (error "Invalid input")
      (letrec ([1? (lambda (n) (= n 1))]
               [c+1 add1]
               [n/2 (lambda (n) (/ n 2))]
               [3n+1 (lambda (n) (add1 (* n 3)))]
               [collatz (lambda (n c)
                          (cond
                            [(1? n) c]
                            [(even? n) (collatz (n/2 n) (c+1 c))]
                            [else (collatz (3n+1 n) (c+1 c))]))])
        (collatz n 0)
        )))
