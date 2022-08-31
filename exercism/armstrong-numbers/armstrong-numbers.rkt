#lang racket

(provide armstrong-number?)

(define (armstrong-number? n)
  (define/match (f n digits_count)
    [(0 _) digits_count]
    [(_ _) (let (
                 [q (quotient n 10)]
                 [r (remainder n 10)]
                 [digits (car digits_count)]
                 [count (cdr digits_count)])
             (f q (cons (cons r digits) (add1 count)))
             )])
  (let* (
         [digits_count (f n (cons '() 0))]
         [digits (car digits_count)]
         [count (cdr digits_count)])
    (= n (for/sum ([d digits]) (expt d count))))
  )
