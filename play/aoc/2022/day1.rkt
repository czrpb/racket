#lang racket

(require "read-input.rkt")

(define (parse)
  (let* [(lines-fh (read-input "day1-input.txt"))
         (lines (car lines-fh))
         (fh (cdr lines-fh))]
    (displayln "starting ...")
    (let [(elfs (for/fold [(elfs '())
                           (elf 0)
                           #:result elfs]
                          ([line lines])
                  (values '() 0))
                )]
      'na
      )
    (close-input-port fh)
    ))

(parse)