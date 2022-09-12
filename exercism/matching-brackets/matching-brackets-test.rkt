#lang racket/base

(require "matching-brackets.rkt")

(module+ test
  (require rackunit rackunit/text-ui)

  (define suite
    (test-suite
     "matching brackets tests"

     ; Simple passing tests
     (test-eqv? "empty is balenced" (balanced? "") #t)
     (test-eqv? "'[]' is balenced" (balanced? "[]") #t)
     (test-eqv? "'{}' is balenced" (balanced? "{}") #t)
     (test-eqv? "'()' is balenced" (balanced? "()") #t)

     ; Complicated passing tests
     (test-eqv? "'()[]{}' is balenced" (balanced? "()[]{}") #t)
     (test-eqv? "'([{}])' is balenced" (balanced? "([{}])") #t)
     (test-eqv? "'([{}({}[])])' is balenced" (balanced? "([{}({}[])])") #t)

     ; Additional characters but still balenced
     (test-eqv? "'123' is balenced" (balanced? "123") #t)
     (test-eqv? "'[1]' is balenced" (balanced? "[1]") #t)
     (test-eqv? "'(((185 + 223.85) * 15) - 543)/2' is balenced" (balanced? "(((185 + 223.85) * 15) - 543)/2") #t)

     ; Simple failing tests
     (test-eqv? "'][' is UN-balenced" (balanced? "][") #f)
     (test-eqv? "')(' is UN-balenced" (balanced? ")(") #f)
     (test-eqv? "'}{' is UN-balenced" (balanced? "}{") #f)
     (test-eqv? "'(]' is UN-balenced" (balanced? "(]") #f)

     ; Complicated failing tests
     (test-eqv? "'{}[' is UN-balenced" (balanced? "{}[") #f)
     (test-eqv? "'[}]' is UN-balenced" (balanced? "[}]") #f)
     (test-eqv? "'{[}' is UN-balenced" (balanced? "{[}") #f)
     (test-eqv? "'{}[()' is UN-balenced" (balanced? "{}[()") #f)

     ; Additional characters but unbalenced
     (test-eqv? "'(]' is UN-balenced" (balanced? "(1]") #f)
     (test-eqv? "'(]' is UN-balenced" (balanced? "{}[1") #f)

     ))

  (run-tests suite))
