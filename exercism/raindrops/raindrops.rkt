#lang racket

(provide convert)

(define (convert n)
  (let* (
         [mod (lambda (n) (lambda (x) (= (remainder x n) 0)))]
         [mods (list (mod 3) (mod 5) (mod 7))]
         [sounds '("Pling" "Plang" "Plong")]
         )
    (match
        (for/fold
         ([r ""])
         ([m mods] [s sounds])
          (string-append r (if (m n) s "")))
      ["" (number->string n)]
      [x x]
      )))
      