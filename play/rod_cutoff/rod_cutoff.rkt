#lang racket

(define l1 '(1 1 3 4))

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
       (rc l-updated [cons l-len acc])
       ]
     )
    ]
  )

(printf "~a -> ~a\n" l1 [rc (sort l1 <) '()])

