#lang racket

(provide hamming-distance)

(define (hamming-distance strand1 strand2)
  (if (= (string-length strand1)(string-length strand2))
      (for/sum ([s1 strand1] [s2 strand2])
        (if (equal? s1 s2) 0 1))
      (error "Strands are of different length")
      ))

;Fantastic solution from the community:

;  (define (hamming-distance str1 str2)
;    (count (negate equal?)
;           (string->list str1)
;           (string->list str2)))

;  count -> (length (filter-map ...))
;  https://docs.racket-lang.org/reference/pairs.html#%28def._%28%28lib._racket%2Flist..rkt%29._count%29%29