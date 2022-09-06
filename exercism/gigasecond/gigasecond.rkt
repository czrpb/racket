#lang racket

(provide add-gigasecond)

(require racket/date)

(define (add-gigasecond moment)
  (let* ([gig 1000000000]
         [addgig (lambda (seconds) (+ seconds gig))]
         [future-gig (compose seconds->date addgig date->seconds)])
    (future-gig moment)
    ))