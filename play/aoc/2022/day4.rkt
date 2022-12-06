#lang at-exp racket

(require "read-input.rkt")

(define test-lines
  (string-split
   @~a{}
   "\n")
  )

(define (parse)
  (displayln "starting ...")
  (let* [(lines-fh (read-input "day???-input.txt"))
         (lines (car lines-fh))
         (fh (cdr lines-fh))
         ]

    'na

    (close-input-port fh)
    )
  )

(parse)