#lang racket

; =========================================
; Good morning! Here's your coding interview problem for today.

; This problem was asked by Google.

; You are given an array of arrays of integers, where each array corresponds to a row in a triangle
; of numbers. For example, [[1], [2, 3], [1, 5, 1]] represents the triangle:

;   1
;  2 3
; 1 5 1

; We define a path in the triangle to start at the top and go down one row at a time to an adjacent
; value, eventually ending with an entry on the bottom row. For example, 1 -> 3 -> 5. The weight of
; the path is the sum of the entries.

; Write a program that returns the weight of the maximum weight path.
; =========================================

(define (wrap-with-0s l) (append (cons 'zero l) (list 'zero)))

(define (pairs l)
  (for/list [(a (drop-right l 1)) (b (drop l 1))]
    (list a b)
    )
  )

(define test1 '((1) (2 3) (1 5 1)))
(define test2 '((1) (2 3) (4 5 6)))
(define test3 '((1) (2 3) (4 5 6) (7 8 9 10)))
(define test4 '((1) (2 3) (4 5 6) (7 8 9 10) (11 12 13 14 15)))

(define (max-path tree)
  (apply max
         (foldl
          (λ (l1 l2)
            (let [(l2-pairs (pairs (wrap-with-0s l2)))]
              (displayln l2)
              (displayln l2-pairs)
              (displayln l1)
              (displayln " ")
              (flatten
               (for/list [(i1 l1) (i2 l2-pairs)]
                 (match i2
                   [(list 'zero a) (+ i1 a)]
                   [(list a 'zero) (+ i1 a)]
                   [(list a b) (list (+ i1 a) (+ i1 b))]
                   )
                 )
               )
              )
            )
          (car tree) (cdr tree)
          )
         )
  )

;(writeln (max-path test1))
;(writeln (max-path test2))
;(writeln (max-path test3))
(writeln (max-path test4))
