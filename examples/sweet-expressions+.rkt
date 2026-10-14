#lang reader SRFI-110

; Scheme+ written with the sweet-expressions of SRFI 110 : the indentation gives the parenthesis
; (inside ( ) [ ] { } the indentation is not taken into account, as in SRFI 110).
; An empty line ends the expression : inside the module the lines are separated by comment lines.
; Run it with :   racket sweet-expressions+.rkt
; A silent run (only the parser trace) means every check passed.

module sweet-expressions racket
  ;
  require Scheme+ rackunit
  ANNOTATION-ON
  ;
  define (square x)
    {x * x}
  ;
  define (apply-op op a)
    op a
  ;
  ; a procedure defined above is known by the infix parser : (apply-op - 3) is a call , not (- apply-op 3)
  {r1 := (apply-op - 3)}
  check-equal? r1 -3
  ;
  ; the type annotation works in an indented body : {x + y} becomes (fl+ x y)
  define (fsum x y)
    type flonum? x y
    {x + y}
  check-equal? fsum(1.5 2.5) 4.0
  ;
  ; neoteric expressions and postfix
  check-equal? square(5) 25
  {n := 5}
  check-equal? {n !} 120
  ;
  ; let with the group marker \\ , and the sublist marker $
  check-equal?
    let
      \\
        a 1
        b 2
      {a + b}
    3
  define nine
    list $ square 3
  check-equal? nine '(9)
  ;
  ; comments : #; followed by a space comments the line , #| |# is a block comment
  #; display "this line is ignored"
  check-equal? square(2) 4 #| a block comment at the end of a line |#
  ;
  ; a region for the symbolic computation : the quoted lists are infix expressions
  CARE-OF-QUOTES-OFF
  {formula := '(Bₖ · Bₖ₋₁ ⊕ Cₖ · (Bₖ ⊕ Bₖ₋₁))}
  CARE-OF-QUOTES-ON
  check-equal? formula '(⊕ (· Bₖ Bₖ₋₁) (· Cₖ (⊕ Bₖ Bₖ₋₁)))
  ;
  ; the strict SRFI 105 mode : {2 + 3 * 4} is ($nfx$ 2 + 3 * 4) , evaluated by the macro $nfx$ of Scheme+
  BEGIN-STRICT-SRFI-105-REGION
  check-equal? {2 + 3 * 4} 14
  END-STRICT-SRFI-105-REGION
  ;
  display "sweet-expressions+ : all the checks are done"
  newline()
