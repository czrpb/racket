#lang racket

(require threading)

(provide nanp-clean)

(define valid-number?
  (lambda (num)
    [let ([ten? (lambda () [= (string-length num) 10])]
          [~bad-area-code? (lambda () [(negate set-member?) (set #\0 #\1) (string-ref num 0)])]
          [~bad-exchange-code? (lambda () [(negate set-member?) (set #\0 #\1) (string-ref num 3)])])
      (and (ten?) (~bad-area-code?) (~bad-exchange-code?))
      ]))

(define/contract (nanp-clean s)
  (string? . -> . valid-number?)

  (let ([nan-re #px"[^0123456789]"])
    (~> s
        (regexp-replace* nan-re _ "")
        (string-trim _ "1" #:right? #f)
        )))
