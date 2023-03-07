#lang racket

(require relation/function)

(define (get-lines filename)
  (let [(fh (open-input-file filename #:mode 'text))]
    (sequence->list (in-port read-line fh))
    ))

(define v1
  (let [
        (lines (get-lines "day7-input-example.txt"))
        (process-line (match-lambda**

                       [((cons curr-path dir-sums) "$ cd ..")
                        (cons (cdr curr-path) dir-sums)
                        ]

                       [((cons curr-path dir-sums) (regexp #rx"[$] cd (.+)" (list _ dir-name)))
                        (cons (cons dir-name curr-path)
                              (hash-set dir-sums (cons dir-name curr-path) 0))
                        ]

                       [((cons curr-path dir-sums) (regexp #px"^\\d+" (list size)))
                        (cons curr-path
                              (hash-update dir-sums curr-path
                                           (partial + (string->number size))))
                        ]

                       [(dir-sums line) dir-sums]
                       ))
        ]
    (let loop [
               (dir-sums (cons '() (hash)))
               (lines lines)
               ]
      (if (empty? lines)
          (cdr dir-sums)
          (loop (process-line dir-sums (car lines)) (cdr lines))
          )
      ))
  )

(displayln v1)

(define (tree-set-deep tree keys value)
  (let [(name (first tree)) (size (second tree)) (subtrees (third tree))
                            (key (car keys)) (keys (cdr keys))
                            ]
    (if (empty? keys)
        (make-node name size (hash-set subtrees key value))
        (hash-set tree key (tree-set-deep (hash-ref subtrees key) keys value))
        )))

(define (make-node name)
  (list name 0 (hash))
  )

(define v2
  (let [
        (lines (get-lines "day7-input-example.txt"))
        ]
    (for/fold [(dir-tree (make-node "root")) (dir-path '()) #:result dir-tree]
              [(line lines)]
      (match line
        ["$ cd .." (values dir-tree (cdr dir-path))]
        [(regexp #rx"[$] cd (.+)" (list _ name))
         (displayln name)
         (let* [(dir-path (cons name dir-path))
                (dir-path-rev (reverse dir-path))]
           (values (tree-set-deep dir-tree dir-path-rev (make-node name)) dir-path)
           )]
        ;[]
        [_ (values dir-tree dir-path)]
        )
      )
    )
  )

;(displayln v2)