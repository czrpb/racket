#lang racket
(provide my-reverse)

(define (my-reverse s)
  (let ([
         string-reverse
         (compose list->string
                  (compose reverse string->list))
         ])
    (string-reverse s)))
