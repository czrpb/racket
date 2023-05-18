#lang racket

(displayln "\nStarting ....\n")

(define cmdline
  (match (current-command-line-arguments)
    [(vector dividend divisor _ ...) (cons dividend divisor)]
    ))

(define (ld divisor dividend (result 0))
  (writeln divisor)
  (writeln dividend)
  (for/fold
   [
    (remainder 0)
    (result '())
    #:result (for/sum [(p (in-naturals)) (r result)] (* r (expt 10 p)))
    ]
   [(digit dividend)]
    (let*-values [
                  ((part) (+ (* remainder 10) digit))
                  ((q r) (quotient/remainder part divisor))
                  ]
      (writeln (format "~a : ~a : ~a" part digit result))
      (values r (cons q result))
      )
    )
  )

(match-let*
    [
     ((cons dividend-input divisor-input) cmdline)
     ]
  (let* [
         (divisor (string->number divisor-input))
         (dividend (map (λ (n) (- (char->integer n) 48)) (string->list dividend-input)))
         (answer (ld divisor dividend))
         (correct (if (= answer (quotient (string->number dividend-input) divisor)) "" " not"))
         ]
    (printf "answer: ~a is~a correct.\n" answer correct)
    )
  )
