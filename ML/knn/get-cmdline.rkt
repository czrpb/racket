#lang racket

(provide k k2 field-nums csv-file x y)

; Parameters
(define k (make-parameter 5))
(define k2 (make-parameter #f))
(define field-nums (make-parameter #f))
(define csv-file (make-parameter #f))
(define x (make-parameter #f))
(define y (make-parameter #f))

; parse command-line
(define action
  (command-line
   #:once-each
   [("-k" "--knn") k_ "K Nearest Neighbors" (k k_)]
   [("--k2") k2_ "K Subset Size" (k2 [string->number k2_])]
   [("-f" "--fields") f "Fields" (field-nums [map string->number (string-split f ",")])]
   [("-c" "--csv-file") c "CSV filename" (csv-file c)]
   [("--classify-xy") xy "Classify at the given X,Y"
    (let [(xy [string-split xy ","])]
     (x [(compose string->number first) xy])
     (y [(compose string->number second) xy])
     )]
   ))
