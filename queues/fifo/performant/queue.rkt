#lang racket

(define (queue) '(() ()))

(define (empty q) (equal? '(() ()) q))

(define (add e q) [list (first q) (cons e (second q))])

(define (next q)
  [match q
    ((list '() back) (car (reverse back)))
    (_ (car (first q)))
    ]
  )

(define (remove q)
  [match q
    ([list '() back]
     [let-values ([(back new-front) (split-at back (quotient (length back) 2))])
       (list (cdr (reverse new-front)) back)
       ]
     )
    (_ (list (cdr (first q)) (second q)))
    ]
  )

; ============================================================

(define input (shuffle (range 10)))

(pretty-print input)

(define q (foldl add (queue) input))

(pretty-print q)

(define all (reverse
             (let loop [(q q) (a '())]
               (if (empty q)
                   a
                   (loop (remove q) (cons (next q) a))
                   )
               )
             )
  )

(pretty-print all)