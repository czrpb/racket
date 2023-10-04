#lang racket

(displayln "\nStarting ...\n")

(require plot)
(plot-new-window? #t)

(require [only-in "get-cmdline.rkt" x y])
(require [only-in "penguin-data.rkt" csv-data x-min x-max y-min y-max])

(x-min [exact-floor (x-min)])
(y-min [exact-floor (y-min)])
(x-max [exact-ceiling (x-max)])
(y-max [exact-ceiling (y-max)])
(define x-range [- (x-max) (x-min)])
(define y-range [- (y-max) (y-min)])
(define [x% x] [* (/ [- x (x-min)] x-range) 100])
(define [y% y] [* (/ [- y (y-min)] y-range) 100])

(define to-be-classified
  [let* (
         [gen-x (curry random [x-min] [x-max])]
         [gen-y (curry random [y-min] [y-max])]
         )
    (append
     (list [list (x) (y)] '[4175.01 45.89] '[2862 60])
     (for/list [(_ [range 10])] [list (gen-x) (gen-y)]))
    ;    (list '[2862 60])
    ]
  )

(define sort< [curryr sort <])

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

(define [nearest-neighbors unclassified records (k 1)]
  [let* ([sort-on-first (curryr sort< #:key first)]
         [pt-dist-to-unclassified
          (λ (pt) (cons [pt-dist unclassified (cdr pt)] pt))]
         [map-dist-to-unclassified (curry map pt-dist-to-unclassified)]
         [sorted-dist-to-unclassified (compose sort-on-first map-dist-to-unclassified)]
         (nn-records [sorted-dist-to-unclassified records])
         )
    (writeln nn-records)
    (take nn-records k)
    ]
  )

(define [classify nns]
  [cadaar(group-by second nns)]
  )

(define [penguin->color p]
  [match p
    ("Adelie" "red")
    ("Gentoo" "green")
    ("Chinstrap" "blue")
    (_ "black")
    ])

(let* [
       (to-classify-data to-be-classified)
       (to-classify-nns
        [map (curryr nearest-neighbors csv-data 5) to-classify-data])
       (to-classify-classified [map (compose penguin->color classify) to-classify-nns])
       (classified-points
        [map (λ (pt classification)
               [points (list pt) #:sym 'full6star #:color classification #:size 15])
             to-classify-data to-classify-classified])

       (adelie? [compose (curry equal? "Adelie") car])
       (adelie-records [filter adelie? csv-data])
       (adelie-data [sort (map cdr adelie-records) < #:key car])
       (adelie-points [points adelie-data #:label "Adelie" #:sym 'fullcircle #:color "red"])

       (gentoo? [compose (curry equal? "Gentoo") car])
       (gentoo-records [filter gentoo? csv-data])
       (gentoo-data [sort (map cdr gentoo-records) < #:key car])
       (gentoo-points [points gentoo-data #:label "Gentoo" #:sym 'fullsquare #:color "green"])

       (chinstrap? [compose (curry equal? "Chinstrap") car])
       (chinstrap-records [filter chinstrap? csv-data])
       (chinstrap-data [sort (map cdr chinstrap-records) < #:key car])
       (chinstrap-points [points chinstrap-data #:label "Chinstrap" #:sym 'fulltriangle #:color "blue"])
       ]
  (writeln adelie-data)
  (writeln gentoo-data)
  (writeln chinstrap-data)
  (writeln to-classify-data)
  (writeln to-classify-nns)

  [plot (list adelie-points gentoo-points chinstrap-points classified-points)
        #:width 1024 #:height 768
        #:x-min (x-min) #:x-max (x-max) #:x-label "Body Mass"
        #:y-min (y-min) #:y-max (y-max) #:y-label "Bill Length"
        ]

  [plot-file (list adelie-points gentoo-points chinstrap-points classified-points)
             "penguins.png" 'png
             #:width 1024 #:height 768
             #:x-min (x-min) #:x-max (x-max) #:x-label "Body Mass"
             #:y-min (y-min) #:y-max (y-max) #:y-label "Bill Length"
             ]
  )
