#lang racket

(provide matching?)

(define (matching? str)
  (let* ([open->closed? (lambda (close-char expected-open)
                          ;  (printf "\t~a : ~a\n" close-char expected-open)
                          (match (~a close-char)
                            [")" (equal? expected-open "(")]
                            ["]" (equal? expected-open "[")]
                            ["}" (equal? expected-open "{")]
                            [_ #t]))]

         [m? (lambda (c a)
               ;(printf ">> ~a : ~a\n" c a)
               (case (~a c)
                 [("(" "[" "{") (cons (~a c) a)]
                 [(")" "]" "}") (match a
                                  ['() #f]
                                  [_ (if (open->closed? c (car a)) (cdr a) #f)])]
                 [else a])
               )])

    (equal? (foldl m? '() (string->list str)) '())

    ))

(printf "Expect 9 #t\n")
(matching? "")
(matching? "[]")
(matching? "{}")
(matching? "()")
(matching? "([{}])")
(matching? "()[]{}")
(matching? "123")
(matching? "(((185 + 223.85) * 15) - 543)/2")
(matching? "([{}({}[])])")
(printf "\n")

(printf "Expect 5 #f\n")
(matching? "][")
(matching? ")(")
(matching? "}{")
(matching? "{}[")
(matching? "{[}")
(printf "\n")
