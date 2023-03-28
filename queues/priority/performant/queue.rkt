#lang racket

; #####
; ##     This queue is implemented using a pairing heap
; #####

(define (queue) '())

(define (empty q) (equal? '() q))

(define (element key data (children '())) (list key data children))
(define (element-key e) (first e))
(define (element-data e) (second e))
(define (element-children e) (third e))

(define (meld q1 q2)
  (cond
    [(empty q1) q2]
    [(empty q2) q1]
    [(< (element-key q1) (element-key q2))
     (element (element-key q1) (element-data q1) (cons q2 (element-children q1)))]
    [else
     (element (element-key q2) (element-data q2) (cons q1 (element-children q2)))
     ]
    )
  )

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
; '((8 16) (6 15) (4 18) (3 19) (5 11) (0 13) (9 17) (7 10) (2 14) (1 12))

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