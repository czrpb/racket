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

(define counter
  (make-hash
   (list '(add . 0) '(next . 0) '(remove . 0) '(meld . 0) '(loop . 0))
   )
  )


; O(1)
(define (meld q1 q2)
  (hash-update! counter 'meld add1)
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

; O(1)
(define (add k-d q)
  (hash-update! counter 'add add1)
  (meld (element (first k-d) (second k-d)) q)
  )

; O(1)
(define (next q)
  (hash-update! counter 'next add1)
  (element-data q)
  )

; O(log2 n)
(define (remove q)
  (hash-update! counter 'remove add1)
  (let loop [(children (element-children q))]
    (hash-update! counter 'loop add1)
    (match children
      ['() '()]
      [(list q) q]
      [(list q1 q2 children ...) (meld (meld q1 q2) (loop children))]
      )
    )
  )

; ============================================================
; (define input '((0 20) (1 21) (2 22) (3 23) (4 24) (5 25) (6 26) (7 27) (8 28) (9 29)))
; (define input '((9 29) (8 28) (7 27) (6 26) (5 25) (4 24) (3 23) (2 22) (1 21) (0 20)))
; (define input '((4 17) (7 19) (6 12) (2 13) (3 18) (5 14) (9 15) (1 10) (8 11) (0 16)))
; (define input '((8 16) (6 15) (4 18) (3 19) (5 11) (0 13) (9 17) (7 10) (2 14) (1 12)))
; (define input '((6 17) (9 12) (3 19) (8 13) (7 16) (1 15) (2 10) (0 14) (4 18) (5 11)))

(define input
  (for/list [(k (shuffle (range 10))) (e (shuffle (range 10 20)))]
    (list k e)
    )
  )

(pretty-print (list "input:" input))

(define input-sorted (sort input < #:key car))

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

(displayln (format "counts => add: ~a, next: ~a, remove: ~a, loop: ~a, meld: ~a"
                   (hash-ref counter 'add) (hash-ref counter 'next)
                   (hash-ref counter 'remove) (hash-ref counter 'loop)
                   (hash-ref counter 'meld)
                   )
           )