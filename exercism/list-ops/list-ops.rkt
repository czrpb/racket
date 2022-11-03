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
  (letrec
      [
       (op (λ (item acc) (operation item acc)))
       (loop (λ (accumulator sequence)
               (if (empty? sequence)
                   accumulator
                   (loop (op (car sequence) accumulator) (cdr sequence)))))
       ]
    (loop accumulator sequence)
    ))

(define (my-append sequence1 sequence2)
  (let loop [(sequence1 (reverse sequence1)) (new-sequence sequence2)]
    (if (empty? sequence1)
        new-sequence
        [loop (cdr sequence1) (cons (car sequence1) new-sequence)]
        )))

(define (my-concatenate sequence-of-sequences)
  (if [empty? sequence-of-sequences]
      '()
      (my-fold my-append '() (reverse sequence-of-sequences))
      ))
