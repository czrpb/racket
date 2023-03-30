#lang racket

(define counter (make-hash (list '(add . 0) '(next . 0) '(remove . 0))))

(define (queue) '())

(define (empty q) (equal? '() q))

; O(n)
(define (add k-e q)
  (hash-update! counter 'add add1)
  (cond
    [(empty q) (list k-e)]
    [(< (first k-e) (first (next q #f))) (cons k-e q)]
    [else (cons (next q #f) (add k-e (remove q #f)))]
    )
  )

; O(1)
(define (next q (measure #t))
  (and measure (hash-update! counter 'next add1))
  (car q)
  )

; O(1)
(define (remove q (measure #t))
  (and measure (hash-update! counter 'remove add1))
  (cdr q)
  )

; ============================================================
; (define input '((0 20) (1 21) (2 22) (3 23) (4 24) (5 25) (6 26) (7 27) (8 28) (9 29)))
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

(equal? input-sorted all)

(displayln (format "counts => add: ~a, next: ~a, remove: ~a"
                   (hash-ref counter 'add) (hash-ref counter 'next) (hash-ref counter 'remove)
                   )
           )