#lang racket

(define (new key data (children '())) (list key data children))

(define (find-min h) (cadr h))

(define (meld h1 h2)
  (cond
    [(eq? h1 '()) h2]
    [(eq? h2 '()) h1]
    [else (match-let [
                      ((list h1-key h1-data h1-children) h1)
                      ((list h2-key h2-data h2-children) h2)
                      ]
            (cond
              [(= h1-key h2-key) h2]
              [(< h1-key h2-key) (new h1-key h1-data (cons h2 h1-children))]
              [else (new h2-key h2-data (cons h1 h2-children))]
              )
            )
          ]
    )
  )

(define (meld-pairs children)
  (match children
    [(list c1 c2 children ...) (meld (meld c1 c2) (meld-pairs children))]
    [(list c) c]
    ['() '()]
    )
  )

(define (delete-min h)
  (meld-pairs (caddr h))
  )

; =====================================================

(define (gen-key) (random 1 11))
(define (gen-data) (random 100 201))

(define heaps (map (λ (_) (new (gen-key) (gen-data))) (range 10)))
(pretty-print heaps)

(define h
  (foldl
   (λ (h acc-h) (meld h acc-h))
   (new (gen-key) (gen-data))
   heaps
   )
  )
(pretty-print h)

(displayln (find-min h))

(delete-min h)
