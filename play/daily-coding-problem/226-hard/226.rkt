#lang racket

; This problem was asked by Airbnb.

; You come across a dictionary of sorted words in a language you've never seen before.
; Write a program that returns the correct order of letters in this language.

; For example, given ['xww', 'wxyz', 'wxyw', 'ywx', 'ywz'], you should return ['x', 'z', 'w', 'y'].

(define words (vector->list (current-command-line-arguments)))

(define (get-1st-letters words)
  (map (curryr string-ref 0) words)
  )

(define (sol-226 words)
  (let* [
         (words (map string->bytes/latin-1 words))
         (letters (map (curryr bytes-ref 0) words))
         (letter-order-pairs
          (for/hash [(o (in-naturals)) (l letters)]
            (values l (* o 10))))
         ]
    (writeln words)
    (writeln letters)
    (writeln letter-order-pairs)
    )
  )

; =============================

(displayln "\nStarting...\n")

(sol-226 words)