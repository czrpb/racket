#lang racket

(displayln "\nStarting....\n")

(require levenshtein)

(define exts (make-parameter (set)))

(define-values [indirs outdir]
  (command-line
   #:multi ["-e" e "Add to file suffix filter" (exts (set-add (exts) e))]
   #:args [out . ins]
   (values ins out)))

(define [get-files dir exts]
  (let [(exts (set-map exts [λ [ext] (curryr string-suffix? ext)]))]
    (apply set
           (filter [λ [dir] (ormap [λ (ext) (ext dir)] exts)]
                   (map some-system-path->string
                        (directory-list dir))))))

(define infiles
  ([compose (curry apply mutable-set) set->list]
   (foldl [λ [indir acc] (set-union acc (get-files indir (exts)))]
          (get-files (car indirs) (exts)) (cdr indirs)))
  )

(define outfiles (get-files outdir (exts)))

(define [file-match f1 f2]
  (let [
        (f1 (car (string-split f1 ".")))
        (f2 (car (string-split f2 ".")))
        ]
    (when [string-prefix? f1 "violet"] (displayln f1))
    (string-prefix? f1 f2))
  )

(displayln
 [string-join (set->list
               (for*/set [(infile infiles) (outfile outfiles) #:when (file-match outfile infile)]
                 infile
                 ; (set-remove! infiles infile)
                 )
               )
              ]
 )
