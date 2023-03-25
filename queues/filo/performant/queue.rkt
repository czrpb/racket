#lang racket

(define (queue) '())

(define (add e q) (cons e q))

(define (next q) (car q))

(define (remove q) (cdr q))

; ============================================================

(define input (shuffle (range 10)))

(define q (foldl add (queue) input))

(pretty-print q)