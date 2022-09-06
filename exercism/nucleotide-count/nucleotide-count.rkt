#lang racket

(require math/statistics racket/hash)

(provide nucleotide-counts)

(define (nucleotide-counts sequence)
  (let* ([all-nucleotides (hash #\A 0 #\C 0 #\G 0 #\T 0)]
         [sequence (for/list ([s sequence])
                     (if [hash-has-key? all-nucleotides s] s (error "Invalid nucleotide")))])
    (sort
     (hash->list
      [hash-union (hash) ; bit of a hack since hash-union requires JUST the 1st arg to be immutable
                         ; thx to SORAWEE on discord: https://discord.com/channels/571040468092321801/667522224823205889/1016450844360716328
                  (samples->hash sequence)
                  all-nucleotides
                  #:combine/key (lambda (k a b) a)])
     (lambda (p1 p2) (char-ci<? p1 p2)) #:key car
     )))
