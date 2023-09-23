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

(define strs-with-grouped-letters
  (for/list [(str test-strs)]
    (foldl
     [λ (l h) (hash-update h l add1 0)]
     (hash)
     (string->list str)
     )))

(define valid-strs
  (for/list [(h strs-with-grouped-letters)]
    (let loop [(h h) (str "")]
      (if [equal? (hash 0 0) h]
          str
          (loop
           (hash-map/copy h [λ (k v) (let* [(new-v (sub1 v)) (new-k (if [zero? new-v] 0 k))]
                                       (values new-k new-v))])
           (apply ~a str (filter-not [curry equal? 0] (hash-keys h))))
          ))))

(writeln test-strs)
(writeln strs-with-grouped-letters)
(writeln valid-strs)