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

@defmodule[Scheme+]{
This package provides the Scheme+ language definitions.

Source code: @url["https://github.com/damien-mattei/Scheme-PLUS-for-Racket"]

Package: @url["https://pkgs.racket-lang.org/package/Scheme-PLUS-for-Racket"]
}


If you just want SRFI-105 Curly Infix in portion of your code or in all your code try using those pragmas in your code:

@racket[BEGIN-STRICT-SRFI-105-REGION]

@racket[END-STRICT-SRFI-105-REGION]

You can also set the flag @racket[srfi-strict] to @racket[#t] in the source code of kernel.rkt.

@hyperlink["https://srfi.schemers.org/srfi-110/srfi-110.html"]{Documentation of the original SRFI 110}
