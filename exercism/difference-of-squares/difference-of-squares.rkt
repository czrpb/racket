#lang racket

(provide sum-of-squares square-of-sum difference)

(define (sum-of-squares n)
  (let* ([ns (range 1 (add1 n))]
        [ns_squared (map sqr ns)]
        [ns_squared_summed (foldl + 0 ns_squared)])
    ns_squared_summed
    ))


(define (square-of-sum n)
  (let* ([ns (range 1 (add1 n))]
        [ns_summed (foldl + 0 ns)]
        [ns_summed_squared (sqr ns_summed)])
    ns_summed_squared
    ))

(define (difference n) (- (square-of-sum n) (sum-of-squares n)))