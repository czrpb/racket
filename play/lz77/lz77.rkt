#lang racket

; See the followings for a description of the LZ77:
;   https://www.infinitepartitions.com/art001.html
;   https://en.wikipedia.org/wiki/LZ77_and_LZ78

; Here we will do a very basic version of it:
;   Tokenize on spaces
;   Replace repeated tokens with their offset from the beginning of the stream
;   Write out the list as a string

(define (lz77 str)
  (let* ([str-list (string-split str)]
         [locations (make-hash)]

         [process (lambda (token acc)
                    (let ([result (car acc)] [curr-pos (cdr acc)])
                      ;(printf "[~a] : ~a\n" result curr-pos)
                      (match (hash-ref locations token 'not-found)
                        ['not-found
                         ;(printf "\t(~a) : ~a\n" token curr-pos)
                         (hash-set! locations token curr-pos)
                         (cons
                          (bytes-append result #" " (string->bytes/latin-1 token))
                          (+ curr-pos (string-length token) 1))]
                        [loc
                         ;(printf "\t<~a> : ~a\n" token loc)
                         (cons
                          (bytes-append result #" " (bytes loc))
                          (+ curr-pos (string-length token) 1))]
                        )))]
         )

    (car (foldl process (cons #""  1) str-list))

    ))

(lz77 "a b c")                       ; <-- "a b c"
(lz77 "the the the")                 ; <-- "the \0 \0"
(lz77 "a b a b c b a b a b a a")     ; <-- "a b \1 \3 c \3 \1 \3 \1 \3 \1 \1"