#lang racket

(require threading)

(provide grep)

(define (grep flags str file )
  (let* ([join-with-lf (lambda (l) (string-join l "\n"))]
         [format-result (compose join-with-lf reverse)]
         [nats (in-naturals)]
         [lines (in-lines (open-input-file file #:mode 'text))]
         [matches? (compose
                    (if (member "-v" flags) string-contains? (negate string-contains?))
                    (if (member "-i" flags)
                        (lambda (line str) (values (string-downcase line) (string-downcase str)))
                        (lambda (line str) (values line str)))
                    )]
         )
    (format-result
     (for/fold ([result '()]) ([nat nats] [line lines])
       (if (matches? line str)
           (let* ([line (if (member "-n" flags) (~a nat ":" line) line)]
                  )
             (cons line result))
           result)
       ))

    ))

(grep '("-n") "and" "iliad.txt")
