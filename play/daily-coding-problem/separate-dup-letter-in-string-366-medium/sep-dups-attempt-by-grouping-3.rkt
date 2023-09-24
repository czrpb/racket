#lang racket

; This problem was asked by Flexport.
; Given a string s, rearrange the characters so that any two adjacent
; characters are not the same. If this is not possible, return null.
; For example, if s = yyz then return yzy. If s = yyy then return null.

(require racket/random)

(displayln "\nStarting ...\n")

(define letters "abcde") ;"abcdefghij")

(define test-strs
  (append
   '("yyzy" "cdbbbdccdc" "faeeegaeba" "fcdiajdchf" "fcdcajdccf")
   (for/list [(_ (range 25))]
     (list->string (random-sample letters 10))
     )
   )
  )

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

(define strs-build-initial-str
  [for/list ([str-group strs-grouped])
    (let loop [(largest (car str-group)) (others (cdr str-group)) (str "")]
      ; (printf "\tlargest: ~a ; others: ~a ; str: ~a\n" largest others str)
      [cond
        ([and (empty? largest) (empty? others)] str)
        ([empty? others] 'null)
        ([empty? largest] {loop (car others) (cdr others) str})
        (true [let* (
                     [other (car others)]
                     [others (cdr others)]

                     [letter (car other)]
                     [other (cdr other)]
                     )
                {loop
                 (cdr largest)
                 [cond
                   ([empty? other] others)
                   ([< 1 (length other)] [cons other others])
                   (true (append others [list other]))
                   ]
                 (~a str [car largest] letter)}
                ]
              )
        ]
      )
    ]
  )

(for [(a test-strs) (b strs-grouped) (c strs-build-initial-str)]
  (printf "~a : ~a : ~a\n" a b c)
  )