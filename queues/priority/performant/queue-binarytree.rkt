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


; O(log2 n)
(define (add k-d q)
  (cond
    [(empty q) (element (first k-d) (second k-d))]
    [(< (first k-d) (element-key q)) (element (element-key q) (element-data q) (add k-d (element-left q)) (element-right q))]
    [else (element (element-key q) (element-data q) (element-left q) (add k-d (element-right q)))]
    )
  )

; O(log2 n)
(define (next q)
  (if (empty (element-left q))
      (element-data q)
      (next (element-left q))
      )
  )

; O(log2 n)
(define (remove q)
  (cond
    [(and (empty (element-left q)) (empty (element-right q))) '()]
    [(empty (element-left q)) (element-right q)]
    [else (element (element-key q) (element-data q) (remove (element-left q)) (element-right q))]
    )
  )

; ============================================================
; (define input '((4 17) (7 19) (6 12) (2 13) (3 18) (5 14) (9 15) (1 10) (8 11) (0 16)))
(define input '((8 16) (6 15) (4 18) (3 19) (5 11) (0 13) (9 17) (7 10) (2 14) (1 12)))

; (define input
;   (for/list [(k (shuffle (range 10))) (e (shuffle (range 10 20)))]
;     (list k e)
;     )
;   )

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