#lang racket

(require data/collection)

(define fibs (stream-cons 1 (stream-cons 1 (map + fibs (stream-rest fibs)))))

(sequence->list (stream-take fibs 25))