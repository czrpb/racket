#lang racket

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

(define input
  (for/list [(k (shuffle (range 10))) (e (shuffle (range 10 20)))]
    (list k e)
    )
  )

(pretty-print input)
(pretty-print (sort input < #:key car))

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