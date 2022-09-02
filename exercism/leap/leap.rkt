#lang racket

(provide leap-year?)

(define (leap-year? year)
  (let* (
         [div-by (lambda (d) (lambda (y) (= (remainder y d) 0)))]
         [div-by-400 (div-by 400)]
         [div-by-100 (div-by 100)]
         [div-by-4 (div-by 4)]
         )
    (cond
      [(div-by-400 year) #t]
      [(div-by-100 year) #f]
      [(div-by-4 year) #t]
      [else #f]
      )))
