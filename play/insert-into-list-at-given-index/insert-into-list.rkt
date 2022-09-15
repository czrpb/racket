#lang racket

(require racket/hash)

(provide insert-after-index insert-before-index)

(define input1 '(("A" "C" "E") (("B" 1) ("D" 3))))
(define input2 '((1 2 3 4 5 6 7 8 9 10) (("A" 1) ("B" 3) ("C" 6))))

(define (insert-after-index list new-items)
  (let ([new-items-hash (apply hash (flatten (map reverse new-items)))])
    (for/fold
     ([result '()] [list list] #:result (reverse result))
     ([i (range (+ (length list) (length new-items)))])
      (if (hash-has-key? new-items-hash i)
          (values (cons (hash-ref new-items-hash i) result) list)
          (values (cons (car list) result) (cdr list))
          ))
    ))

input1
(printf "   --> ")
(apply insert-after-index input1)

input2
(printf "   --> ")
(apply insert-after-index input2)

(printf "\n")

(define (insert-before-index list new-items)
  (let (
        [new-items-hash (apply hash (flatten (map reverse new-items)))]
        ;[new-items (sort (map reverse new-items) #:key cadr string<?)]
        )
    (flatten
     (for/list ([i (range 0 (length list))] [l list])
       (if (hash-has-key? new-items-hash i)
           (cons (hash-ref new-items-hash i) l)
           l
           )))
    ))

input1
(printf "   --> ")
(apply insert-before-index input1)

input2
(printf "   --> ")
(apply insert-before-index input2)
