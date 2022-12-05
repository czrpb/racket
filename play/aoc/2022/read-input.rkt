#lang racket

(provide read-input)

(define (read-input inputfile)
  (let* [(fh (open-input-file inputfile #:mode 'text))
         (lines (in-lines fh))
         ]
    (cons lines fh)
    ))