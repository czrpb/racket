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
         [format-line (cond
                        [with-file-names-only (λ (file _line _nat) file)]
                        [(and multiple-files with-linenum) (λ (file line nat) (~a file ":" nat ":" line))]
                        [multiple-files (λ (file line _nat) (~a file ":" line))]
                        [with-linenum (λ (_file line nat) (~a nat ":" line))]
                        [#t (λ (_file line _nat) line)])]

         ; Setup our sequences
         [nats (in-naturals 1)]
         [lines (λ (file) (in-lines (open-input-file file #:mode 'text)))]
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
