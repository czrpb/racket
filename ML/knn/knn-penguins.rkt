#lang racket

(displayln "\nStarting ...\n")

(require plot)
(plot-new-window? #t)

(require [only-in "get-cmdline.rkt" x y])
(require [only-in "penguin-data.rkt" csv-data x-min x-max y-min y-max])

(define dist [compose (curry apply +) (curry map [compose abs -])])

(define [nearest-neighbor unclassified records (k 1)]
  [for/fold
   ([classification #f] [closest (add1 [x-max])] #:result classification)
   ([record records] #:do [(define d [dist unclassified (cdr record)])])
    (if [< closest d]
        (values classification closest)
        (values record d)
        )
    ])

(let* [
       (to-classify-data (list [list (x) (y)]))
       (to-classify [points to-classify-data #:sym 'full6star #:color "black"])

       (adelie? [compose (curry equal? "Adelie") car])
       (adelie-records [filter adelie? csv-data])
       (adelie-data [sort (map cdr adelie-records) < #:key car])
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
  (writeln to-classify-data)
  (writeln (nearest-neighbor (list [x] [y]) adelie-records))

  [plot (list adelie-points gentoo-points chinstrap-points to-classify)
        #:width 1024 #:height 768
        #:x-min (x-min) #:x-max (x-max) #:x-label "Body Mass"
        #:y-min (y-min) #:y-max (y-max) #:y-label "Bill Length"
        ]

  [plot-file (list adelie-points gentoo-points chinstrap-points to-classify)
             "penguins.png" 'png
             #:width 1024 #:height 768
             #:x-min (x-min) #:x-max (x-max) #:x-label "Body Mass"
             #:y-min (y-min) #:y-max (y-max) #:y-label "Bill Length"
             ]
  )
