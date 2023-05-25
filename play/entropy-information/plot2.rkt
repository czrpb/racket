#lang racket

(require plot)
(plot-new-window? #t)

(define (log2 v) (log v 2))

(define (entropy pct) (* -1 pct (log2 pct)))

(define (make-freq l)
  (foldl
   (lambda (v h) (hash-update h v add1 0))
   (hash)
   (string->list l)
   )
  )

(define (make-data frequencies)
  (let [
        (h (in-hash frequencies))
        (h-len (apply + (hash-values frequencies)))
        ]
    (for/hash [((k v) h)]
      (let* [
             (pct (/ v h-len))
             (log (log2 pct))
             (entropy (* -1 pct log))
             ]
        (values k (list v pct log entropy))
        )
      )
    )
  )

(define calc (compose make-data make-freq))

(define starting-data "aaaaaaaa")

(define pts
  (let [(max-iterations 9)]
    (let loop [
               (s starting-data)
               (i 0)
               (result '())
               ]
      (if (= i max-iterations)
          (reverse result)
          (let* [(new-s (~a s
                            (make-string
                             i
                             (integer->char (+ 97 i))
                             )
                            ))
                 (r (calc new-s))

                 (r-keys (hash-keys r))
                 (r-keys-length (length r-keys))
                 (r-values (hash-values r))
                 (r-individual-entropies (map fourth r-values))

                 (r-entropy (apply + r-individual-entropies))
                 (r-normalized-entropy
                  (/ r-entropy
                   (if (= r-keys-length 1) 1 (log2 r-keys-length))
                   ))
                 ]
            (loop new-s
                  (add1 i)
                  (cons (list new-s r r-entropy r-normalized-entropy) result))
            )
          )
      )
    )
  )

(pretty-print pts)

; (plot-x-label "Percent / Frequency")
; (plot-y-label "Entropy")
; (plot (append
;        (list (function entropy 0 1
;                        #:y-max 0.532
;                        ;#:y-max 0.16
;                        ;#:y-max 0.37
;                        #:label "Entropy: (* -1 pct (log2 pct))"
;                        ))
;        (map (λ (pct) (point-label (vector pct (entropy pct))))
;             (range 0.025 1 0.025))
;        )
;       )