#lang racket

(define (get-lines filename)
  (let [(fh (open-input-file filename #:mode 'text))]
    (sequence->list (in-port read-line fh))
    ))

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
                                         (λ (v) (+ (string->number size) v))))
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
