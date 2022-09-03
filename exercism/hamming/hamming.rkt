#lang racket

(provide hamming-distance)

(define (hamming-distance strand1 strand2)
  (if (= (string-length strand1)(string-length strand2))
      (for/sum ([s1 strand1] [s2 strand2])
        (if (equal? s1 s2) 0 1))
      (error "Strands are of different length")
      ))
