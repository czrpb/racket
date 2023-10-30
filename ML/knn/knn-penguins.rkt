#lang racket

(displayln "\nStarting ...\n")

(require plot)
(plot-new-window? #t)

(require [only-in "get-cmdline.rkt" k k2 centroid x y])

(require [only-in "utils.rkt"
                  x-floor x-ceiling y-floor y-ceiling
                  sort< list-sample pt-dist])

(require [only-in "penguin-data.rkt" the-data x-min x-max y-min y-max])

(define [hash-refs h ks] [foldl (lambda [k a] [hash-ref a k]) h ks])

(x-floor [exact-floor (x-min)])
(y-floor [exact-floor (y-min)])
(x-ceiling [exact-ceiling (x-max)])
(y-ceiling [exact-ceiling (y-max)])

(define [penguin-points str sym color]
  [list
   (points [map cdr (hash-refs the-data [list sym 'classify])]
           #:label str #:sym 'fullcircle #:color color #:size 10)
   (points [map cdr (hash-refs the-data [list sym 'remaining])]
           #:sym 'circle #:color color #:size 5)
   ]
  )
(define adelie-points [penguin-points "Adelie" 'adelie "red"])
(define gentoo-points [penguin-points "Gentoo" 'gentoo "green"])
(define chinstrap-points [penguin-points "Chinstrap" 'chinstrap "blue"])

(define centroid-points
  [let (
        [adelie-data (map cdr [hash-ref (hash-ref the-data 'adelie) 'centroid])]
        [gentoo-data (map cdr [hash-ref (hash-ref the-data 'gentoo) 'centroid])]
        [chinstrap-data (map cdr [hash-ref (hash-ref the-data 'chinstrap) 'centroid])]
        )
    (list
     [points adelie-data #:sym 'oasterisk #:color "red" #:size 20]
     [points gentoo-data #:sym 'oasterisk #:color "green" #:size 20]
     [points chinstrap-data #:sym 'oasterisk #:color "blue" #:size 20]
     )
    ]
  )

(define to-be-classified
  [let* (
         [gen-x (curry random [x-floor] [x-ceiling])]
         [gen-y (curry random [y-floor] [y-ceiling])]
         )
    (append
     (list [list (x) (y)] '[4175 45.9] '[2862 60])
     (for/list [(_ [range 10])] [list (gen-x) (gen-y)])
     ;'()
     )
    ])

(define [nearest-neighbors records k]
  (writeln records)
  (writeln k)
  (λ [unclassified]
    [let* ([sort-on-first (curryr sort< #:key first)]
           [pt-dist-to-unclassified
            (λ (pt) (cons [pt-dist unclassified (cdr pt)] pt))]
           [map-dist-to-unclassified (curry map pt-dist-to-unclassified)]
           [sorted-dist-to-unclassified (compose sort-on-first map-dist-to-unclassified)]
           [nn-records (sorted-dist-to-unclassified records)]
           [knn (take nn-records k)]
           )
      (printf "~a -> ~a\n" unclassified knn)
      knn
      ]
    )
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
       (to-classify-against
        [cond
          ([centroid] (displayln "Classifying against centroids....")
                      (k 1)
                      [append (hash-refs the-data '[adelie centroid])
                              (hash-refs the-data '[gentoo centroid])
                              (hash-refs the-data '[chinstrap centroid])])
          ([k2]
           (printf "Classifying against ~a random points....\n" [k2])
           (apply append
                  [map (curryr list-sample (k2))
                       (list [hash-refs the-data '(adelie classify)]
                             [hash-refs the-data '(gentoo classify)]
                             [hash-refs the-data '(chinstrap classify)])]))
          (else (displayln "Classifying against all points....")
                (hash-ref [hash-ref the-data 'csv] 'classify))
          ])
       (nn [nearest-neighbors to-classify-against [k]])

       (to-classify-nns [map nn to-be-classified])
       (to-classify-classified [map (compose penguin->color classify) to-classify-nns])
       (classified-points
        [map (λ (pt classification)
               ;  (points (list pt)
               ;          #:sym 'full6star #:color classification #:size 25)
               (point-label pt
                            #:point-sym 'full6star #:point-color classification #:point-size 25
                            #:size 7)
               )
             to-be-classified to-classify-classified])
       ]

  [plot (list adelie-points gentoo-points chinstrap-points classified-points centroid-points)
        #:width 1024 #:height 768
        #:x-min (x-min) #:x-max (x-max) #:x-label "Body Mass"
        #:y-min (y-min) #:y-max (y-max) #:y-label "Bill Length"
        ]

  [plot-file (list adelie-points gentoo-points chinstrap-points classified-points centroid-points)
             "penguins.png" 'png
             #:width 1024 #:height 768
             #:x-min (x-min) #:x-max (x-max) #:x-label "Body Mass"
             #:y-min (y-min) #:y-max (y-max) #:y-label "Bill Length"
             ]
  )
