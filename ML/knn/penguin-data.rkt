#lang racket

(require "get-cmdline.rkt")

(provide csv-data x-min x-max y-min y-max)

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
