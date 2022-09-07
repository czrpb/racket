#lang racket

(require (only-in srfi/13 string-map string-reverse string-take string-drop))

(provide encode decode)

(define letters "abcdefghijklmnopqrstuvwxyz")
(define numbers "0123456789")

(define alphabet (string-append letters numbers))
(define tebahpla (string-append (string-reverse letters) numbers))

(define (for/hash-from->to from to)
  (for/hash ([a from] [b to]) (values a b)))

(define (translate trans-hash str)
    (string-map (lambda (c) [hash-ref trans-hash c]) str))

(define (process msg from to)
  (letrec ([~alnum #px"[^a-z0-9]"]
           [string-remove-~alnum (lambda (s) [string-replace s ~alnum ""])]
           [clean (compose string-remove-~alnum string-downcase)]
           )
    (translate (for/hash-from->to from to) (clean msg))
    ))

(define (encode m)
  (letrec ([first-^5 (lambda (s) [if (< (string-length s) 5) (string-length s) 5])]
           [string-bin (lambda (s) [let ([avail (first-^5 s)])
                                     (cons (string-drop s avail) (string-take s avail))])]
           [bin (match-lambda** [("" binned) binned]
                                [(s binned) (match-let ([(cons a b) (string-bin s)])
                                              (bin a (string-append binned " " b)))])]
           )
    (string-trim (bin (process m alphabet tebahpla) ""))
    ))

(define (decode m)
  (process m tebahpla alphabet))
