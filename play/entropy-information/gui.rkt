#lang racket

(require monotonic
         racket/gui/easy)

(struct sym (chr cnt))

(define @symbols (obs '()))

(define (new-symbol syms)
  (text "new symbol")
  )

(render
 (window
  #:title "Entropy"
  (vpanel
   #:style '(border)
   (vpanel
    #:stretch '(#f #f)
    (button "Add Symbol"
            (λ () (obs-update! @symbols (λ (syms) (cons (sym (current-monotonic-nanoseconds) 1) syms)))))
    )
   (list-view
    #:key sym-chr
    @symbols
    (λ (chr @symbol)
      (text (~a chr))
      )
    )
   (vpanel
    #:stretch '(#f #f)
    (spacer)
    (text (make-string 64 #\-))
    (spacer)
    (text "Calculations to come!")
    )
   )
  )
 )
