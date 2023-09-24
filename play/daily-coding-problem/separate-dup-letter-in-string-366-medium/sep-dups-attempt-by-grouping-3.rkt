#lang racket

; This problem was asked by Flexport.
; Given a string s, rearrange the characters so that any two adjacent
; characters are not the same. If this is not possible, return null.
; For example, if s = yyz then return yzy. If s = yyy then return null.

(require racket/random)

(displayln "\nStarting ...\n")

(define letters "abcdefg") ;"abcdefghij")

(define test-strs
  (cons "yyzy"
        (for/list [(_ (range 25))]
          (list->string (random-sample letters 10))
          )
        )
  ;'("fcdiajdchf" "fcdcajdccf")
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
(define [multi-merge multiple singles (srt "")]
  (let loop [(a (car multiple)) (b (cdr singles)) (str "")]
    (cond
      [(and (empty? a) (empty? b)) str]
      [(and ((negate empty?) a) (empty? b)) 'null]
      [(and (empty? a) ((negate empty?) b)) (~a str (apply ~a (map car b)))]
      [true {loop (cdr a) (cdr b) (~a str (car a) (caar b))}]
      )
    )
  )

(define strs-build-initial-str
  [for/list ([str-group strs-grouped])
    (let loop ([str-group str-group] [str ""])
      [let-values ([(singles multiples) (split-str-group str-group)])
        (cond
          [(empty? multiples) (~a str (lofls->string singles))]
          [(= 1 (length multiples))
           (let [(merged [multi-merge multiples singles])]
             [if (eq? 'null merged) merged (~a str merged)])
           ]
          [true {loop (append singles (map cdr multiples)) (~a str (lofls->string multiples))}]
          )
        ]
      )
    ]
  )
(writeln strs-build-initial-str)
