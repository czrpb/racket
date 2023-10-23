#lang racket

(require plot)

(require [only-in "get-cmdline.rkt" field-nums csv-file])

(provide all-data x-min x-max y-min y-max)

(struct penguin-data (raw data points))

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
(define csv-data [filter second data])

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

(define adelie
  [let* (
         (adelie? [compose (curry equal? "Adelie") car])
         (adelie-records [filter adelie? csv-data])
         (adelie-data [sort (map cdr adelie-records) < #:key car])
         (adelie-points [points adelie-data #:label "Adelie" #:sym 'fullcircle #:color "red"])
         )
    (penguin-data adelie-records adelie-data adelie-points)
    ])

(define gentoo
  [let* (
         (gentoo? [compose (curry equal? "Gentoo") car])
         (gentoo-records [filter gentoo? csv-data])
         (gentoo-data [sort (map cdr gentoo-records) < #:key car])
         (gentoo-points [points gentoo-data #:label "Gentoo" #:sym 'fullsquare #:color "green"])
         )
    (penguin-data gentoo-records gentoo-data gentoo-points)
    ])

(define chinstrap
  [let* (
         (chinstrap? [compose (curry equal? "Chinstrap") car])
         (chinstrap-records [filter chinstrap? csv-data])
         (chinstrap-data [sort (map cdr chinstrap-records) < #:key car])
         (chinstrap-points [points chinstrap-data #:label "Chinstrap" #:sym 'fulltriangle #:color "blue"])
         )
    (penguin-data chinstrap-records chinstrap-data chinstrap-points)
    ])

(define all-data [list csv-data adelie gentoo chinstrap])
