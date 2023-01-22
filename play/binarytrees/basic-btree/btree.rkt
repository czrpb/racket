#lang racket

(define make-tree (λ (value [left '()] [right '()])
                    (list value left right)
                    ))

(define (tree-add tree value)
  (if (empty? tree)
      (make-tree value)
      (match-let [((list curr-value left right) tree)]
        (cond
          [(< value curr-value) (make-tree curr-value (tree-add left value) right)]
          [(> value curr-value) (make-tree curr-value left (tree-add right value))]
          [else tree]
          ))
      ))

(define (dfs tree)
  (if (empty? tree)
      '()
      (match-let [((list value left right) tree)]
        (flatten (filter-not empty? (list (dfs left) value (dfs right))))
        )
      )
  )

(define (bfs trees)
  (let loop [(trees trees) (acc '())]
    (if (empty? trees)
        (reverse acc)
        (let* [
               (tree (car trees))
               (value (car tree))
               (children (filter-not empty? (cdr tree)))

               (trees (filter-not empty? (cdr trees)))
               ]
          (loop (append trees children) (cons value acc))
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

(define rand-nums (take (shuffle (range 128)) 32))

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

(displayln "\nDepth:")
(displayln (tree-depth tree))