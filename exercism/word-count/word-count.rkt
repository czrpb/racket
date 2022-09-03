#lang racket

(provide word-count)

(define (word-count phrase)
  (let ([string-or-false (match-lambda ["" #f] [s s])]
        [hash-update!-count
         (lambda (k h) (hash-update h k add1 0))]
        [string-trim-puncuation (lambda (s) (string-trim s #px"[-_'!@$%^&]+"))])
    (foldl hash-update!-count (hash)
           (filter-map (compose string-or-false string-trim-puncuation string-downcase)
                       (string-split phrase #px"[\n\\s.,\":]+")))
    ))
