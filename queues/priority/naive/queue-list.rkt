#lang racket

(define counter
  (make-hash
   (list
    '(add . 0) '(next . 0) '(remove . 0)
    '(next-loop . 0) '(remove-loop . 0)
    )
   )
  )

(define (queue) '())

(define (empty q) (equal? '() q))

; O(1)
(define (add k-e q)
  (hash-update! counter 'add add1)
  (cons k-e q)
  )

; O(n)
(define (next q)
  ;(car (sort q < #:key first))
  (hash-update! counter 'next add1)
  (let loop [(q (cdr q)) (min (car q))]
    (hash-update! counter 'next-loop add1)
    (cond
      [(empty q) min]
      [(< (caar q) (car min)) (loop (cdr q) (car q))]
      [else (loop (cdr q) min)]
      )
    )
  )

; O(n)
(define (remove q)
  ;(cdr (sort q < #:key first))
  (hash-update! counter 'remove add1)
  (let loop [(q (cdr q)) (min (car q)) (new-q '())]
    (hash-update! counter 'remove-loop add1)
    (cond
      [(empty q) new-q]
      [(< (caar q) (car min))
       (loop (cdr q) (car q) (cons min new-q))]
      [else (loop (cdr q) min (cons (car q) new-q))]
      )
    )
  )

; ============================================================
; (define input '((0 20) (1 21) (2 22) (3 23) (4 24) (5 25) (6 26) (7 27) (8 28) (9 29)))
; (define input '((4 17) (7 19) (6 12) (2 13) (3 18) (5 14) (9 15) (1 10) (8 11) (0 16)))
; (define input '((8 16) (6 15) (4 18) (3 19) (5 11) (0 13) (9 17) (7 10) (2 14) (1 12)))
; (define input '((6 17) (9 12) (3 19) (8 13) (7 16) (1 15) (2 10) (0 14) (4 18) (5 11)))

(define key-range 100000)

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

(displayln
 (format
  "counts => add: ~a, next: ~a, next-loop: ~a, remove: ~a, remove-loop: ~a"
  (hash-ref counter 'add)
  (hash-ref counter 'next)  (hash-ref counter 'next-loop)
  (hash-ref counter 'remove) (hash-ref counter 'remove-loop)
  )
 )