#lang racket

(require net/base64)

; Parameters
(define csv-file (make-parameter #f))

; parse command-line
(define action
  (command-line
   #:once-each
   [("-f" "--csv-file") c "CSV filename" (csv-file c)]
   ))

(define (basic-auth-header user pass)
  (format "Authorization: Basic ~a"
          (base64-encode (string->bytes/latin-1 (~a user ":" pass))))
  )

(define (csv-file-read csv-file field-sep)
  (let* [
         (csv-line-split (λ (line) (regexp-split field-sep (string-trim line "\""))))

         (csv-fh (open-input-file csv-file #:mode 'text))
         (header-line (csv-line-split (read-line csv-fh)))
         (header-line-len (length header-line))
         ]
    (for/list [(line (in-lines csv-fh))]
      (let [(fields (csv-line-split line))]
        (if [(negate =) header-line-len (length fields)]
            (raise "Failed to split record correctly; wrong number of resultant fields.")
            fields
            )
        )
      )
    )
  )

(csv-file-read (csv-file) #px"\\s*\",\"\\s*")
