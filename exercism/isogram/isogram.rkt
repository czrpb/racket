#lang racket

(provide isogram?)

(define (isogram? s)
  (let* (
         [string->downlist (compose string->list string-downcase)]
         [string->alphas (lambda (s) (filter char-alphabetic? (string->downlist s)))]
         [s-alphas-as-list (string->alphas s)]
         [s-alphas-as-set (list->set s-alphas-as-list)])

    (= (length s-alphas-as-list) (set-count s-alphas-as-set))
    ))
