#lang racket

(require (only-in srfi/13 string-map string-reverse string-take string-drop))

(provide encode decode)

(define letters "abcdefghijklmnopqrstuvwxyz")
(define numbers "0123456789")

(define alphabet (string-append letters numbers))
(define tebahpla (string-append (string-reverse letters) numbers))

(define (for/hash-from->to from to)
  (for/hash ([a from] [b to]) (values a b)))

(define (process translation-hash msg bin?)
  (list->string
   (reverse
    (car
     (foldl (match-lambda**
             [(char (cons result counter))
              (let* ([translated-char (hash-ref translation-hash char #f)]
                     [result-with?-space
                      (if (and bin? translated-char (zero? counter))
                          (cons #\  result) result)]
                     [counter+1 (modulo (add1 counter) 5)])
                (if translated-char
                    (cons (cons translated-char result-with?-space) counter+1)
                    (cons result counter)
                    ))])
            (cons '() 5)
            (string->list msg))
     ))))

(define (encode msg)
  (let ([translation-hash (for/hash-from->to alphabet tebahpla)])
    (process translation-hash (string-downcase msg) #t)
    ))

(define (decode msg)
  (let ([translation-hash (for/hash-from->to alphabet tebahpla)])
    (process translation-hash (string-downcase msg) #f)
    ))
