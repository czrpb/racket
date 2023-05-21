#lang racket

(displayln "\nStarting ....\n")

; See
;   https://www.brics.dk/RS/04/17/BRICS-RS-04-17.pdf
; Summary
;    log10 M = d0 + d1/10 + d2/10^2 + d3/10^3 + ...
;    M       = 10^(d0 + d1/10 + d2/10^2 + d3/10^3 + ...)
;    M       = 10^d0 * 10^(d1/10 + d2/10^2 + d3/10^3 + ...)
;    M/10^d0 = 10^(d1/10 + d2/10^2 + d3/10^3 + ...)
;    (M/10^d0)^10 = 10^(d1 + d2/10^1 + d3/10^2 + ...)

(define num
  (match (current-command-line-arguments)
    [(vector num _ ...) (string->number num)]
    )
  )

(writeln num)