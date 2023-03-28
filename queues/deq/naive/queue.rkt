#lang racket

(define (queue) '())

(define empty empty?)

(define (add e q) (cons e q))

(define (next q) (car (reverse q)))

(define (remove q) (reverse (cdr (reverse q))))

(define (last q) (car q))

(define (leave q) (cdr q))

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