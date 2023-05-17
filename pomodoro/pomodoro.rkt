#lang racket

(define focus-interval (* 60 45))

(define pct (λ (value)
              (round
               (* 100
                  (/ value focus-interval)))
              ))

(define read (compose string->number read-line open-input-file))
(define started-at (read "/home/czrpb/pomodoro.start" #:mode 'text))

(define current-time (current-seconds))

(let* [
       (since-seconds (- current-time started-at))
       (since-minutes (round (/ since-seconds 60)))
       (since-pct (pct since-seconds))
       ]
  (display (format "~a~a:~a" since-pct "%" since-minutes))
  )