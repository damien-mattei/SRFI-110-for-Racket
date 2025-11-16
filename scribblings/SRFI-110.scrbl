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

Note: Sweet expressions has not been tested, should not be working.

@hyperlink["https://srfi.schemers.org/srfi-110/srfi-110.html"]{Documentation of the original SRFI 110}
