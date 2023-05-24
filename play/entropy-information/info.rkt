#lang racket

(displayln "\nStarting ....\n")

(define (log2 v) (log v 2))
(define (make-freq l)
  (foldl
   (lambda (v h) (hash-update h v add1 0))
   (hash)
   l
   )
  )

; =====================================

(define input
  (match-let
      [((vector filename _ ...) (current-command-line-arguments))]
    (let [(content (port->string (open-input-file filename #:mode 'text)))]
      (string-split content)
      )
    )
  )

(define input-len (length input))
(define (input-pct v) (/ v input-len))
(define input-freq (make-freq input))

; =====================================

(define data
  (for/hash [((k v) (in-hash input-freq))]
    (let* [
           (pct (input-pct v))
           (log (log2 pct))
           (entropy (* -1 pct log))
           ]
      (values k (list v pct log entropy))
      )
    )
  )

(define data-log2 (log2 (length (hash-keys data))))

; =====================================

(let* [
       (total-entropy (apply + (map fourth (hash-values data))))
       (normalized-entropy (if (zero? data-log2) 0 (/ total-entropy data-log2)))
       ]
  (pretty-print data)
  (printf "\nTotal entropy: ~a\n" total-entropy)
  (printf "\tNormalized entropy (or surprize): ~a\n" normalized-entropy)
  (printf "\tInformation (1 - surprize): ~a\n" (- 1 normalized-entropy))
  )
