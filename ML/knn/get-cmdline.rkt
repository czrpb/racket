#lang racket

(provide k field-nums csv-file x y)

; Parameters
(define k (make-parameter 5))
(define field-nums (make-parameter #f))
(define csv-file (make-parameter #f))
(define x (make-parameter #f))
(define y (make-parameter #f))

; parse command-line
(define action
  (command-line
   #:once-each
   [("-k" "--knn") k_ "K Nearest Neighbors" (k k_)]
   [("-f" "--fields") f "Fields" (field-nums [map string->number (string-split f ",")])]
   [("-c" "--csv-file") c "CSV filename" (csv-file c)]
   [("--classify-xy") xy "Classify at the given X,Y"
    (let [(xy [string-split xy ","])]
     (x [(compose string->number first) xy])
     (y [(compose string->number second) xy])
     )]
   ))
