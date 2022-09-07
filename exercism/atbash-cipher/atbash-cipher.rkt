#lang racket

(require (only-in srfi/13 string-map string-reverse string-take string-drop))

(provide encode decode)

(define letters "abcdefghijklmnopqrstuvwxyz")
(define numbers "0123456789")

(define alphabet (string-append letters numbers))
(define tebahpla (string-append (string-reverse letters) numbers))

(define to-from (for/hash ([a alphabet] [z tebahpla])
                  (values a z)))
(define to->from (lambda (str)
                   (string-map (lambda (c)
                                 (hash-ref to-from c))
                               str)))

(define from-to (for/hash ([a alphabet] [z tebahpla])
                  (values z a)))
(define from->to (lambda (str)
                   (string-map (lambda (c)
                                 (hash-ref from-to c))
                               str)))

(define (process m direction)
  (letrec ([alnum #px"[^a-z0-9]"]
           [string-remove-non-alnum (lambda (s)
                                      (string-replace s alnum ""))]
           [clean (compose string-remove-non-alnum string-downcase)]
           )
    (direction (clean m))
    ))

(define (encode m)
  (letrec ([string-length-remaining-or-5 (lambda (s) (if (< (string-length s) 5)
                                                         (string-length s) 5))]
           [bin (match-lambda** [("" binned) binned]
                                [(s binned) (bin (string-drop s (string-length-remaining-or-5 s))
                                                 (string-append binned " "
                                                                (string-take s
                                                                             (string-length-remaining-or-5 s))))])]
           )
    (string-trim (bin (process m to->from) ""))
    ))

(define (decode m)
  (process m from->to)
  )
