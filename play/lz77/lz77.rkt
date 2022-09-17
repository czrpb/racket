#lang racket

; See the followings for a description of the LZ77:
;   https://www.infinitepartitions.com/art001.html
;   https://en.wikipedia.org/wiki/LZ77_and_LZ78

; Here we will do a very basic version of it:
;   Tokenize on spaces
;   Replace repeated tokens with their offset from the beginning of the stream
;   Write out the list as a string

(define (lz77-encode str)
  (let* ([str-list (string-split (string-downcase str) #px"[^a-z]+")]
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

(define test1 "a b c")
(lz77-encode test1)                 ; <-- "a b c"

(define test2 "the the the")
(lz77-encode test2)                 ; <-- "the \0 \0"

(define test3 "a b a b c b a b a b a a")
(lz77-encode test3)                 ; <-- "a b \1 \3 c \3 \1 \3 \1 \3 \1 \1"

(define test4 "this is a test to see if the test will work as a good test or if the test will not work as a test")
(lz77-encode test4)

;(lz77 "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam sed posuere nulla. Maecenas laoreet, libero ut ultricies faucibus, metus sem volutpat neque, ut euismod felis lorem eu tellus. Nam vestibulum blandit justo, in congue lectus. Aenean maximus, mauris ac malesuada venenatis, dui purus dignissim erat, vel pharetra turpis ipsum eu mauris. Nullam id est turpis. Quisque dignissim mi vel nunc semper, sollicitudin viverra ligula vehicula. Sed cursus efficitur ante, ac vestibulum arcu viverra at. Vestibulum quis sagittis purus.")
