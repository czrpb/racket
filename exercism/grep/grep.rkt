#lang racket

(provide grep)

(define (grep flags str files)
  (let* ([nats (in-naturals 1)]
         [lines (lambda (file) (in-lines (open-input-file file #:mode 'text)))]
         [str-match-fn (if (member "-x" flags) equal? string-contains?)]
         [matches? (compose
                    (if (member "-v" flags) (negate str-match-fn) str-match-fn)
                    (if (member "-i" flags)
                        (lambda (line str) (values (string-downcase line) (string-downcase str)))
                        (lambda (line str) (values line str)))
                    )]
         )
    (flatten
     (map (lambda (file)
            (reverse
             (for/fold ([result '()]) ([nat nats] [line (lines file)])
               (if (matches? line str)
                   (let* ([update-line-flags
                           (compose
                            (lambda (line)
                              [if (and (member "-l" flags) (or (empty? result) (not (equal? file (car result)))))
                                  file line])
                            (lambda (line)
                              [if (> (length files) 1) (~a file ":" line) line])
                            (lambda (line)
                              [if (member "-n" flags) (~a nat ":" line) line])
                            )])
                     (cons (update-line-flags line) result))
                   result)
               )))
          files)
     )))
