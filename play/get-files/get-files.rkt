#lang racket

(require relation/function)

(let* [
       (dirs-from-cmdline (vector->list (current-command-line-arguments)))

       (directory-list-with-path (λ (d) (directory-list d #:build? #t)))
       (partition-dir-contents (partial partition file-exists?))
       (read-dir (compose list partition-dir-contents directory-list-with-path))

       (get-files (partial map car))
       (get-dirs (compose flatten (partial map cadr)))
       ]
  (let loop [(dirs dirs-from-cmdline) (files '())]
    (if (empty? dirs)
        (flatten files)
        (let* [
               (subfiles-and-subdirs (map read-dir dirs))
               (subdirs (get-dirs subfiles-and-subdirs))
               (subfiles (get-files subfiles-and-subdirs))
               ]
          (loop subdirs (append files subfiles))
          )
        )
    ))
