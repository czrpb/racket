#lang racket

(define (queue) '())

(define (empty q) (equal? '() q))

(define (add k-e q)
  (cond
    [(empty q) (list k-e)]
    [(< (first k-e) (first (next q))) (cons k-e q)]
    [else (cons (next q) (add k-e (remove q)))]
    )
  )

(define (next q) (car q))

(define (remove q) (cdr q))

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

(equal? input-sorted all)