#lang racket

(require relation/function)

(provide classify)

(define (factors n)
  (let ([nums2n (range 1 (add1 (quotient n 2)))] [factor? (lambda (x) (zero? (remainder n x)))])
    (filter factor? nums2n)))

(define sum (partial apply +))

(define (classify n)
  (let*
      ([factors (factors n)] [sum (sum factors)])
    (cond
      [(= n sum) 'perfect]
      [(< n sum) 'abundant]
      [(< sum n) 'deficient]
      [else 'na])
    ))