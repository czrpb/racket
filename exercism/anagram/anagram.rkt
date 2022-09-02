#lang racket

(provide anagrams-for)

(define (anagrams-for word possibles)
  (let* ([string-downcase->list (compose string->list string-downcase)]
         [string-sort (lambda (s) (sort (string-downcase->list s) char-ci<?))]
         [word-chars (string-sort word)])
    (filter
     (lambda (possible)
       (and (not (equal? word possible))
            (= (string-length word) (string-length possible))
            (equal? word-chars (string-sort possible))))
     possibles
     )))
