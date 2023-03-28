#lang racket

(define (queue) '(() . ()))

(define empty (curry equal? (queue)))

(define back car)
(define front cdr)

(define (add e q) (cons (cons e (back q)) (front q)))

(define (next q) (car (front q)))

(define (remove q)
  (match q
    [(cons back '())
     (let-values [
                  ((back front)
                   (split-at back (quotient (length back) 2)))
                  ]
       (cons back (cdr front))
       )]
    [(cons back front) (cons back (cdr front))]
    )
  )

(define (last q) (car (back q)))

(define (leave q) (cons (cdr (back q)) (front q)))

; ============================================================

(define input (shuffle (range 10)))

(pretty-print input)

(define q (foldl add (queue) input))

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