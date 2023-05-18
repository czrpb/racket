#lang racket

(displayln "\nStarting ....\n")

(define input (vector->list (current-command-line-arguments)))

(define input-len (length input))

(define (make-pct v) (/ v input-len))

(define (make-freq l)
  (foldl
   (lambda (v h) (hash-update h v add1 0))
   (hash)
   l
   )
  )

(define (log2 v) (log v 2))

(define data
  (for/hash [((k v) (in-hash (make-freq input)))]
    (let* [
           (pct (make-pct v))
           (log (log2 pct))
           (entropy (* -1 pct log))
           ]
      (values k (list v pct log entropy))
      )
    )
  )

(let* [
       (total-entropy (apply + (map fourth (hash-values data))))
       (normalized-entropy (/ total-entropy (log2 (length (hash-keys data)))))
       ]
  (pretty-print data)
  (printf "\nTotal entropy: ~a\n" total-entropy)
  (printf "\tNormalized entropy: ~a\n" normalized-entropy)
  )
