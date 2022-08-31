#lang racket

(provide response-for)

(define (response-for msg)
  (let* (
         [msg (string-trim msg)]
         [msg-chars (filter char-alphabetic? (string->list msg))])
    (let (
          [nothing (not (non-empty-string? msg))]
          [question (string-suffix? msg "?")]
          [yelled_at (and
                      (not (empty? msg-chars))
                      (for/and ([c msg-chars]) (char-upper-case? c)))])
      (cond
        [nothing "Fine. Be that way!"]
        [(and yelled_at question) "Calm down, I know what I'm doing!"]
        [yelled_at "Whoa, chill out!"]
        [question "Sure."]
        [else "Whatever."])
      )))
