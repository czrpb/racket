#lang racket

(require relation/function)

(provide sum-of-squares square-of-sum difference)

(define (sum-of-squares n)
  (for/sum ([ns (range 1 (add1 n))]) (sqr ns))
  )


(define square-of-sum
  (f #:thread? #t
     add1 (curry range 1) (curry apply +) sqr)
  )

(define (difference n) (- (square-of-sum n) (sum-of-squares n)))
