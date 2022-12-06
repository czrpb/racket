#lang at-exp racket

(require "read-input.rkt")

(define test-lines
  (string-split
   @~a{2-4,6-8
2-3,4-5
5-7,7-9
2-8,3-7
6-6,4-6
2-6,4-8}
   "\n")
  )

(define (parse)
  (displayln "starting ...")
  (let* [(lines-fh (read-input "day4-input.txt"))
         (lines (car lines-fh))
         (fh (cdr lines-fh))
         ]

    'na

    (close-input-port fh)
    )
  )

(parse)