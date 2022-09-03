#lang racket

(require math/statistics)

(provide word-count)

(define (word-count phrase)
  (let* ([punc-regex #px"[-_!@$%^&.,:]+"]
         [whitespace-regex #px"[\\s\n]+"]
         [phrase (string-replace phrase punc-regex " ")]
         [phrase (string-downcase phrase)]
         [phrase-as-list (string-split phrase whitespace-regex)]
         [phrase-as-list (map (lambda (s) (string-trim s "'")) phrase-as-list)])
    (samples->hash phrase-as-list)
    )
  )
