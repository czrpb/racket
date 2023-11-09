#lang racket

(displayln "\nStarting ...\n")

(require math/statistics)
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
   (map [λ (pt)
          (point-label pt #:size 7
                       #:point-sym 'fullcircle #:point-color color #:point-size 10
                       )]
        [map cdr (hash-refs the-data [list sym 'classify])])
   ;  (points [map cdr (hash-refs the-data [list sym 'classify])]
   ;          #:label str #:sym 'fullcircle #:color color #:size 10)
   (points [map cdr (hash-refs the-data [list sym 'remaining])]
           #:label str #:sym 'circle #:color color #:size 5)
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
     [point-label [car adelie-data]
                  #:size 7
                  #:point-sym 'oasterisk #:point-color "red" #:point-size 20]
     [point-label [car gentoo-data]
                  #:size 7
                  #:point-sym 'oasterisk #:point-color "green" #:point-size 20]
     [point-label [car chinstrap-data]
                  #:size 7
                  #:point-sym 'oasterisk #:point-color "blue" #:point-size 20]
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
     (for/list [(_ [range 25])] [list (gen-x) (gen-y)])
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
  [let* (
         [reduced (map [curryr take 2] nns)]
         [hashed (foldl [λ (p h) (hash-update h (second p) (curry cons [first p]) '())]
                        [hash] reduced)]
         [variances (for/list [([k v] hashed)] [list k (if [= 1 (length v)] [* 100 (car v)] [variance v])])]
         [nonzero-variances (filter [compose (negate zero?) second] variances)]
         [sorted (sort nonzero-variances < #:key second)]
         [result (first sorted)]
         )
    (writeln reduced)
    (writeln hashed)
    (writeln variances)
    (writeln nonzero-variances)
    (writeln sorted)
    (writeln "")
    (first result)
    ])

(define [penguin->color p]
  [match p
    ("Adelie" "red")
    ("Gentoo" "green")
    ("Chinstrap" "blue")
    (_ "black")
    ])

(define output-filename-id [format "~a-~a-~a" (k) (k2) (centroid)])

(let* [
       (to-classify-against
        [cond
          ([centroid] (displayln "Classifying against centroids....")
                      (k 3)
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
               (point-label pt #:size 9
                            #:point-sym 'full6star #:point-color classification #:point-size 25)
               )
             to-be-classified to-classify-classified])
       ]

  [plot (list adelie-points gentoo-points chinstrap-points classified-points centroid-points)
        #:width 1024 #:height 768
        #:x-min (x-min) #:x-max (x-max) #:x-label "Body Mass"
        #:y-min (y-min) #:y-max (y-max) #:y-label "Bill Length"
        ]

  [plot-file (list adelie-points gentoo-points chinstrap-points classified-points centroid-points)
             (format "penguins-~a.png" output-filename-id) 'png
             #:width 1024 #:height 768
             #:x-min (x-min) #:x-max (x-max) #:x-label "Body Mass"
             #:y-min (y-min) #:y-max (y-max) #:y-label "Bill Length"
             ]
  )
