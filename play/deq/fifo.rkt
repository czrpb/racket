#lang racket


(define (front q)
  (let [(front (car q)) (back (cadr q))]
    (if (empty? front)
        (car (reverse back))
        (car front)
        )
    )
  )

(define (arrive q v)
  (let [(front (car q)) (back (cadr q))]
    (list front (cons v back))
    )
  )

(define (depart q)
  (let [(front (car q)) (back (cadr q))]
    (if (empty? front)
        (let-values [((back front) (split-at back (quotient (length back) 2)))]
          (list (cdr (reverse front)) back)
          )
        (list (cdr front) back)
        )
    )
  )

(let loop [(c 10) (i 7) (q '((1 2 3) (6 5 4)))]
  (displayln q)
  (if (zero? c)
      q
      (loop (sub1 c) (add1 i) (if (zero? (random 0 2)) (arrive q i) (depart q)))
      )
  )