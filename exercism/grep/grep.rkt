#lang racket

(require threading)

(provide grep)

(define (grep flags str file )
  (let* ([join-with-lf (lambda (l) (string-join l "\n"))]
         [format-result (compose join-with-lf reverse)]
         [nats (in-naturals)]
         [lines (in-lines (open-input-file file #:mode 'text))]
         [contains (lambda (line) (string-contains? line str))])
    (format-result
     (for/fold ([result '()]) ([nat nats] [line lines])
       (if (contains line)
           (let* ([add-line-num (member "-n" flags)]
                  [line (if add-line-num
                            (~a nat ":" line) line)])
             (cons line result))
           result)
       ))

    ))

(grep '("-n") "and" "iliad.txt")
