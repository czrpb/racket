#lang racket

(require threading)

(provide rebase)

(define valid-base? (lambda (base) (< 1 base)))

(define/contract (rebase list-digits in-base out-base)
  ((listof natural?) valid-base? valid-base? . -> . (listof natural?))

  (letrec ([places (range (length list-digits))]
           [digits (reverse list-digits)]
           [calc-in-base (lambda (d p sum) [+ sum (* d (expt in-base p))])]
           [digits-out-base (match-lambda** [(0 result) result]
                                            [(q result)
                                             (digits-out-base (quotient q out-base)
                                                              (cons (remainder q out-base) result))]
                                            )])
    [~> (foldl calc-in-base 0 digits places)
        (digits-out-base _ '())
        ]
    ))
