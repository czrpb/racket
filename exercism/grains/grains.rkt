#lang racket

(provide square total)

(define (square desired_square)
  (square_p desired_square 1 1))

(define (square_p desired_square current_square amount)
  (match (= current_square desired_square)
    [#true amount]
    [#false (square_p desired_square (+ current_square 1) (* amount 2))]))

(define (total) (total_p 64 0))

(define (total_p asquare sum)
  (match asquare
    [0 sum]
    [_ (total_p (- asquare 1) (+ sum (square asquare)))])
  )
