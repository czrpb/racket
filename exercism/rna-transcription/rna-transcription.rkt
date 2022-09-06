#lang racket

(provide to-rna)

(define (to-rna dna)
  (let ([dna-to-rna (hash #\G #\C #\C #\G #\T #\A #\A #\U)])
    (apply string
           (for/list ([nuc dna]) (hash-ref dna-to-rna nuc)))
    ))