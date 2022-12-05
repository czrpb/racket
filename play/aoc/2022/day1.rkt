#lang racket

(require "read-input.rkt")

(define (parse)
  (let* [(lines-fh (read-input "day1-input.txt"))
         (lines (car lines-fh))
         (fh (cdr lines-fh))]
    (displayln "starting ...")
    (let* [(elfs (for/fold [(elfs '())
                            (elf 0)
                            #:result elfs]
                           ([line lines])
                   (match line
                     ["" (values (cons elf elfs) 0)]
                     [_ (values elfs (+ (string->number line) elf))]
                     )

                   ))
           (top-3 (take (sort elfs >) 3))
           ]
      (displayln top-3)
      (displayln (apply + top-3))
      )
    (close-input-port fh)
    ))

(parse)