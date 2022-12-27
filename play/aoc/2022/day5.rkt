#lang at-exp racket

(require relation/function)

(require "read-input.rkt")

(define test-lines
  (string-split @~a{
     [D]
 [N] [C]
 [Z] [M] [P]
  1   2   3

 move 1 from 2 to 1
 move 3 from 1 to 3
 move 2 from 2 to 1
 move 1 from 1 to 2
}
                "\n")
  )

(define (make-stacks stacks)
  (for [(stack stacks)]
    (displayln (~a "<" stack ">"))
    (define ss (reverse
                (let loop [(stack-index 0) (stack-list '())]
                  (if (< (string-length stack) stack-index)
                      stack-list
                      (loop (+ stack-index 4)
                            (cons (string-ref stack (add1 stack-index))
                                  stack-list))
                      )
                  )))
    (displayln (~a "<" ss ">"))
    )
  )

(define (make-moves moves)
  (define move-nums (map
                     (λ (move) (filter-map (λ (i) (string->number i)) (string-split move)))
                     moves))
  (map (λ (move)
         (list (second move) (third move) (first move)))
       move-nums
       ))

(define (parse)
  (displayln "starting ...")
  (let* [(lines-fh (read-input "day5-input.txt"))
         ;(lines (car lines-fh))
         (lines test-lines)
         (fh (cdr lines-fh))
         ]

    (let [(x 1)]
      (define-values (stacks moves) (split-at lines (index-of lines "")))

      (displayln (make-stacks stacks))
      (displayln (make-moves (cdr moves)))
      )

    (close-input-port fh)
    )
  )

(parse)
