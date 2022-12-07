#lang at-exp racket

(require relation/function)

(require "read-input.rkt")

(define test-lines
  (string-split
   @~a{2-4,6-8
 2-3,4-5
 5-7,7-9
 2-8,3-7
 6-6,4-6
 2-6,4-8}
   "\n")
  )

(define (parse)
  (displayln "starting ...")
  (let* [(lines-fh (read-input "day4-input.txt"))
         (lines (car lines-fh))
         ;(lines test-lines)
         (fh (cdr lines-fh))

         ; helpers for sections
         (strings->numbers (partial map string->number))
         (make-section (λ (low-high) [range (car low-high) (add1 (cadr low-high))]))
         (strings->sections (compose make-section strings->numbers))

         ; making sections
         (make-section (λ (section)
                         (strings->sections (string-split section "-"))))
         (make-sections (λ (line)
                          (map make-section (string-split line ","))))
         (sections->sets (partial map (partial apply set)))

         ; sets operations
         (sets-subset? (λ (sets)
                         (or
                          (apply subset? sets)
                          (apply subset? (reverse sets))
                          )))

         (sets-intersect? (λ (sets)
                            ;(displayln (apply set-intersect sets))
                            (not (set-empty? (apply set-intersect sets)))
                            ))

         ]

    (displayln
     (for/sum [(line lines)]
       (let* [(sections (make-sections line))
              (sets (sections->sets sections))
              (subset? (sets-subset? sets))
              ]
         (displayln line)
         (displayln sections)
         (displayln sets)
         (displayln subset?)
         (if subset? 1 0)
         ))
     )

    (displayln
     (for/sum [(line lines)]
       (let* [(sections (make-sections line))
              (sets (sections->sets sections))
              (intersect? (sets-intersect? sets))
              ]
         (displayln sets)
         (displayln intersect?)
         (if intersect? 1 0)
         ))
     )

    (close-input-port fh)
    )
  )

(parse)