#lang racket

; This problem was asked by Flexport.
; Given a string s, rearrange the characters so that any two adjacent
; characters are not the same. If this is not possible, return null.
; For example, if s = yyz then return yzy. If s = yyy then return null.

(require racket/random)

(displayln "\nStarting ...\n")

(define letters "abcdefghij")

(define test-strs
  (for/list [(_ (range 10))]
    (list->string (random-sample letters 10))
    ))

(define [list-of-chars->string lofc]
  ([compose (curryr string-join "") (curry map string)] lofc)
  )
(define [sort-str s]
  ([compose list-of-chars->string (curryr sort char<?) string->list] s))

(define test-strs-sorted
  (for/list [(str test-strs)]
    (sort-str str)
    ))

(define valid-test-strs
  (for/list [(str test-strs-sorted)]
    (let loop [(str str) (new-str "")]
      (match (string->list str)
        ['() new-str]
        [(list l) (~a new-str l)]
        [(list first middle ... last) #:when ([negate char=?] first last)
                                      (loop (list-of-chars->string middle) (~a new-str first last))]
        [_ 'null]
        )
      )
    )
  )

(writeln test-strs-sorted)
(writeln valid-test-strs)
