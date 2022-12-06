#lang racket

(require "read-input.rkt")

(define cipher1 #hash(
                 ; draws
                 (("A" . "X") . 4) ; rock & rock:          1 + 3
                 (("B" . "Y") . 5) ; paper & paper:        2 + 3
                 (("C" . "Z") . 6) ; scissors & scissors:  3 + 3

                 ; wins
                 (("C" . "X") . 7) ; scissors & rock:      1 + 6
                 (("A" . "Y") . 8) ; rock & paper:         2 + 6
                 (("B" . "Z") . 9) ; paper & scissors:     3 + 6

                 ;losses
                 (("B" . "X") . 1) ; paper & rock:         1 + 0
                 (("C" . "Y") . 2) ; scissors & paper:     2 + 0
                 (("A" . "Z") . 3) ; rock & scissors:      3 + 0
                 ))

(define cipher2 #hash(
                 ; losses
                 (("A" . "X") . 3) ; rock & scissors:      3 + 0
                 (("B" . "X") . 1) ; paper & rock:         1 + 0
                 (("C" . "X") . 2) ; scissors & paper:     2 + 0

                 ; draws
                 (("A" . "Y") . 4) ; rock & rock:          1 + 3
                 (("B" . "Y") . 5) ; paper & paper:        2 + 3
                 (("C" . "Y") . 6) ; scissors & scissors:  3 + 3

                 ; wins
                 (("A" . "Z") . 8) ; rock & paper          2 + 6
                 (("B" . "Z") . 9) ; paper & scissors:     3 + 6
                 (("C" . "Z") . 7) ; scissors & rock:      1 + 6
                 ))

(define (calc1 opponent me)
  (hash-ref cipher1 (cons opponent me))
  )

(define (calc2 opponent me)
  (hash-ref cipher2 (cons opponent me))
  )

(define (parse)
  (let* [(lines-fh (read-input "day2-input.txt"))
         (lines (car lines-fh))
         (fh (cdr lines-fh))]
    (displayln "starting ...")
    (define sum
      (for/sum [(line lines)]
      ;(for/sum [(line '("A Y" "B X" "C Z"))]
        (let* [(opponent-me (string-split line))
               (opponent (car opponent-me))
               (me (cadr opponent-me))
               (score1 (calc1 opponent me))
               (score2 (calc2 opponent me))
               ]
          score2
          ))
      )
    (displayln sum)
    (close-input-port fh)
    ))

(parse)