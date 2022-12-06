#lang racket

(provide read-input)

(define (read-input inputfile)
  (let* [(fh (open-input-file inputfile #:mode 'text))
         (lines (for/list [(line (in-lines fh))] line))
         ]
    (cons lines fh)
    ))