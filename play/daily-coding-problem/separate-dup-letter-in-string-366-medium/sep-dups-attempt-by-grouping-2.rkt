#lang racket

; This problem was asked by Flexport.
; Given a string s, rearrange the characters so that any two adjacent
; characters are not the same. If this is not possible, return null.
; For example, if s = yyz then return yzy. If s = yyy then return null.

(require racket/random)

(displayln "\nStarting ...\n")

(define letters "abcdefghij")

(define test-strs
  ; (for/list [(_ (range 10))]
  ;   (list->string (random-sample letters 10))
  ;   )
  '("fcdiajdchf" "fcdcajdccf")
  )
(writeln test-strs)

(define strs-grouped
  [for/list [(str test-strs)]
    ([compose (curryr sort > #:key length) hash-values]
     (foldl
      [λ (l h) (hash-update h l (curry cons l) '[])]
      (hash)
      (string->list str)
      )
     )
    ]
  )
(writeln strs-grouped)

(define lofls->string [compose (curry apply ~a) (curry map car)])
(define split-str-group [curry partition (compose (curry = 1) length)])

(define strs-build-initial-str
  [for/list ([str-group strs-grouped])
    (let loop ([str-group str-group] [str ""])
      [let-values ([(letter letters) (split-str-group str-group)])
        (cond
          [(empty? letters) (~a str (lofls->string letter))]
          ;[(= 1 (length letters)) (~a str [multi-merge letters letter])]
          [true {loop (append letter (map cdr letters)) (~a str (lofls->string letters))}]
          )
        ]
      )
    ]
  )
(writeln strs-build-initial-str)
