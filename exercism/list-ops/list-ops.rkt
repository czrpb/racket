#lang racket

(provide my-length
         my-reverse
         my-map
         my-filter
         my-fold
         my-append
         my-concatenate)

(define (my-length sequence)
  (letrec [(len (match-lambda**
                 [('() l) l]
                 [(sequence l) (len (cdr sequence) (add1 l))]
                 ))]
    (len sequence 0)
    ))

(define (my-reverse sequence)
  (let loop [(sequence sequence) (reversed '())]
    (case sequence
      ['() reversed]
      [else (loop (cdr sequence) (cons (car sequence) reversed))]
      )
    ))

(define (my-map operation sequence)
  (for/list [(item sequence)]
    (operation item)
    ))

(define (my-filter operation? sequence)
  (error "Not implemented yet"))

(define (my-fold operation accumulator sequence)
  (error "Not implemented yet"))

(define (my-append sequence1 sequence2)
  (error "Not implemented yet"))

(define (my-concatenate sequence-of-sequences)
  (error "Not implemented yet"))
