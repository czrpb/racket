#lang racket

(require "btree.rkt")

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

(displayln "\nDFS w/ paths:")

(define test-tree-4 [for/fold ((t '())) ((n '(42))) (tree-add t n)])
(displayln test-tree-4)
(displayln (tree->paths test-tree-4))

(define test-tree-5 [for/fold ((t '())) ((n '(42 7))) (tree-add t n)])
(displayln test-tree-5)
(displayln (tree->paths test-tree-5))

(define test-tree-6 [for/fold ((t '())) ((n '(42 49))) (tree-add t n)])
(displayln test-tree-6)
(displayln (tree->paths test-tree-6))

(define test-tree-7 [for/fold ((t '())) ((n '(42 7 49))) (tree-add t n)])
(displayln test-tree-7)
(displayln (tree->paths test-tree-7))

(define test-tree [for/fold ((t '())) ((n '(4 2 6 1 3 5 7))) (tree-add t n)])
(displayln test-tree)
(displayln (tree->paths test-tree))

(define test-tree-2 [for/fold ((t '())) ((n '(4 2 6 1 5 7))) (tree-add t n)])
(displayln test-tree-2)
(displayln (tree->paths test-tree-2))

(define test-tree-3 [for/fold ((t '())) ((n '(1 3 6 9 12))) (tree-add t n)])
(displayln test-tree-3)
(displayln (tree->paths test-tree-3))

(define test-tree-8 [for/fold ((t '())) ((n '(1 3 6 9 12 5))) (tree-add t n)])
(displayln test-tree-8)
(displayln (tree->paths test-tree-8))

(displayln "\nBFS:")
(displayln (tree->bfs (list tree)))

(displayln "\nPaths:")
(displayln (tree->paths tree))

(displayln "\nDepth/MinDepth:")
(printf "~a/~a\n" (tree-depth tree) (exact-ceiling (log (length rand-nums) 2)))
