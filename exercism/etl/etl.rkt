#lang racket

(provide etl)

(define (etl old)
  (for*/hash ([(score letters) old]
              #:do [(or (nonnegative-integer? score)
                        (raise (exn:fail:contract "Invalid score" (current-continuation-marks))))]
              [letter letters])
    (values (string-downcase letter) score)
    )
  )

; Very cool community implementation:

; (provide etl)

; (define/contract (etl legacy-hash)
;   ((hash/c natural-number/c (listof string?)) . -> . (hash/c string? natural-number/c))
;   (for*/hash ([(key vs) (in-hash legacy-hash)]
;               [v (in-list vs)])
;     (values (string-downcase v) key)))

; https://exercism.org/tracks/racket/exercises/etl/solutions/mthom
