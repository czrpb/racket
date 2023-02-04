#lang racket

(require net/url)
(require json)

(define user (make-parameter #f))
(define repo (make-parameter #f))
(define pr (make-parameter #f))
(define token (make-parameter #f))
;(define token "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")
(define header-token (~a "Authorization: token " token))

(define (make-url-gh/pr user repo pr)
  (string->url (format "https://api.github.com/repos/~a/~a/pulls/~a" user repo pr))
  )

(define action
  (command-line
   #:once-each
   [("-u" "--user") u "User that owns the repo" (user u)]
   [("-r" "--repo") r "Repo to get PRs for" (repo r)]
   [("-n" "--pr") n "PR to get" (pr n)]
   [("-t" "--token") n "Token to access repo" (token t)]
   ))

(let*-values
    [
     ((url-gh/pr) (make-url-gh/pr (user) (repo) (pr)))
     ((status-line headers port) (http-sendrecv/url url-gh/pr #:headers (list header-token)))
     ((resp) (read-json port))
     ]
  (displayln (url->string url-gh/pr))
  (displayln status-line)
  (displayln headers)
  (pretty-display resp)
  )
