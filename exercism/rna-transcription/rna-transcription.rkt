#lang racket

(require srfi/13)

(provide to-rna)

(define (to-rna dna)
  (let ([dna-to-rna (hash #\G #\C #\C #\G #\T #\A #\A #\U)])
    ; (apply string
    ;        (for/list ([nuc dna]) (hash-ref dna-to-rna nuc)))
    ; (apply string (map
    ;                (match-lambda [#\G #\C] [#\C #\G] [#\T #\A] [#\A #\U])
    ;                (string->list dna)))
    (string-map (match-lambda [#\G #\C] [#\C #\G] [#\T #\A] [#\A #\U]) dna)
    ))