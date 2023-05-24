#lang racket

(require plot)
(plot-new-window? #t)

(define (log2 v) (log v 2))
(define (entropy pct) (* -1 pct (log2 pct)))

(plot-x-label "Pct")
(plot-y-label "Entropy")
(plot (function entropy 0 1
                #:y-max 0.532
                #:label "Entropy: (* -1 pct (log2 pct))"
                ))