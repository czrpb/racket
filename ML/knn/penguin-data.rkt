#lang racket

(require [only-in "get-cmdline.rkt" field-nums csv-file k2 centroid])
(require [only-in "utils.rkt" sort< pts->centroid])

(provide the-data x-min x-max y-min y-max)

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
(define-values [csv-data-classify csv-data-remaining]
  [split-at (shuffle csv-data) (or [k2] [length csv-data])])
(define csv [hash 'classify csv-data-classify 'remaining csv-data-remaining])

(define x-min [make-parameter (cadar csv-data)])
(define x-max [make-parameter (cadar csv-data)])
(define y-min [make-parameter (caddar csv-data)])
(define y-max [make-parameter (caddar csv-data)])

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

(define [penguin-hash penguin]
  (let*-values [
                ([penguin?] [compose (curry equal? penguin) car])
                ([penguin-raw] [filter penguin? csv-data])
                ([penguin-data] [sort (map cdr penguin-raw) < #:key car])
                ([penguin-centroid] [list (cons penguin [pts->centroid penguin-data])])
                ([penguin-classify penguin-remaining]
                 ;[split-at (shuffle penguin-raw) (or [k2] [length penguin-raw])])
                 [split-at (shuffle penguin-raw)
                           (cond
                             [(centroid) 0]
                             [(k2) (k2)]
                             [else (length penguin-raw)]
                             )])
                ]
    [hash 'classify penguin-classify 'remaining penguin-remaining 'centroid penguin-centroid]
    ; [hash 'classify (sort penguin-classify < #:key second) 'remaining penguin-remaining 'centroid penguin-centroid]
    )
  )

(define adelie [penguin-hash "Adelie"])
(define gentoo [penguin-hash "Gentoo"])
(define chinstrap [penguin-hash "Chinstrap"])
; [let*-values (
;        ([adelie?] [compose (curry equal? "Adelie") car])
;        ([adelie-raw] [filter adelie? csv-data])
;        ([adelie-data] [sort (map cdr adelie-raw) < #:key car])
;        ([adelie-centroid] [list (cons "Adelie" [centroid adelie-data])])
;        ([adelie-classify adelie-remaining] [split-at (shuffle adelie-raw [k2])])
;        )
;   (hash 'classify adelie-classify 'remaining adelie-remaining 'centroid adelie-centroid)
;   ])

(define the-data
  [hash 'csv csv 'adelie adelie 'gentoo gentoo 'chinstrap chinstrap])
