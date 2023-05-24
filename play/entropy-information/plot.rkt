#lang racket

(require plot)
(plot-new-window? #t)

(define (log2 v) (log v 2))
(define (log10 v) (log v 10))

(define (entropy pct) (* -1 pct (log2 pct)))

(plot-x-label "Percent / Frequency")
(plot-y-label "Entropy")
(plot (append
       (list (function entropy 0 1
                       #:y-max 0.532
                       ;#:y-max 0.16
                       ;#:y-max 0.37
                       #:label "Entropy: (* -1 pct (log2 pct))"
                       ))
       (map (λ (pct) (point-label (vector pct (entropy pct))))
            (range 0.025 1 0.025))
       )
      )