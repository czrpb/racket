#lang racket

(provide list-allergies allergic-to?)

(define allergines
  (hash
   "eggs" 1
   "peanuts" 2
   "shellfish" 4
   "strawberries" 8
   "tomatoes" 16
   "chocolate" 32
   "pollen" 64
   "cats" 128
   ))

(define (allergic-to? str score)
  (not
   (= (bitwise-and (hash-ref allergines str) score)
      0)))

(define (list-allergies score)
  (let (
        [allergic-to-score?
         (lambda (allergin) (allergic-to? allergin score))
         ])
    (filter allergic-to-score? (hash-keys allergines))
    ))
