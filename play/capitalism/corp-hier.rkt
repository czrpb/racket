#lang racket

(define [calc levels (managers-per-level 4) (ics-per-manager 3) (result (list 1 ics-per-manager))]
  (match-let [((list manager-tot ic-tot) result)]
    (if [zero? levels] (list (+ manager-tot ic-tot) manager-tot ic-tot)
        (let* [(managers (calc-level levels managers-per-level)) (ics (* managers ics-per-manager))]
          (printf "level: ~a ; managers: ~a ; ics: ~a\n" levels managers ics)
          (calc
           (sub1 levels)
           managers-per-level
           ics-per-manager
           (list (+ manager-tot managers) (+ ic-tot ics))
           )
          )
        )
    )
  )

(define (calc-level l num-of-managers)
  (expt num-of-managers l)
  )

(calc 0 2 1)

(displayln "\n")

(calc 1 2 0)
(calc 1 2 1)

(displayln "\n")

(calc 2 2 0)
(calc 2 2 1)

(displayln "\n")

(calc 3 2 0)

(displayln "\n")

(calc 6 4 7)

(displayln "\n")

(calc 0 4 5)
(calc 1 4 5)
(calc 7 4 5)
