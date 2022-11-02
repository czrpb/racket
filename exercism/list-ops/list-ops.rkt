#lang racket

(provide my-length
         my-reverse
         my-map
         my-filter
         my-fold
         my-append
         my-concatenate)

(define (my-length sequence)
  (let [(len 0)]
    (do
        [(sequence sequence (cdr sequence))]
      [(empty? sequence) len]
      (set! len (add1 len))
      )
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
  (let loop [(sequence sequence) (new-sequence '())]
    (if [empty? sequence]
        (reverse new-sequence)
        (loop (cdr sequence) (if (operation? (car sequence))
                                 (cons (car sequence) new-sequence)
                                 new-sequence))
        )))

(define (my-fold operation accumulator sequence)
  (error "Not implemented yet"))

(define (my-append sequence1 sequence2)
  (error "Not implemented yet"))

(define (my-concatenate sequence-of-sequences)
  (error "Not implemented yet"))
