#lang racket

(provide convert)

(define (convert n)
  (let* (
         [divby? (lambda (n) (lambda (x) (= (remainder x n) 0)))]
         [divby_sound
          (list
           (cons (divby? 3) "Pling") (cons (divby? 5) "Plang") (cons (divby? 7) "Plong"))]
         [divby?->sound (match-lambda [(cons d s) (if (d n) s "")])]
         )
    (match (string-append* (map divby?->sound divby_sound))
      ["" (number->string n)]
      [x x])
    ))
