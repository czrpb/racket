#lang racket

(provide chunk)

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


(define test0 '((1) (2 3)))
(define test1 '((1) (2 3) (1 5 1)))
(define test2 '((1) (2 3) (4 5 6)))
(define test3 '((1) (2 3) (4 5 6) (7 8 9 10)))
(define test4 '((1) (2 3) (4 5 6) (7 8 9 10) (11 12 13 14 15)))
(define test5 '((3) (7 4) (2 4 6) (8 5 9 3)))
(define test6 '((8) (-4 4) (2 2 6) (1 1 1 1)))
(define test7 '((1) (4 8) (1 5 3)))
(define test8 '((3) (7 4) (2 4 6) (8 5 9 3)))

(define (chunk len l)
  (if (< (length l) len)
      '()
      (let [(head (take l len)) (tail (cdr l))]
        (cons head (chunk len tail))
        )
      )
  )

(define (interleave l1 l2)
  (if (empty? l2)
      l1
      (append (list (car l1) (car l2)) (interleave (cdr l1) (cdr l2)))
      )
  )

(define (max-path tree)
  (apply max
         (foldl
          (λ (l2 l1)
            (displayln l1)
            (displayln l2)
            (displayln "")
            (cond
              [(< (length l1) (length l2))
               (flatten (apply interleave (map (λ (l) (map + l1 l)) (chunk (length l1) l2))))
               ]

              [(= (length l2) (length l1))
               (interleave (map + l1 l2) (map + (drop-right l1 1) (drop l1 1)))]

              [else 'greater]
              )
            ; (interleave (map + l2 (drop-right l1 1)) (map + l2 (drop l1 1)))
            )
          (car tree) (cdr tree)
          )
         )
  )

(writeln (max-path test0))
(writeln (max-path test1))
(writeln (max-path test2))
(writeln (max-path test3))
; (writeln (max-path test4))
(writeln (max-path test5))
; (writeln (max-path test6))
; (writeln (max-path test7))
; (writeln (max-path test8))

; (define (wrap-with-0s l) (append (cons 'zero l) (list 'zero)))

; (define (pairs l)
;   (for/list [(a (drop-right l 1)) (b (drop l 1))]
;     (list a b)
;     )
;   )

; (define (max-path tree)
;   (apply max
;          (foldl
;           (λ (l1 l2)
;             (let [(l2-pairs (pairs (wrap-with-0s l2)))]
;               (displayln l2)
;               (displayln l2-pairs)
;               (displayln l1)
;               (displayln " ")
;               (flatten
;                (for/list [(i1 l1) (i2 l2-pairs)]
;                  (match i2
;                    [(list 'zero a) (+ i1 a)]
;                    [(list a 'zero) (+ i1 a)]
;                    [(list a b) (list (+ i1 a) (+ i1 b))]
;                    )
;                  )
;                )
;               )
;             )
;           (car tree) (cdr tree)
;           )
;          )
;   )
