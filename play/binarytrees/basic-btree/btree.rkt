#lang racket

(define make-tree (λ (value [left '()] [right '()] [count 1])
                    (list (cons value count) left right)
                    ))

(define (tree-add tree value)
  (if (empty? tree)
      (make-tree value)
      (match-let [((list (cons curr-value count) left right) tree)]
        (cond
          [(< value curr-value) (make-tree curr-value (tree-add left value) right count)]
          [(> value curr-value) (make-tree curr-value left (tree-add right value) count)]
          [(equal? curr-value value) (make-tree curr-value left right (add1 count))]
          [else tree]
          ))
      ))

(define (dfs tree)
  (if (empty? tree)
      '()
      (match-let [((list (cons value count) left right) tree)]
        (flatten (filter-not empty? (list (dfs left) (build-list count (λ (_) value)) (dfs right))))
        )
      )
  )

(define (bfs trees)
  (let loop [(trees trees) (acc '())]
    (if (empty? trees)
        (reverse acc)
        (match-let* [
               (tree (car trees))
               ((cons value count) (car tree))
               (children (filter-not empty? (cdr tree)))

               (trees (filter-not empty? (cdr trees)))
               ]
          (loop (append trees children) (append (build-list count (λ (_) value)) acc))
          )
        )
    )
  )

(define (tree-depth tree)
  (if (empty? tree)
      0
      (max
       (add1 (tree-depth (second tree)))
       (add1 (tree-depth (third tree)))
       )
      )
  )

(define (tree-contains tree value)
'na
)

(define rand-nums [build-list 32 (λ (_) (random 16))])

(define tree
  (let [(nums rand-nums)]
    (displayln "Insertion:")
    (for/fold [(t '())]
              [(n nums)]
      (pretty-print t)
      (tree-add t n)
      )
    )
  )

(displayln "\nRandom numbers:")
(displayln rand-nums)

(displayln "\nFinal:")
(pretty-display tree)

(displayln "\nDFS:")
(displayln (dfs tree))

(displayln "\nBFS:")
(displayln (bfs (list tree)))

(displayln "\nDepth/MinDepth:")
(printf "~a/~a\n" (tree-depth tree) (exact-ceiling (log (length rand-nums) 2)))