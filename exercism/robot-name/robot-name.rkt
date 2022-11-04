#lang racket

(provide make-robot
         name
         reset!
         reset-name-cache!)


(define (make-name)
  (let [
        (random-letter (λ () (integer->char (random 65 90))))
        (random-number (λ () (random 10)))
        ]
    (~a (random-letter) (random-letter) (random-number) (random-number) (random-number))
    ))

(define (make-robot)
  (make-name))

(define (name robot)
  (case robot
    [("") (make-robot)]
    [else robot]
    ))

(define (reset! robot)
  "")

(define (reset-name-cache!)
  "")
