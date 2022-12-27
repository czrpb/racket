#lang racket

; Given a N by M matrix of numbers, print out the matrix in a clockwise spiral.

; For example, given the following matrix:

; [[1,  2,  3,  4,  5],
;  [6,  7,  8,  9,  10],
;  [11, 12, 13, 14, 15],
;  [16, 17, 18, 19, 20]]

; You should print out the following:

; 1
; 2
; 3
; 4
; 5
; 10
; 15
; 20
; 19
; 18
; 17
; 16
; 11
; 6
; 7
; 8
; 9
; 14
; 13
; 12

(define (matrix-spiral matrix)
  (letrec [(f (match-lambda**

               [('() acc) acc]

               [((cons row '()) acc) (f '() (append acc row))]

               [((cons first-row remaining) acc)
                (match-let [((cons last-row remaining) (reverse remaining))]
                  (f (cons (reverse last-row) remaining) (append acc first-row))
                  )]
               ))]
    (f matrix '())))

(define input '((1 2 3 4 5) (6 7 8 9 10) (11 12 13 14 15) (16 17 18 19 20)))
(define output '(1 2 3 4 5 10 15 20 19 18 17 16 11 6 7 8 9 14 13 12))

(let [(result (matrix-spiral input))]
  (printf "~a\n" result)
  (equal? result output)
  )
