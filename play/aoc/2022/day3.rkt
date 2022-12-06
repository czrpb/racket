#lang at-exp racket

;(require relation/composition)
(require relation/function)

(require "read-input.rkt")

(define test-lines
  (string-split
   @~a{vJrwpWtwJgWrhcsFMMfFFhFp
 jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
 PmmdzqPrVvPwwTWBwg
 wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
 ttgJtRGJQctTZtZT
 CrZsJsPPZsGzwwsLwLmpwMDw}
   "\n")
  )

(define (score item)
  (if (< item 91)
      ; upper case
      (+ (- item 64) 26)
      ; lower case
      (- item 96)
      ))

(define (parse)
  (displayln "starting ...")
  (let* [(lines-fh (read-input "day3-input.txt"))
         (lines (car lines-fh))
         (fh (cdr lines-fh))

         (make-rucksack (λ (rs)
                          (let*-values [((rs) (bytes->list
                                               (string->bytes/latin-1 rs)))
                                        ((rs-size-half) (/ (length rs) 2))
                                        ((rs1 rs2) (split-at rs rs-size-half))
                                        ((rs1 rs2) (values
                                                    (list->set rs1)
                                                    (list->set rs2)))
                                        ]
                            (list (cons rs1 rs2) (set-intersect rs1 rs2))
                            )))

         ]

    (let* [(rs-sums
            (for/list [(rucksack
                        lines
                        ;test-lines
                        )]
              (match-let* [([list (cons rs1 rs2) intersection] [make-rucksack rucksack])
                           (scores (set-map intersection score))
                           (rs-sum [for/sum [(item scores)] item])
                           ]
                (displayln intersection)
                (displayln scores)
                (displayln rs-sum)
                (cons rs-sum intersection)
                )))
           (total (apply + (map car rs-sums)))
           ]
      (displayln rs-sums)
      (displayln total)
      )

    (displayln "\n")

    (let* [(line-to-set (compose list->set bytes->list string->bytes/latin-1))
           (process-line (partial map line-to-set))
           (input (process-line
                   lines
                   ;test-lines
                   ))
           (group-by-3 (let loop [(l input) (a '())]
                         (if (empty? l)
                             a
                             (loop (drop l 3) (cons (take l 3) a)))))
           (intersections (map (partial apply set-intersect) group-by-3))
           (sums (map (λ (intersection)
                        (for/sum [(i intersection)] (score i)))
                      intersections))
           ]
      (displayln group-by-3)
      (displayln intersections)
      (displayln (apply + sums))
      )
    (close-input-port fh)
    )
  )

(parse)