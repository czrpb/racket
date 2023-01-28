#lang racket

(require relation/function)

(provide (all-defined-out))

(define make-node (λ (value [left '()] [right '()] [count 1])
                    (list (cons value count) left right)
                    ))

(define (tree-add tree value)
  (if (empty? tree)
      (make-node value)
      (match-let [((list (cons curr-value count) left right) tree)]
        (cond
          [(< value curr-value) (make-node curr-value (tree-add left value) right count)]
          [(> value curr-value) (make-node curr-value left (tree-add right value) count)]
          [(equal? curr-value value) (make-node curr-value left right (add1 count))]
          [else tree]
          ))
      ))

(define (tree->dfs tree)
  (if (empty? tree)
      '()
      (match-let [((list (cons value count) left right) tree)]
        (flatten (filter-not empty? (list (tree->dfs left) (build-list count (λ (_) value)) (tree->dfs right))))
        )
      )
  )

(define (tree->paths tree)
  (letrec [(t->ps (λ (tree path)
                    (match-let* [((list (cons value _count) left right) tree)
                                 (path (cons value path))
                                 (subtrees (filter-not empty? (list left right)))
                                 ]
                      (if (and (empty? left) (empty? right))
                          (list (reverse path))
                          (append* (map (λ (subtree) (t->ps subtree path)) subtrees))
                          )
                      )
                    ))
           ]
    (t->ps tree '())
    )
  )

(define (tree->paths-alt tree)
  (match tree
    ['() (list '())]
    [(list (cons value _) '() '())
     (list (list value))]
    [(list (cons value _) left right)
     (map (partial cons value) (filter-not empty? (append (tree->paths-alt left) (tree->paths-alt right))))]
    )
  )

(define (tree->bfs trees)
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

(define (tree-contains? tree value)
  'na
  )
