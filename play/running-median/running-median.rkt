#lang racket

(require math/statistics)

(define cmdline
  (command-line
   #:args args args))

(define (running-median nums)
  (let [(nums (filter-map string->number nums))]
    (for/fold [(medians (list (car nums)))
               (sorted (list (car nums)))
               #:result (reverse medians)]
              [(num (cdr nums))]
      (let* ([sorted (sort (cons num sorted) <)]
             [median (median < sorted)]
             [medians (cons median medians)])
        (values medians sorted))
      )))

(printf "~a\n" (running-median cmdline))