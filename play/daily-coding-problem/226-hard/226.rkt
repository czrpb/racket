#lang racket

(require adjutor)

; This problem was asked by Airbnb.

; You come across a dictionary of sorted words in a language you've never seen before.
; Write a program that returns the correct order of letters in this language.

; For example, given ['xww', 'wxyz', 'wxyw', 'ywx', 'ywz'], you should return ['x', 'z', 'w', 'y'].

(define words (vector->list (current-command-line-arguments)))

(define make-pairs (match-lambda
                     [(list a b) (list (list a b))]
                     [(list a b rest ...) (cons (list a b) (make-pairs (cons b rest)))]
                     ))

(define (sol-226 words)
  (let* [
         (words (map string->list words))
         (letters (remove-duplicates (map car words)))
         (pairs (map
                 (λ (prefix-info) (map car (cdr prefix-info)))
                 (filter
                  [compose (curry negate empty?) car]
                  (map
                   [λ (pair) (values->list (apply split-common-prefix pair))]
                   (make-pairs words))
                  )))
         ]
    (writeln words)
    (writeln letters)
    (writeln pairs)
    )
  )

; =============================

(displayln "\nStarting...\n")

(sol-226 '("caa" "aaa" "aab"))

(displayln "\n")

(sol-226 '("wrt" "wrf" "ea" "er" "ett" "rftt"))

(displayln "\n")

(sol-226 '("xww" "wxyz" "wxyw" "ywx" "ywz"))

(displayln "\n")

(sol-226 '("baa" "abcd" "abca" "cab" "cad"))