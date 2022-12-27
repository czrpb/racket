#lang racket

(require net/url)

(define user (make-parameter #f))
(define repo (make-parameter #f))

(define url-pr-format "https://github.com/repos/~a/~a/pulls")

(define action
  (command-line
   #:once-each
   [("-u" "--user") u "User that owns the repo" (user u)]
   [("-r" "--repo") r "Repo to get PRs for" (repo r)]
   ))

(let
    [(url-pr (format url-pr-format (user) (repo)))]
  (displayln url-pr)
  )
