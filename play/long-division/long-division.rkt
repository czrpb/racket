#lang racket

(displayln "\nStarting ....\n")

(define cmdline
  (match (current-command-line-arguments)
    [(vector dividend divisor _ ...) (cons dividend divisor)]
    ))

(define list->number (compose string->number (curryr string-join "")))

(define (ld divisor dividend (result 0))
  (if (< dividend divisor)
      result
      (match-let* [
                   ((list div div-len div-size) divisor)
                   ((var dividend-take)
                    (list->number (take dividend div-len)))
                   ]
        (let-values [
                     ((values q r) (quotient/remainder dividend-take div))
                     ]
          (match-let*
              [
               ((list dividend-drop-first dividend-drop-rest ...)
                (drop dividend div-len))
               ((var dividend-drop-first) (string->number dividend-drop-first))
               ]
            (ld
             divisor
             (append
              (number->string (+ dividend-drop-first r))
              dividend-drop-rest)
             (+ result (* q div-size)))
            )
          ))))

(match-let*
    [
     ((cons dividend divisor) (cmdline))
     ((var divisor-len) (string-length divisor))
     ((var divisor-size) (* 10 divisor-len))
     ((var divisor) (string->number divisor))
     ]
  (displayln (ld (list divisor divisor-len divisor-size) (string->list dividend)))
  )
