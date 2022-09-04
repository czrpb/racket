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
