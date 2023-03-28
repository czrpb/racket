#lang racket

; #####
; ##     This queue is implemented using a binary tree
; #####

(define (queue) '())

(define (empty q) (equal? '() q))

(define (element key data (left '()) (right '())) (list key data left right))
(define (element-key e) (first e))
(define (element-data e) (second e))
(define (element-left e) (third e))
(define (element-right e) (fourth e))


(define (add k-d q) (meld (element (first k-d) (second k-d)) q))

(define (next q) (element-data q))

(define (remove q)
  (let loop [(children (element-children q))]
    (match children
      ['() '()]
      [(list q) q]
      [(list q1 q2 children ...) (meld (meld q1 q2) (loop children))]
      )
    )
  )

; ============================================================
; '((4 17) (7 19) (6 12) (2 13) (3 18) (5 14) (9 15) (1 10) (8 11) (0 16))

(define input
  (for/list [(k (shuffle (range 10))) (e (shuffle (range 10 20)))]
    (list k e)
    )
  )

(define input-sorted (sort input < #:key car))

(pretty-print input)
(pretty-print input-sorted)

(define q (foldl add (queue) input))

(pretty-print q)

(define all
  (reverse
   (let loop [(q q) (a '())]
     (if (empty q)
         a
         (loop (remove q) (cons (next q) a))
         )
     )
   )
  )

(pretty-print all)

(equal? (map second input-sorted) all)