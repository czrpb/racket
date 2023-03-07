#lang racket

(require gregor)

(define cmdline-args
  (vector->list (current-command-line-arguments)))

(define (calc-age dob)
  (let-values [
               ((now) (seconds->date (current-seconds)))
               ((now-year) (values (date-year now) (date-month now) (date-day now)))
               ((year month day) (string-split "/"))
               ]
    (and
    (< )
    )
    ))

(if (car cmdline-args)
    (let [(DOA (car cmdline-args)) (DOB (cadr cmdline-args))]
      (writeln DOA)
      (writeln DOB)
      )
    'na
    )
