#lang racket

(define (get-lines filename)
  (let [(fh (open-input-file filename #:mode 'text))]
    (sequence->list (in-port read-line fh))
    ))

(let [
      (lines (get-lines "day7-input-example.txt"))
      (process-line (match-lambda**

                     [(dir-sums (regexp #rx"[$] cd (.+)" (list _ rest)))
                      (displayln (cons rest dir-sums))
                      (cons 0 dir-sums)]

                     [(dir-sums (regexp #px"^\\d+" (list size)))
                      (displayln size)
                      (map (λ (s) (+ s (string->number size))) dir-sums)
                      ]

                     [(dir-sums line) dir-sums]
                     ))
      ]
  (let loop [
             (dir-sums '())
             (lines lines)
             ]
    (if (empty? lines)
        dir-sums
        (loop (process-line dir-sums (car lines)) (cdr lines))
        )
    ))
