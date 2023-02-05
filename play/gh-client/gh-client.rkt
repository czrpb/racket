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
  ;(values "api.github.com" (format "/repos/~a/~a/pulls/~a" user repo pr))
  )

(define (make-header/token token)
  (~a "Authorization: Bearer " token)
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
   'ref (regexp "^(FOO-\\d+)")
   'title (regexp "^(FOO-\\d+): .+$")
   'body (regexp "# TITLE\r?\n\r?\n.*# JIRA ID")
   ))

(define (response->fields resp)
  (values
   (hash-ref (hash-ref resp 'head) 'ref)
   (hash-ref resp 'title)
   (hash-ref resp 'body)
   ))

(let*-values
    [
     ((url-gh/pr) (make-url-gh/pr (user) (repo) (pr)))
     ((port)
      (get-pure-port url-gh/pr (list (make-header/token (token))) #:redirections 5)
      )
     ((resp) (read-json port))
     ((ref title body) (response->fields resp))
     ]
  (printf "Successfully got and parsed PR: ~a\n\n" (pr))

  (let [(ref-valid (regexp-match (hash-ref field-regexs 'ref) ref))]
    (printf "\t~aBranch~aconforms to expected pattern.\n"
            (if ref-valid "   " "!!! ")
            (if ref-valid " " " does not ")
            ))

  (let [(title-valid (regexp-match (hash-ref field-regexs 'title) title))]
    (printf "\t~aTitle~aconforms to expected pattern.\n"
            (if title-valid "    " "!!! ")
            (if title-valid " " " does not ")
            ))

  (let [(body-valid (regexp-match (hash-ref field-regexs 'body) body))]
    (printf "\t~aBody~aconforms to expected pattern.\n"
            (if body-valid "    " "!!! ")
            (if body-valid " " " does not ")
            ))
  )
