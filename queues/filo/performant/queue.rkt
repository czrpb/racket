#lang racket

(define (queue) '())

(define (empty q) (equal? '() q))

(define (add e q) (cons e q))

(define (next q) (car q))

(define (remove q) (cdr q))

; ============================================================

(define input (shuffle (range 10)))

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