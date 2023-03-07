#lang racket

(require "bheap.rkt")

(for/fold [(h '())] [(n (range 1 7))]
  (let [(new-h (bheap-add h (* n 4) (* n 4)))]
    (displayln new-h)
    new-h
    )
  )

(
 (4 . 4)
 (
  (
   (8 . 8)
   (
    (
     (16 . 16)
     (() . 0)
     (() . 0)
     ) . 1
       )
   (
    (
     (24 . 24)
     (() . 0)
     (() . 0)
     ) . 1
       )
   ) . 3
     )
 (
  (
   (12 . 12)
   (
    (
     (20 . 20)
     (() . 0)
     (() . 0)
     ) . 1
       )
   (() . 0
       )
   ) . 2
     )kf
 )
