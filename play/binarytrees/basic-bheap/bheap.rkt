#lang racket

(provide (all-defined-out))

(define (heap-node data [priority 1] [left (cons '() 0)] [right (cons '() 0)])
  (list (cons priority data) left right)
  )

(define (bheap-add heap data priority)
  (if (empty? heap)
      (heap-node data priority)
      'na
      )
  )