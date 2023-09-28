#lang racket

(displayln "\nStarting ...\n")

(require plot)
(plot-new-window? #t)

; Parameters
(define field-nums (make-parameter #f))
(define csv-file (make-parameter #f))

(define x-min [make-parameter #f])
(define x-max [make-parameter #f])
(define y-min [make-parameter #f])
(define y-max [make-parameter #f])

; parse command-line
(define action
  (command-line
   #:once-each
   [("-f" "--fields") f "Fields" (field-nums [map string->number (string-split f ",")])]
   [("-c" "--csv-file") c "CSV filename" (csv-file c)]
   ))

(define [extract-species fullname]
  [car (string-split fullname)]
  )

(define (csv-file-read csv-file field-sep)
  (let* [
         (csv-line-split (λ (line) (regexp-split field-sep (string-trim line "\""))))
         (csv-fields [λ (record) [map (curry list-ref record) (field-nums)]])

         (csv-fh (open-input-file csv-file #:mode 'text))
         (header-line [csv-fields (csv-line-split (read-line csv-fh))])
         (header-line-len (length header-line))
         ]
    (writeln header-line)
    (for/list [(line (in-lines csv-fh))]
      (let [(record [(compose csv-fields csv-line-split) line])]
        (if [(negate =) header-line-len (length record)]
            (raise "Failed to split record correctly; wrong number of resultant fields.")
            [cons (extract-species [car record]) (map string->number [cdr record])]
            )
        )
      )
    )
  )

(define data [csv-file-read (csv-file) #px"\\s*\"?,\"?\\s*"])
(define clean-data [filter second data])

(x-min [cadar clean-data])
(x-max [cadar clean-data])
(y-min [caddar clean-data])
(y-max [caddar clean-data])
(for [(record clean-data)]
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
       (adelie-data [sort (map cdr [filter adelie? clean-data]) < #:key car])
       (adelie-points [points adelie-data #:label "Adelie" #:sym 'fullcircle #:color "red"])

       (gentoo? [compose (curry equal? "Gentoo") car])
       (gentoo-data [sort (map cdr [filter gentoo? clean-data]) < #:key car])
       (gentoo-points [points gentoo-data #:label "Gentoo" #:sym 'fullsquare #:color "green"])

       (chinstrap? [compose (curry equal? "Chinstrap") car])
       (chinstrap-data [sort (map cdr [filter chinstrap? clean-data]) < #:key car])
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
