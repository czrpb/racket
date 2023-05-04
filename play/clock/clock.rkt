#lang racket

(printf "\nStarting....\n")

;(define overflows '(60 60 24 30 12))
(define overflows '(5 3 2))

;(define clock '(0 0 0 0 0))
(define clock '(0 0 0))

(define (tick clock)
  (for/fold [
             (new_clock '())
             (inc 1)
             #:result (reverse new_clock)
             ]
            [(c clock) (o overflows)]
    (let* [
           (c-inc (+ c inc))
           (overflow? (= o c-inc))
           ]
      (values (cons (if overflow? 0 c-inc) new_clock) (if overflow? 1 0))
      )
    )
  )

(let loop [
           (clock clock)
           ]
  (displayln clock)
  (sleep 1)
  (loop (tick clock))
  )