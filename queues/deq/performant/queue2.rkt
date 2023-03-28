#lang racket

(define (queue) (list #f '() #f))

(define empty (curry equal? (queue)))

(define front first)
(define back third)

(define (add e q)
  (match q
    [(list #f '() #f) (list e '() #f)]
    [(list front '() #f) (list front '() e)]
    [(list front middle back) (list front (cons back middle) e)]
    )
  )

(define (next q) (front q))

(define (remove q)
  (match q
    [(list front '() #f) (queue)]
    [(list front '() back) (list back '() #f)]
    [(list front middle back)
     (let [(elddim (reverse middle))]
       (list (car elddim) (reverse (cdr elddim)) back))
     ]
    )
  )

(define (last q) (back q))

(define (leave q) (list (cdr (back q)) (front q)))

; ============================================================

(define input (shuffle (range 10)))

(pretty-print input)

(pretty-print q)

(define fb-pairs
  (reverse
   (let loop [(q q) (a '())]
     (if (empty q)
         a
         (loop
          (leave (remove q))
          (cons (cons (next q) (last q)) a))
         )
     )
   )
  )

(pretty-print fb-pairs)