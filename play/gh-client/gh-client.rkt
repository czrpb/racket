#lang racket

(require net/url)
(require json)

; Parameters
(define user (make-parameter #f))
(define repo (make-parameter #f))
(define pr (make-parameter #f))
(define token (make-parameter #f))

; URL request helpers
(define (make-url-gh/pr user repo pr)
  (string->url (format "https://api.github.com/repos/~a/~a/pulls/~a" user repo pr))
  )

(define (make-header/token token)
  (~a "Authorization: token " token)
  )

; parse command-line
(define action
  (command-line
   #:once-each
   [("-u" "--user") u "User that owns the repo" (user u)]
   [("-r" "--repo") r "Repo to get PRs for" (repo r)]
   [("-n" "--pr") n "PR to get" (pr n)]
   [("-t" "--token") t "Token to access repo" (token t)]
   ))

; PR fields we care about
(define field-regexs
  (hash
   "ref" (regexp "^(FOO-\\d+)")
   "title" (regexp "^(FOO-\\d+): .+$")
   "body" (regexp "# SECTION 1\\r\\n# SECTION 2")
   ))

(define (response->fields resp)
  (values
   (hash-ref resp 'ref)
   (hash-ref resp 'title)
   (hash-ref resp 'body)
   ))

(let*-values
    [
     ((url-gh/pr) (make-url-gh/pr (user) (repo) (pr)))
     ((status-line headers port)
      (http-sendrecv/url url-gh/pr #:headers (list (make-header/token (token))))
      )
     ((resp) (read-json port))
    ;  ((ref title body) (response->fields resp))
    ;  ((ref-valid) (regexp-match (hash-ref field-regexs ref)))
     ]
  (displayln (url->string url-gh/pr))
  (displayln status-line)
  (displayln headers)
  (pretty-display resp)
  ; (displayln (~a "\n" ref " : " ref-valid))
  )
