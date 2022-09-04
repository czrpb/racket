#lang racket

(require racket/hash)

(provide etl)

(define (etl old)
  (let* (
         [not-empty? (negate empty?)]
         [letter-hash (lambda (score letters)
                        (if (nonnegative-integer? score)
                            (for/hash ([letter letters])
                              (values (string-downcase letter) score))
                            (raise (exn:fail:contract "Invalid score"))
                            ))]
         [converted-hash (hash-map old letter-hash)]
         )
    (if (not-empty? converted-hash)
        (apply hash-union converted-hash)
        (hash))
    ))


; Very cool community implementation:

; (provide etl)

; (define/contract (etl legacy-hash)
;   ((hash/c natural-number/c (listof string?)) . -> . (hash/c string? natural-number/c))
;   (for*/hash ([(key vs) (in-hash legacy-hash)]
;               [v (in-list vs)])
;     (values (string-downcase v) key)))

; https://exercism.org/tracks/racket/exercises/etl/solutions/mthom
