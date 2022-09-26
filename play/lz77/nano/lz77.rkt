#lang racket

(require (only-in srfi/13 string-index))

; See the followings for a description of the LZ77:
;   https://www.infinitepartitions.com/art001.html
;   https://en.wikipedia.org/wiki/LZ77_and_LZ78

; Here we will do a very basic version of it:
;   Tokenize on space+
;   Replace repeated tokens with their offset from the beginning of the stream
;     The offset will be just 1byte and thus the offset can maximally be 255.
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

(define (list-split l v)
  (reverse
   (map reverse
        (for/fold ([acc '(())]) ([e l])
          (case (equal? v e)
            [(#f) (cons (cons e (car acc)) (cdr acc))]
            [(#t) (cons '() acc)]
            )))))

(define (lz77-decode bites)
  (let ([snacks (cdr (list-split (bytes->list bites) 32))])
    (for/fold ([acc ""]) ([snack snacks])
      (let ([acc (string-append acc " ")])
        (~a acc (if (= 1 (length snack))
                (substring acc (car snack) (string-index acc #\  (car snack)))
                (bytes->string/latin-1 (apply bytes snack))
                )))
      )))

(define (gen-text n)
  (let* ([gen-new-word (lambda () [build-string (random 3 7) (lambda (_) [integer->char (random 97 123)])])]
         [gen-word (lambda (text) [if (zero? (random 4))
                                      (vector-ref text (random (vector-length text)))
                                      (gen-new-word)
                                      ])]
         )
    (for/fold ([acc (vector (gen-new-word))]) ([_ (in-range n)])
      (vector-append acc (vector (gen-word acc)))
      )
    ))

(define tests
  (build-list 40
              (lambda (n) [string-join
                           (shuffle
                            (vector->list
                             (gen-text (add1 n)))) " "])
              ))
;tests

(define tests-encoded (map lz77-encode tests))
;tests-encoded

(define tests-decoded (map lz77-decode tests-encoded))


(map (lambda (l) [printf "~v\n\n" l])
     (filter-map (match-lambda
                   [(list l1 l2 l3) (let* ([s1 (string-length l1)]
                                           [s2 (bytes-length l2)]
                                           [%-diff (/ (exact->inexact s2) s1)])
                                      (and (< %-diff 0.8)
                                           (list l1 s1 l2 s2 %-diff l3 (equal? l1 (string-trim l3))))
                                      )])
                 (map list tests tests-encoded tests-decoded)
                 )
     )
