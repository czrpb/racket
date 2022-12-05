#lang racket

(require advent-of-code)

(define action (make-parameter))
(define session (make-parameter))
(define year (make-parameter 2022))
(define day (make-parameter))

(define cmdline (command-line))