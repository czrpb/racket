#lang racket

; Given a 2D matrix of characters and a target word, write a function that
; returns whether the word can be found in the matrix by going left-to-right,
; or up-to-down.

; For example, given the following matrix:

; [['F', 'A', 'C', 'I'],
;  ['O', 'B', 'Q', 'P'],
;  ['A', 'N', 'O', 'B'],
;  ['M', 'A', 'S', 'S']]

; and the target word 'FOAM', you should return true, since it's the leftmost
; column. Similarly, given the target word 'MASS', you should return true,
; since it's the last row.

(define search-string-1 "MASS")
(define search-string-2 "FOAM")

(define matrix
  '((#\F #\A #\C #\I) (#\O #\B #\Q #\P) (#\A #\N #\O #\B) (#\M #\A #\S #\S))
  )

(define (fwim word matrix)
  (let* [
         (word (string->list word))
         (found-as-a-row (natural? (index-of matrix word)))
         (found-as-a-column (natural? (index-of (apply map list matrix) word)))
         ]
    (or found-as-a-row found-as-a-column)
    ))

(fwim search-string-1 matrix)
(fwim search-string-2 matrix)
(display "")

(define (fwim2 word matrix)
  (let* [
        (columns (apply map list matrix))
        (matrix (append matrix columns))
        (matrix (map list->string matrix))
        (matches-word (λ (test-word) (equal? word test-word)))
        ]
    (ormap matches-word matrix)
    ))

(fwim2 search-string-1 matrix)
