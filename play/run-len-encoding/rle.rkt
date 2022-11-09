#lang racket

(provide rle)

; (define (rle l)
;   (let loop [(l (cdr l)) (acc (list (cons (car l) 1)))]
;     (match* (l acc)
;       [('() acc) (reverse acc)]
;       [((cons h t) (cons (cons h ht) at))
;        (loop t (cons (cons h (add1 ht)) at))]
;       [((cons h t) acc)
;        (loop t (cons (cons h 1) acc))]
;       )))

; (define (rle l)
;   (define/match (rle_ l acc)
;     [('() acc) (reverse acc)]

;     [((cons h t) (cons (cons h ht) at))
;      (rle_ t (cons (cons h (add1 ht)) at))]

;     [((cons h t) acc)
;      (rle_ t (cons (cons h 1) acc))]
;     )
;   (rle_ (cdr l) (list (cons (car l) 1))))

; (define (rle l)
;   (for/fold [(acc '())
;              #:result (reverse acc)]
;             [(n l)]
;     (match acc
;       [(cons (cons (== n) c) t) (cons (cons n (add1 c)) t)]
;       [_ (cons (cons n 1) acc)]
;       )))

(define (rle l)
  (let loop [(l (cdr l)) (v (car l)) (c 1) (acc '())]
    (cond
      [(empty? l) (reverse (cons (cons v c) acc))]
      [(equal? (car l) v) (loop (cdr l) v (add1 c) acc)]
      [true (loop (cdr l) (car l) 1 (cons (cons v c) acc))]
      )
    )
  )

(define test1 '(1 2 2 2 3 4 4 5 6 6 6 6))
(define result1 '(1 (2 3) 3 (4 2) 5 (6 4)))

