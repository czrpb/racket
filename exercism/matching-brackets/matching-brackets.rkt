#lang racket

(provide balanced?)

(define (balanced? str)
  (let* ([open->closed? (lambda (close-char expected-open)
                          (match (~a close-char)
                            [")" (equal? expected-open "(")]
                            ["]" (equal? expected-open "[")]
                            ["}" (equal? expected-open "{")]
                            [_ #t]))]

         [m? (lambda (c a)
               (case (~a c)
                 [("(" "[" "{") (cons (~a c) a)]
                 [(")" "]" "}") (match a
                                  ['() #f]
                                  [_ (if (open->closed? c (car a)) (cdr a) #f)])]
                 [else a])
               )])

    (equal? (foldl m? '() (string->list str)) '())

    ))
