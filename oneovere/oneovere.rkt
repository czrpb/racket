#lang racket

(require relation/function)

(define (y x)
  (* (- x) (log x)))

(define times1000-to-integer
  (f #:thread? #t
     (lambda (n) (* n 1000)) floor inexact->exact))

(for ([x (range 0.0005 1 0.01)])
  (printf "~a -> ~a\n" (~r #:precision 2 x) (times1000-to-integer (y x))))

(for ([x (range 0.0005 1 0.01)])
  (printf "~a, " (times1000-to-integer (y x))))

(printf "\n")