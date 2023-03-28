#lang racket

(define (queue) (list #f '() #f))

(define empty (curry equal? (queue)))

(define front first)
(define back third)

(define (add e q)
  (match q
    [(list #f '() #f) (list e '() #f)]
    [(list front '() #f) (list front '() e)]
    [(list front middle back) (list front (cons back middle) e)]
    )
  )

(define (next q) (front q))

(define (remove q) (list (back q) (cdr (front q))))

(define (last q) (back q))

(define (leave q) (list (cdr (back q)) (front q)))

; ============================================================

(define input (shuffle (range 10)))

(pretty-print input)

(define q (balance (foldl add (queue) input)))

(pretty-print q)

(define fb-pairs
  (reverse
   (let loop [(q q) (a '())]
     (if (empty q)
         a
         (loop
          (leave (remove q))
          (cons (cons (next q) (last q)) a))
         )
     )
   )
  )

(pretty-print fb-pairs)