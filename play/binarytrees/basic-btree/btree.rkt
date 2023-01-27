#lang racket

(require relation/function)

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
                    (match-let* [((list (cons value count) left right) tree)
                                 (path (cons value path))
                                 (subtrees (filter-not empty? (list left right)))
                                 ]
                      (if (and (empty? left) (empty? right))
                          (reverse path)
                          (map (λ (subtree) (t->ps subtree path)) subtrees)
                          )
                      )
                    ))
           (flatten-downto-last-list (λ (lst)
                                       (if [(negate list?) (car lst)]
                                           (list lst)
                                           (let [(node (car lst)) (children (filter-not empty? (cdr lst)))]
                                             (append* (flatten-downto-last-list node) (map flatten-downto-last-list children))
                                             ))))
           ]
    (flatten-downto-last-list (t->ps tree '()))
    )
  )

(define (tree->paths2 tree)
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

(define (tree->paths3 tree)
  (match tree
    ['() (list '())]
    [(list (cons value _) '() '())
     (list (list value))]
    [(list (cons value _) left right)
     (map (partial cons value) (filter-not empty? (append (tree->paths3 left) (tree->paths3 right))))]
    )
  )

(displayln "\nDFS w/ paths:")

(define test-tree-4 [for/fold ((t '())) ((n '(42))) (tree-add t n)])
(displayln test-tree-4)
(displayln (tree->paths test-tree-4))
(displayln (tree->paths3 test-tree-4))

(define test-tree-5 [for/fold ((t '())) ((n '(42 7))) (tree-add t n)])
(displayln test-tree-5)
(displayln (tree->paths test-tree-5))
(displayln (tree->paths2 test-tree-5))
(displayln (tree->paths3 test-tree-5))

(define test-tree-6 [for/fold ((t '())) ((n '(42 49))) (tree-add t n)])
(displayln test-tree-6)
(displayln (tree->paths test-tree-6))
(displayln (tree->paths2 test-tree-6))
(displayln (tree->paths3 test-tree-6))

(define test-tree-7 [for/fold ((t '())) ((n '(42 7 49))) (tree-add t n)])
(displayln test-tree-7)
(displayln (tree->paths test-tree-7))
(displayln (tree->paths2 test-tree-7))
(displayln (tree->paths3 test-tree-7))

(define test-tree [for/fold ((t '())) ((n '(4 2 6 1 3 5 7))) (tree-add t n)])
(displayln test-tree)
(displayln (tree->paths test-tree))
(displayln (tree->paths2 test-tree))
(displayln (tree->paths3 test-tree))

(define test-tree-2 [for/fold ((t '())) ((n '(4 2 6 1 5 7))) (tree-add t n)])
(displayln test-tree-2)
(displayln (tree->paths test-tree-2))
(displayln (tree->paths2 test-tree-2))
(displayln (tree->paths3 test-tree-2))

(define test-tree-3 [for/fold ((t '())) ((n '(1 3 6 9 12))) (tree-add t n)])
(displayln test-tree-3)
(displayln (tree->paths test-tree-3))
(displayln (tree->paths2 test-tree-3))
(displayln (tree->paths3 test-tree-3))

(define test-tree-8 [for/fold ((t '())) ((n '(1 3 6 9 12 5))) (tree-add t n)])
(displayln test-tree-8)
(displayln (tree->paths test-tree-8))
(displayln (tree->paths2 test-tree-8))
(displayln (tree->paths3 test-tree-8))

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
(displayln (tree->dfs tree))

(displayln "\nBFS:")
(displayln (tree->bfs (list tree)))

(displayln "\nPaths:")
(displayln (tree->paths tree))
(displayln (tree->paths2 tree))
(displayln (tree->paths3 tree))

(displayln "\nDepth/MinDepth:")
(printf "~a/~a\n" (tree-depth tree) (exact-ceiling (log (length rand-nums) 2)))