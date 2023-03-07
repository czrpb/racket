#lang racket

(require math/distributions plot)

(plot-new-window? #t)

(parameterize ([plot-pen-color-map 'tab20]
               [plot-brush-color-map 'tab20]
               [plot-x-label #f]
               [plot-y-label #f])
  (define (rnorm sample-count mean stddev)
    (sample (normal-dist mean stddev) sample-count))
  (define a (rnorm 50 10 5))
  (define b (append (rnorm 50 13 1) (rnorm 50 18 1)))
  (define c (rnorm 20 25 4))
  (define d (rnorm 10 12 2))
  (plot
   (for/list ([data (list a b c d)]
              [label (list "a" "b" "c" "d")]
              [index (in-naturals)])
     (box-and-whisker data
                      #:label label
                      #:invert? #f
                      #:x index
                      #:width 3/4
                      #:box-color (+ (* index 2) 1)
                      #:box-line-color (* index 2)
                      #:whisker-color (* index 2)
                      #:median-color "red"))
   #:legend-anchor 'no-legend))