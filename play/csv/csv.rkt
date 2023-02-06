#lang racket

(require net/base64)

; Parameters
(define csv-file (make-parameter #f))

; parse command-line
(define action
  (command-line
   #:once-each
   [("-f" "--cvs-file") c "CVS filename" (csv-file c)]
   ))

(define (basic-auth-header user pass)
  (format "Authorization: Basic ~a"
          (base64-encode (string->bytes/latin-1 (~a user ":" pass))))
  )

(let* [
       (csv-fh (open-input-file (csv-file) #:mode 'text))
       (csv-lines (for/list [(line (in-lines csv-fh))] (string-split line #px"\\s*,\\s*")))
       ]
  (for/list [(line csv-lines)]
    (displayln line)
    )
  )