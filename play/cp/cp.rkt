#lang racket

(define-values (ext source dest)
  (command-line
   #:args (ext source dest)
   (values (~a "." ext) source dest)
   )
  )

(current-directory source)

; find-files (lambda (p) (string-suffix? (path->string p) ".epub")) "/mnt/bd1/czrpb/calibre")

(let* [
       (string-endswith-ext (λ (s) (string-suffix? (path->string s) ext)))
       (files (find-files string-endswith-ext source))
       ]
  (for [(f files)]
    (let [(filename (file-name-from-path f))]
      (displayln (~a "cp " (path->string f) " " (~a dest "/" filename)))
      ;(copy-file f (~a dest "/" filename) #t)
      )
    )
  )
