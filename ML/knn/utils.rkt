#lang racket

(provide x-floor x-ceiling y-floor y-ceiling
         sort< list-sample pt-dist centroid)

(define sort< [curryr sort <])
(define list-sample [λ (l n) (take [shuffle l] n)])

(define x-floor [make-parameter #f])   ;[exact-floor (x-min)])
(define y-floor [make-parameter #f])   ;[exact-floor (y-min)])
(define x-ceiling [make-parameter #f]) ;[exact-ceiling (x-max)])
(define y-ceiling [make-parameter #f]) ;[exact-ceiling (y-max)])
(define (x-range) [- (x-ceiling) (x-floor)])
(define (y-range) [- (y-ceiling) (y-floor)])
(define [x% x] [* (/ [- x (x-floor)] [x-range]) 100])
(define [y% y] [* (/ [- y (y-floor)] [y-range]) 100])

(define [pt-norm pt]
  [let ([x (first pt)] [y (second pt)])
    (list [x% x] [y% y])
    ])

(define pt-dist
  [compose
   sqrt
   (curry apply +)
   (curry map sqr)
   (curry map -)
   (λ [pt1 pt2] [values (pt-norm pt1) (pt-norm pt2)])])

(define pt-sum [curry map +])

(define [centroid pts]
  [map (curryr / (length pts))
       (foldl pt-sum '(0.0 0.0) pts)
       ]
  )
