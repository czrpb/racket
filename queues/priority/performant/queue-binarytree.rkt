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

(define counter (make-hash (list '(add . 0) '(next . 0) '(remove . 0))))

; O(log2 n)
(define (add k-d q)
  (hash-update! counter 'add add1)
  (cond
    [(empty q) (element (first k-d) (second k-d))]
    [(< (first k-d) (element-key q))
     (element (element-key q) (element-data q) (add k-d (element-left q)) (element-right q))]
    [else (element (element-key q) (element-data q) (element-left q) (add k-d (element-right q)))]
    )
  )

; O(log2 n)
(define (next q)
  (hash-update! counter 'next add1)
  (if (empty (element-left q))
      (element-data q)
      (next (element-left q))
      )
  )

; O(log2 n)
(define (remove q)
  (hash-update! counter 'remove add1)
  (cond
    [(and (empty (element-left q)) (empty (element-right q))) '()]
    [(empty (element-left q)) (element-right q)]
    [else
     (element
      (element-key q)
      (element-data q)
      (remove (element-left q)) (element-right q))]
    )
  )

; ============================================================
; (define input '((0 20) (1 21) (2 22) (3 23) (4 24) (5 25) (6 26) (7 27) (8 28) (9 29)))
; (define input '((9 29) (8 28) (7 27) (6 26) (5 25) (4 24) (3 23) (2 22) (1 21) (0 20)))
; (define input '((4 17) (7 19) (6 12) (2 13) (3 18) (5 14) (9 15) (1 10) (8 11) (0 16)))
; (define input '((8 16) (6 15) (4 18) (3 19) (5 11) (0 13) (9 17) (7 10) (2 14) (1 12)))
; (define input '((6 17) (9 12) (3 19) (8 13) (7 16) (1 15) (2 10) (0 14) (4 18) (5 11)))

(define key-range 1000)

(define input
  (for/list [
             (k (shuffle (range key-range)))
             (e (shuffle (range (* key-range 5) (* key-range 6))))]
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

(displayln (format "counts => add: ~a, next: ~a, remove: ~a"
                   (hash-ref counter 'add) (hash-ref counter 'next) (hash-ref counter 'remove)
                   )
           )