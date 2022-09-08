#lang racket

(require threading)

(provide rebase)

(define valid-base? (lambda (base) (< 1 base)))
(define valid-digit-for-base? (lambda (digit base) (< digit base)))

(define/contract (rebase list-digits in-base out-base)
  ((listof natural?) valid-base? valid-base? . -> . (listof natural?))

  (letrec ([places (range (length list-digits))]
           [digits (reverse list-digits)]
           [calc-in-base (lambda (d p sum)
                           [if (valid-digit-for-base? d in-base)
                               (+ sum (* d (expt in-base p)))
                               (raise (exn:fail:contract "Invalid digit for input base.") (current-continuation-marks))
                               ])]
           [digits-out-base (match-lambda** [(0 '()) '(0)]
                                            [(0 result) result]
                                            [(q result)
                                             (digits-out-base (quotient q out-base)
                                                              (cons (remainder q out-base) result))]
                                            )])
    [~> (foldl calc-in-base 0 digits places)
        (digits-out-base _ '())
        ]
    ))
