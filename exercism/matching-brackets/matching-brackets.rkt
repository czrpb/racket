#lang racket

(require threading)

(provide balanced?)

(define brackets "()[]{}")
(define bracket-set (apply set (string->list brackets)))
(define is-bracket? (lambda (c) (set-member? bracket-set c)))
(define process (lambda (c a)
                 (match* (c a)
                   [(#\) (cons #\( t)) t]
                   [(#\] (cons #\[ t)) t]
                   [(#\} (cons #\{ t)) t]
                   [(c a) (cons c a)]
                )))

(define (balanced? str)
  (equal? '()
          (~> str
              (string->list _)
              (filter is-bracket? _)
              (foldl process '() _)
              )))
