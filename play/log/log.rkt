#lang racket

(displayln "\nStarting ....\n")

; See

(define num
  (match (current-command-line-arguments)
    [(vector num _ ...) (string->number num)]
    )
  )

(writeln num)