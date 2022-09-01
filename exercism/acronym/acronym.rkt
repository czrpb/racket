#lang racket

(provide acronym)

(define (acronym sentence)
  (let (
        [first-char (lambda (s) (string-ref s 0))]
        [list->string-upcase (compose string-upcase list->string)])
    (let* (
           [words (string-split sentence #px"[\\s_-]+")]
           [first-chars (map first-char words)]
           )
      (list->string-upcase first-chars)
      )))
