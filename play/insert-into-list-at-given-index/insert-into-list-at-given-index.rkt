#lang racket

(require racket/hash)

(provide insert-new-index insert-before-index)

(define (insert-new-index list new-items)
  (let (
        [list-hash (apply hash (flatten (map cons (range 0 (length list)) list) ))]
        [new-items-hash (apply hash (flatten (map reverse new-items)))]
        )
    (for/fold
     ([result '()] [list list] #:result (reverse result))
     ([i (range (+ (length list) (length new-items)))])
      (if (hash-has-key? new-items-hash i)
          (values (cons (hash-ref new-items-hash i) result) list)
          (values (cons (car list) result) (cdr list))
          ))
    ))

(insert-new-index '("A" "C" "E") '(("B" 1) ("D" 3)))
(insert-new-index '(1 2 3 4 5 6 7 8 9 10) '(("A" 1) ("B" 3) ("C" 6)))
(printf "\n")

(define (insert-before-index list new-items)
  (let (
        [new-items-hash (apply hash (flatten (map reverse new-items)))]
        ;[new-items (sort (map reverse new-items) #:key cadr string<?)]
        )
    (flatten
     (for/list ([i (range 0 (length list) )] [l list])
       (if (hash-has-key? new-items-hash i)
           (cons (hash-ref new-items-hash i) l)
           l
           )))
    ))

(insert-before-index '("A" "C" "E") '(("B" 1) ("D" 3)))
(insert-before-index '(1 2 3 4 5 6 7 8 9 10) '(("A" 1) ("B" 3) ("C" 6)))
