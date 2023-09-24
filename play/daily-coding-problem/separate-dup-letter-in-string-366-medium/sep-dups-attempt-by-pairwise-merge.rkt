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
(writeln test-strs)

(define strs-with-grouped-letters
  (map [compose (curryr sort > #:key cdr) hash->list]
       (for/list [(str test-strs)]
         (foldl
          [λ (l h) (hash-update h l add1 0)]
          (hash)
          (string->list str)
          ))
       ))
(writeln strs-with-grouped-letters)

(define/match [build-valid-str letter-groups str]
  ([{list} _] str)
  (
   [{list (cons l1 n1) (cons l2 n2) rest ...} _]
   (writeln letter-groups)
   [let ([n1 (sub1 n1)] [n2 (sub1 n2)])
     {build-valid-str
      (cond
        [(and [zero? n1] [zero? n2]) rest]
        [(zero? n1) (cons (cons l2 n2) rest)]
        [(zero? n2) (cons (cons l1 n1) rest)]
        [true (cons (cons l1 n1) [cons (cons l2 n2) rest])]
        )
      (~a str l1 l2)}
     ]
   )
  ([{list (cons l1 1)} _] [~a str l1])
  ([_1 _2] 'null)
  )
(define results
  (map [curryr build-valid-str ""] strs-with-grouped-letters)
  )
(writeln results)
