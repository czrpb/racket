#lang racket

(provide armstrong-number?)

(define (armstrong-number? n)
  (let* (
         [char->int (compose string->number string)]
         [number->list (compose string->list number->string)]
         [digits-str (number->list n)]
         [digits (map char->int digits-str)]
         [count (length digits)])
    (= n (for/sum ([d digits]) (expt d count))))
  )
