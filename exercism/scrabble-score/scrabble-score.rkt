#lang racket

(provide score)

(define string->set (compose list->set string->list))

(define l10 (string->set "qz"))
(define l8 (string->set "jx"))
(define l5 (string->set "k"))
(define l4 (string->set "fhvwy"))
(define l3 (string->set "bcmp"))
(define l2 (string->set "dg"))
(define l1 (string->set "aeioulnrst"))

(define (letter->score letter)
  (cond
    [(set-member? l1 letter) 1]
    [(set-member? l2 letter) 2]
    [(set-member? l3 letter) 3]
    [(set-member? l4 letter) 4]
    [(set-member? l5 letter) 5]
    [(set-member? l8 letter) 8]
    [(set-member? l10 letter) 10]
    [else 0]))

(define (score word)
  (let* (
        [string->downlist (compose string->list string-downcase)]
        [letters (string->downlist word)])
    (for/sum ([l letters]) (letter->score l)))
  )
