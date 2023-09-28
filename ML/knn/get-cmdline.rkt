#lang racket

(provide key field-nums csv-file x y)

; Parameters
(define key (make-parameter #f))
(define field-nums (make-parameter #f))
(define csv-file (make-parameter #f))
(define x (make-parameter #f))
(define y (make-parameter #f))

; parse command-line
(define action
  (command-line
   #:once-each
   [("-k" "--key-field") k "Key Field" (key k)]
   [("-f" "--fields") f "Fields" (field-nums [map string->number (string-split f ",")])]
   [("-c" "--csv-file") c "CSV filename" (csv-file c)]
   [("--xy") xy "Classify at the given X,Y"
    (let [(xy [string-split xy ","])]
     (x [first xy])
     (y [first xy])
     )]
   ))
