#lang racket

(displayln "\nStarting ...\n")

(require plot)
(plot-new-window? #t)

(require "penguin-data.rkt")

(define x-min [make-parameter #f])
(define x-max [make-parameter #f])
(define y-min [make-parameter #f])
(define y-max [make-parameter #f])

(x-min [cadar csv-data])
(x-max [cadar csv-data])
(y-min [caddar csv-data])
(y-max [caddar csv-data])
(for [(record csv-data)]
  [let ([x (second record)] [y (third record)])
    (cond
      [(< x (x-min)) (x-min [- x 50])]
      [(< (x-max) x) (x-max [+ x 50])]
      )
    (cond
      [(< y (y-min)) (y-min [- y 5])]
      [(< (y-max) y) (y-max [+ y 5])]
      )
    ])
(writeln (y-max))

(let* [
       (adelie? [compose (curry equal? "Adelie") car])
       (adelie-data [sort (map cdr [filter adelie? csv-data]) < #:key car])
       (adelie-points [points adelie-data #:label "Adelie" #:sym 'fullcircle #:color "red"])

       (gentoo? [compose (curry equal? "Gentoo") car])
       (gentoo-data [sort (map cdr [filter gentoo? csv-data]) < #:key car])
       (gentoo-points [points gentoo-data #:label "Gentoo" #:sym 'fullsquare #:color "green"])

       (chinstrap? [compose (curry equal? "Chinstrap") car])
       (chinstrap-data [sort (map cdr [filter chinstrap? csv-data]) < #:key car])
       (chinstrap-points [points chinstrap-data #:label "Chinstrap" #:sym 'fulltriangle #:color "blue"])
       ]
  (writeln adelie-data)
  (writeln gentoo-data)
  (writeln chinstrap-data)

  [plot (list adelie-points gentoo-points chinstrap-points)
        #:width 1024 #:height 768
        #:x-min (x-min) #:x-max (x-max) #:x-label "Body Mass"
        #:y-min (y-min) #:y-max (y-max) #:y-label "Bill Length"
        ]

  [plot-file (list adelie-points gentoo-points chinstrap-points)
             "penguins.png" 'png
             #:width 1024 #:height 768
             #:x-min (x-min) #:x-max (x-max) #:x-label "Body Mass"
             #:y-min (y-min) #:y-max (y-max) #:y-label "Bill Length"
             ]
  )
