#lang scribble/manual

@title{SRFI-110 "Curly Infix,Neoteric and Sweet expressions" for Racket}

@author[(author+email "Damien MATTEI" "Damien.MATTEI@univ-cotedazur.fr")]

@bold{Scheme Request For Implementations 110}

Install as a package.
 
Use:

#lang reader SRFI-110

or:

@defmodule[SRFI-110 #:reader]{
This reader package provides the SRFI-110 Curly Infix,Neoteric and Sweet expressions reader/parser.

Source code: @url["https://github.com/damien-mattei/SRFI-110-for-Racket"]

Package: @url["https://pkgs.racket-lang.org/package/SRFI-110-for-Racket"]
}


Designed to be used with Scheme+:

@defmodule[Scheme+ #:no-declare #:link-target? #f]{
This package provides the Scheme+ language definitions.

Source code: @url["https://github.com/damien-mattei/Scheme-PLUS-for-Racket"]

Package: @url["https://pkgs.racket-lang.org/package/Scheme-PLUS-for-Racket"]
}

Sweet-expressions (indentation) work in files: the reader reads a file as sweet-expressions, and code written with parenthesis gives the same forms. Scheme+ can be written with this syntax (see @tt{examples/sweet-expressions+.rkt}):

@codeblock|{
#lang reader SRFI-110
module m racket
  require Scheme+
  define (f x)
    {x + 1}
  display f(2)
}|

gives @racket[(module m racket (require Scheme+) (define (f x) (+ x 1)) (display (f 2)))]. With the pragma @racket[BEGIN-STRICT-SRFI-105-REGION] the curly brackets follow SRFI 105 (@racket[{a * b + c}] is @racket[($nfx$ a * b + c)]): the test suite of sweet-expressions of the Readable project then passes as with the original reader (see @secref["strict"]).

An empty line ends an expression: inside a block, separate the lines with comment lines. The blocks of the @racket[if] of Scheme+ can be indented under @racket[then] and @racket[else] (they are read as @racket[(then …)] and @racket[(else …)], which the @racket[if] accepts); the keyword that ends a loop (@racket[while] of @racket[do], @racket[until] of @racket[repeat]) is written alone on its line, at the level of the expressions. @litchar{!} at the beginning of a line is an indentation character (write @racket[{n !}] or @racket[(! n)] for the factorial). The REPL stays in curly infix: in sweet-expressions an input ends only with an empty line.

A file is read as sweet-expressions. As specified by SRFI 110, a parsing directive written alone at the beginning of a line (but not as the very first characters of the file) changes the reading of the file from the next datum: @litchar{#!curly-infix} reads the rest of the file with the rules of SRFI 105, which accept all the standard Scheme, even two forms glued without a space such as @litchar{(display x)(newline)} (in sweet-expressions, as in SRFI 110, it is the call @racket[((display x) newline)]); @litchar{#!sweet} goes back to the sweet-expressions; @litchar{#!no-sweet} reads with the @racket[read] of Racket. For example, a file written in standard Scheme with curly brackets can begin with:

@verbatim{
#reader SRFI-110
#!curly-infix
}

@section{Pragmas}

A pragma is a bare symbol written in the source code: it is recognized by the reader while it reads the file, not by the Racket compiler, and it does not remain in the code.

@tabular[#:style 'boxed
         #:sep @hspace[2]
         #:row-properties '(bottom-border ())
         (list (list @bold{Pragmas} @bold{Effect} @bold{At the beginning of each file} @bold{Region})
               (list @elem{@racket[BEGIN-STRICT-SRFI-105-REGION] @linebreak[] @racket[END-STRICT-SRFI-105-REGION]}
                     @elem{the curly brackets follow SRFI 105 @linebreak[] (see @secref["strict"]) or the rules of Scheme+}
                     "rules of Scheme+"
                     @elem{from the pragma to the other one @linebreak[] or to the end of the file})
               (list @elem{@racket[ANNOTATION-ON] @linebreak[] @racket[ANNOTATION-OFF]}
                     @elem{type annotation and inference pass of Scheme+ @linebreak[] on or off}
                     "off"
                     @elem{the elements that follow the pragma in the same list @linebreak[] and all that is nested in them})
               (list @elem{@racket[CARE-OF-QUOTES-ON] @linebreak[] @racket[CARE-OF-QUOTES-OFF]}
                     @elem{the quoted lists are data, @linebreak[] or infix expressions (symbolic computation)}
                     "on (data)"
                     @elem{as @racket[ANNOTATION-ON]}))]

A pragma is written alone, or alone in curly brackets (@litchar{{BEGIN-STRICT-SRFI-105-REGION}}); in sweet-expressions it is written alone on its line. It can be written inside a list (the body of the module form, of a procedure, ...) or at the top level of the file, before the module form, where it acts on the whole module. A pragma acts only on the file where it is written, not on the modules this file requires: each file starts in the state of the table.

@subsection[#:tag "strict"]{Strict mode: using the reader as the original SRFI 110}

Between @racket[BEGIN-STRICT-SRFI-105-REGION] and @racket[END-STRICT-SRFI-105-REGION] the reader follows SRFI 110, as the original reader. The curly brackets follow SRFI 105: @racket[{a}] is @racket[a], @racket[{a b}] is @racket[(a b)], @racket[{a op b op c}] with a single operator is @racket[(op a b c)] (also with @racket[if]), the @racket[( )] are not infix, and the other expressions are @racket[($nfx$ …)]. The neoteric expressions (@litchar{f(x)}, @litchar{f{x}}, @litchar{x[i]}) and the sweet-expressions work as in SRFI 110; unlike SRFI 105, the neoteric expressions are recognized everywhere, in both modes. The test suite of the sweet-expressions of the Readable project then passes as with the original reader (@tt{examples/sweet-testsuite/run-sweet-testsuite.rkt}).

The main differences with the rules of Scheme+:

@tabular[#:style 'boxed
         #:sep @hspace[2]
         #:row-properties '(bottom-border ())
         (list (list @bold{Expression} @bold{Scheme+} @bold{Strict mode})
               (list @racket[{a + b * c}] @racket[(+ a (* b c))] @racket[($nfx$ a + b * c)])
               (list @racket['{a + b * c}] @racket['(+ a (* b c))] @racket['($nfx$ a + b * c)])
               (list @racket[{n !}] @racket[(! n)] @racket[(n !)])
               (list @racket[{a if b}] @racket[(if b a)] @racket[(if a b)])
               (list @racket[{f x}] "decided at run time" @racket[(f x)])
               (list @elem{@racket[{a + b + c}] , @racket[{- x}] , @racket[{x}]} @elem{@racket[(+ a b c)] , @racket[(- x)] , @racket[x]} "the same"))]

Racket defines neither @racket[$nfx$] (used for the expressions that are not simple infix) nor @racket[$bracket-apply$] (used for @litchar{x[i]}): SRFI 105 leaves them to the programmer. Define them yourself, or take them from Scheme+, where @racket[$nfx$] evaluates the expression with the precedence of the operators. A whole file in strict mode, written with sweet-expressions, as with the original reader:

@codeblock|{
#lang reader SRFI-110
BEGIN-STRICT-SRFI-105-REGION
module m racket
  require (only-in Scheme+ $nfx$ $bracket-apply$)
  define f(x) {x * 2}
  define v #(10 20 30)
  display $ list {2 + 3 * 4} {f(5) + v[1] * 2} '{a + b * c}
  newline()
}|

displays @racket[(14 50 ($nfx$ a + b * c))].

At the REPL, which stays in curly infix, type the pragma alone (or alone in curly brackets): the mode changes for the rest of the session.

@subsection{Type annotation: ANNOTATION-ON and ANNOTATION-OFF}

The pragmas @racket[ANNOTATION-ON] and @racket[ANNOTATION-OFF] turn on or off, by region, the type annotation and inference pass of Scheme+ (see the section @hyperlink["https://docs.racket-lang.org/Scheme-PLUS-for-Racket/index.html#%28part._annotation%29"]{Type annotation and inference} of the Scheme+ documentation): a pragma acts on the elements that follow it in the same list and on all that is nested in them, until the other pragma or the end of the list. The pass is off at the beginning of each file: a pragma acts only on the file where it is written, not on the modules this file requires. It can be written inside the module form or at the top level of the file (before the module form, it acts on the whole module).

@subsection{Quoted lists: CARE-OF-QUOTES-ON and CARE-OF-QUOTES-OFF}

The pragmas @racket[CARE-OF-QUOTES-ON] and @racket[CARE-OF-QUOTES-OFF] act by region too, on the quoted lists (see the section Pragmas of the Scheme+ documentation): with @racket[CARE-OF-QUOTES-ON], the state at the beginning of each file, a quoted list is data and a quoted @racket[{ }] is converted at its top level only; @racket[CARE-OF-QUOTES-OFF] opens a region for the symbolic computation, where the quoted and quasiquoted lists are infix expressions at all levels (@litchar{'(x + y * z)} is @racket['(+ x (* y z))]).

@section{Converting a Scheme+ file into a Scheme file}

The command line tool @tt{src/curly-infix2prefix4racket.rkt} of this package converts a Scheme+ file into the Racket code that the reader gives to the compiler, for example to debug it with the Racket tools (error line numbers, macro stepper, ...):

@verbatim{racket curly-infix2prefix4racket.rkt [--verbose] file+.rkt > file.rkt}

The converted code is written on the standard output. When the Scheme+ file has the pragma @racket[ANNOTATION-ON], it is the annotated code, the same as the code compiled by the reader; it never contains the @racket[type] forms nor the pragmas. With the option @tt{--verbose}, the banner and the state of the type annotation are displayed on the error output.

@hyperlink["https://srfi.schemers.org/srfi-110/srfi-110.html"]{Documentation of the original SRFI 110}
