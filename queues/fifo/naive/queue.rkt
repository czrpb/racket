#lang racket

(define (queue) '())

(define (empty q) (equal? '() q))

(define (add e q) (cons e q))

(define (next q) (car (reverse q)))

(define (remove q) (reverse (cdr (reverse q))))

; ============================================================

(define input (shuffle (range 10)))

(pretty-print input)

(define q (foldl add (queue) input))

(pretty-print q)

(define all (reverse
             (let loop [(q q) (a '())]
               (if (empty q)
                   a
                   (loop (remove q) (cons (next q) a))
                   )
               )
             )
  )

(pretty-print all)