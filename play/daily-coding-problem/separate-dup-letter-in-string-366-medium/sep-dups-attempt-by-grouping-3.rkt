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
   '("yyzy" "cdbbbdccdc" "addaaabeeb" "bbceaabaee" "faeeegaeba" "fcdiajdchf" "fcdcajdccf")
   (for/list [(_ (range 0))]
     (list->string (random-sample letters 10))
     )
   )
  )

(define/match [valid? str]
  [((list _)) #t]
  [((list l l _ ...)) #f]
  [((list _ rest ...)) (valid? rest)]
  )

(define strs-grouped
  [map
   (compose [curryr sort > #:key length] ; (compose length car)]
            ;[curry group-by length]
            [curry group-by identity]
            string->list)
   test-strs]
  )

(define one? [compose (curry = 1) length])
(define zip [curry map list])

(define strs-build-initial-str
  [for/list ([str-grouped strs-grouped])
    (let [(str-group str-grouped)]
      [let loop ([sg str-group] [str ""])
        ; (writeln sg)
        (match sg
          ; empty list means we are good!
          [(list) str]

          ; if the last remaining list has 1 element, again we are good!
          [(list [list a]) (~a str a)]

          ; if the last remaining list has multiple identical elements, we are not good.
          [(list [list _a _a _rest ...]) 'null]

          ; if the 2nd to last list is empty, and continue with the rest ...
          [(list a [list] rest ...) {loop (cons a rest) str}]

          ; if we have placed all elements in the 1st list, and continue with the rest ...
          [(list [list] rest ...) {loop rest str}]

          ; if there are only 2 lists left, get car and continue with cdr
          [(list a b) {loop (list (cdr a) (cdr b)) (~a str [car b] [car a])}]

          ; default: add the car from the 1st and 2nd lists, and continue with their cdr and the rest ...
          [(list a b rest ...)
           (let [(a-car (car a)) (a-cdr (cdr a))
                                 (b-car (car b)) (b-cdr (cdr b))
                                 (rest-car (car rest)) (rest-cdr (cdr rest))
                                 ]
             ;{loop (append [list (cdr a)] rest [list (cdr b)]) (~a str [car b] [car a])}
             {loop (append [list a-cdr rest-car b-cdr] rest-cdr) (~a str b-car a-car)}
             )
           ]
          )
        ]
      )
    ]
  )

(for [(a test-strs) (b strs-grouped) (c strs-build-initial-str)]
  [let (
        [a-valid (valid? [string->list a])]
        [c-valid (if [equal? 'null c] c [valid? (string->list c)])]
        )
    (printf "~a (~a) : ~a : ~a (~a)\n" a a-valid b c c-valid)
    ] )