#lang racket

(define l1 '(1 1 3 4))
(define l2 '(1 1 7 2 2 4 4 4 4 3 11 11 11 11 11 19 1 5 7 7 7 3 4))

(define [rc l acc]
  [cond
    ([empty? l] acc)
    (else
     [let* (
            [min (car l)]
            [min? (curry = min)]
            [-min (curryr - min)]
            [l-len (length l)]
            [l-new (filter-not min? l)]
            [l-updated (map -min l-new)]
            )
       (writeln l)
       (writeln acc)
       (rc l-updated [cons l-len acc])
       ]
     )
    ]
  )

(printf "~a -> ~a\n" l1 [rc (sort l1 <) '()])
(printf "~a -> ~a\n" l2 [rc (sort l2 <) '()])

