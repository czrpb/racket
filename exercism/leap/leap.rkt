#lang racket

(provide leap-year?)

(define (leap-year? year)
  (let* (
         [div-by (lambda (d) (lambda (y) (= (remainder y d) 0)))]
         [div-by-400 (div-by 400)]
         [div-by-100 (div-by 100)]
         [div-by-4 (div-by 4)]
         )
    (match year
      [(app div-by-400 #t) #t]
      [(app div-by-100 #t) #f]
      [(app div-by-4 #t) #t]
      [else #f]
      )))
