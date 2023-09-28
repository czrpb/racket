#lang racket

(displayln "\nStarting ...\n")

(require plot)
(plot-new-window? #t)

(require "penguin-data.rkt")

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
