#lang racket

(provide word-count)

(define (word-count phrase)
  (let* ([punc-regex #px"[-_!@$%^&.,:]+"]
         [whitespace-regex #px"[\\s\n]+"]
         [phrase (string-replace phrase punc-regex " ")]
         [phrase (string-downcase phrase)]
         [phrase-as-list (string-split phrase whitespace-regex)]
         [phrase-as-list (map (lambda (s) (string-trim s "'")) phrase-as-list)]
         [hash-update!-count
          (lambda (k h) (hash-update h k add1 0))])
    (foldl hash-update!-count (hash) phrase-as-list)
    )
  )
