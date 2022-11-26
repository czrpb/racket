#lang racket

(require relation/function)

(let* [
       (dirs-from-cmdline (vector->list (current-command-line-arguments)))

       (directory-list-with-path (λ (d) (directory-list d #:build? #t)))
       (partition-dir-contents (partial partition file-exists?))
       (read-dir (compose list partition-dir-contents directory-list-with-path))
       ]
  (letrec [
           (process (λ [dir]
                      (let* [
                             (files-and-dirs (read-dir dir))
                             (files (car files-and-dirs))
                             (dirs (cadr files-and-dirs))
                             ]
                        (append files (map process dirs))
                        )))
           ]
    (flatten (map process dirs-from-cmdline))
    )
  )