#lang racket

(provide grep)

(define (grep flags str file )
  (let ([nats (in-naturals)]
        [lines (in-lines (open-input-file file #:mode 'text))]
        [contains (lambda (line) (string-contains? line str))])
    (sequence->list
     (sequence-filter contains lines))
    ))

(grep '() "and" "iliad.txt")
