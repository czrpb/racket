#lang racket

(displayln "\nStarting ....\n")

(define cmdline
  (match (current-command-line-arguments)
    [(vector dividend divisor _ ...) (cons dividend divisor)]
    ))

(define list->number (compose string->number (curryr string-join "")))

(define (ld divisor dividend (result 0))
  (writeln divisor)
  (writeln dividend)
  (foldl
   (λ (d n-r)
     (let [
           (n (car n-r))
           (r (cdr n-r))
           ]
       (writeln n-r)
       (writeln d)
       )
     )
   (cons (car dividend) 0)
   (cdr dividend)
   )
  )

(match-let*
    [
     ((cons dividend divisor) cmdline)
     ]
  (displayln (ld
   (string->number divisor)
   (map (λ (n) (- (char->integer n) 48)) (string->list dividend)))
   )
  )
