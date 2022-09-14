#lang racket

(provide grep)

(define (grep flags str files)
  (let* (
         ; These affect how the results are displayed
         [with-linenum (member "-n" flags)]
         [with-file-names-only (member "-l" flags)]
         [multiple-files (< 1 (length files))]

         ; These affect how the match is made
         [with-insensitive (member "-i" flags)]
         [with-inverted (member "-v" flags)]
         [with-entire-line (member "-x" flags)]

         ; Setup the matching logic
         [str (regexp (match* (with-insensitive with-entire-line)
                        [(#f #f) str]
                        [(_ #f) (~a "(?i:" str ")")]
                        [(#f _) (~a "^" str "$")]
                        [(_ _) (~a "^(?i:" str ")$")]))]
         [str-match? (if with-inverted (negate regexp-match) regexp-match)]

         ; Setup the display logic
         [format-line (if with-file-names-only
                          (lambda (file _ _2) file)
                          (lambda (file line nat)
                            [cond
                              [(and multiple-files with-linenum) (~a file ":" nat ":" line)]
                              [multiple-files (~a file ":" line)]
                              [with-linenum (~a nat ":" line)]
                              [#t line]]))]

         ; Setup our sequences
         [nats (in-naturals 1)]
         [lines (lambda (file) (in-lines (open-input-file file #:mode 'text)))]
         )
    (reverse
     (remove-duplicates
      (for/fold ([acc '()]) ([file files])
        (for/fold ([acc acc]) ([nat nats] [line (lines file)])
          (if (str-match? str line)
              (cons (format-line file line nat) acc)
              acc
              )
          ))))
    ))
