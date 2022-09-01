#lang racket

(provide convert)

(define (convert n)
  (let* (
         [divby? (lambda (n) (lambda (x) (= (remainder x n) 0)))]
         [divby357 (list (divby? 3) (divby? 5) (divby? 7))]
         [sounds '("Pling" "Plang" "Plong")]
         )
    (match
        (for/fold
         ([r ""])
         ([divby? divby357] [s sounds])
          (string-append r (if (divby? n) s "")))
      ["" (number->string n)]
      [x x]
      )))
      