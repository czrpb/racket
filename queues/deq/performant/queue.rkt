#lang racket

(define (queue) (list '() '()))

(define empty (curry equal? (queue)))

(define back first)
(define front second)

(define (balance q)
  (let-values [
               ((back front)
                (split-at (back q) (quotient (length (back q)) 2)))
               ]
    (list back (reverse front))
    )
  )

(define (add e q) (list (cons e (back q)) (front q)))

(define (next q) (car (front q)))

(define (remove q) (list (back q) (cdr (front q))))

(define (last q) (car (back q)))

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