#lang racket

(provide balanced?)

(define open-brackets (set "(" "[" "{"))
(define close-brackets (set ")" "]" "}"))
(define is-open-bracket? (lambda (c) (set-member? open-brackets c)))
(define is-bracket? (lambda (c) (or (is-open-bracket? c) (set-member? close-brackets c))))

(define (balanced? str)
  (let ([closed-correctly? (match-lambda**
                            [("(" ")") #t]
                            [("[" "]") #t]
                            [("{" "}") #t]
                            [(_ _) #f]
                            )]
        )
    (equal? '()
            (foldl
             (match-lambda**
              [(c a) #:when (is-open-bracket? c) (cons c a)]
              [(_ (or '() '(error))) '(error)]
              [(c a) #:when (closed-correctly? (car a) c) (cdr a)]
              [(c a) #:when ((negate closed-correctly?) c (car a)) '(error)]
              [(_ a) a]
              )
             '() (filter is-bracket? (map ~a (string->list str)))
             )
            )))
