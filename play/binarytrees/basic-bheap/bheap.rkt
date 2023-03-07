#lang racket

(provide (all-defined-out))

(define (bheap-node data [priority 1] [left (cons '() 0)] [right (cons '() 0)])
  (list (cons priority data) left right)
  )

(define (bheap-add heap new-data new-data-priority)
  (cond
    [(empty? heap) (bheap-node new-data new-data-priority)]
    [
     (match-let [
                 ((list (cons priority data) (cons left lsize) (cons right rsize)) heap)
                 ]
       (cond
         [(< new-data-priority priority) 'na]
         [(= lsize rsize)
          (bheap-node data priority
                      (cons (bheap-add left new-data new-data-priority) (add1 lsize))
                      (cons right rsize))
          ]
         [else
          (bheap-node data priority
                      (cons left lsize)
                      (cons (bheap-add right new-data new-data-priority) (add1 rsize)))
          ]
         )
       )
     ]
    )
  )
