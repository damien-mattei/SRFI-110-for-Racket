#! /usr/bin/env racket

;;#lang racket

;; Copyright (C) 2012 David A. Wheeler and Alan Manuel K. Gloria. All Rights Reserved.

;; Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

;; The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

;; modification for Racket by Damien Mattei - 2025

;; use with: racket curly-infix2prefix4racket.rkt [options] file2parse.scm > parsedfile.scm

;; example in DrRacket :

;; with an R6RS file (autodetection):
;; ../SRFI-110-for-Racket/src/curly-infix2prefix4racket.rkt  --verbose ../Scheme-PLUS-for-Racket-R6RS/examples/chaos+.rkt > ../Scheme-PLUS-for-Racket-R6RS/examples/chaos.rkt

;; with a normal Scheme+ file (autodetection):
;; /Applications/Racket\ v8.12/bin/racket curly-infix2prefix4racket.rkt  ../../../../AI_Deep_Learning/exo_retropropagationNhidden_layers_matrix_v2_by_vectors+.rkt > ../../../../AI_Deep_Learning/exo_retropropagationNhidden_layers_matrix_v2_by_vectors.rkt

;; options:

;; --verbose : display code on stderr too 


(module curlyinfix racket


(require racket/pretty) ;; pretty print



(require srfi/31) ;; for 'rec in def.scm

(require SRFI-110/kernel)

(define stderr (current-error-port))

(define stdout (current-output-port))



(define srfi-105 #f)

;; quiet mode that do not display on standart error the code
(define verbose #f)

(define flag-r6rs #f)


;; only this procedure is exactly the same as in main.rkt
(define (skip-comments-and-empty-lines in)
 
  (let loop ()
    (when  (or (regexp-try-match #px"^[[:space:]]" in)  ; skip space,tab,new line,...
	       (regexp-try-match #px"^;[^\n]*\n" in))
      (loop)))  ; and also comments

 
  )
   

(define (literal-read-syntax src)

  (define in (open-input-file src))
  (define lst-code (process-input-code-tail-rec src in))

  lst-code)



;; read all the expression of program
;; a tail recursive version
(define (process-input-code-tail-rec src in) ;; in: port

  (define (process-input-code-rec-tail-recursive acc)
    (define result (mutable-read in src))  ;; read an expression
    (if (eof-object? result)
	(reverse acc)
	(process-input-code-rec-tail-recursive (cons result acc))))


  (when verbose
	(display "SRFI-110 Curly Infix parser with operator precedence by Damien MATTEI" stderr) (newline stderr)
	(display "(based on code from David A. Wheeler and Alan Manuel K. Gloria.)" stderr) (newline stderr) (newline stderr)
	(newline stderr))

  
  (port-count-lines! in) ; turn on counting on port

  (when verbose
    (display "Possibly skipping some header's lines containing space,tabs,new line,etc  or comments or curly infix directives." stderr) (newline stderr) (newline stderr))
  
  (skip-comments-and-empty-lines in)

  ;; search for executable in racket
  (let loop ()
    (define try-read (regexp-try-match #px"^#![[:print:]]*racket" in))
    (when  try-read
	   (when verbose
		 (display "try-read : |" stderr) (display try-read stderr) (display "|" stderr) (newline stderr))
	   (display (car try-read) stdout)  ; re-put it on the output port as we need it in the parsed generated file
	   (newline stdout)
	   (loop)))

  (skip-comments-and-empty-lines in)

  ;; search for curly infix
  (let loop ()
    (when  (regexp-try-match #px"^#!curly-infix[[:blank:]]*\n" in)
      (loop)))

  (skip-comments-and-empty-lines in)

  ;; search for a reader 
  (let loop ()
    (when  (or (regexp-try-match #px"^#lang reader SRFI-105[[:blank:]]*\n" in)
	       (regexp-try-match #px"^#reader SRFI-105[[:blank:]]*\n" in)
               (regexp-try-match #px"^#lang reader SRFI-110[[:blank:]]*\n" in)
	       (regexp-try-match #px"^#reader SRFI-110[[:blank:]]*\n" in))
      ;;(display "srfi 105 or srfi 110") (newline)
      (loop)))

  (skip-comments-and-empty-lines in)

  ;; search for R6RS
  (when (regexp-try-match #px"^#!r6rs[[:blank:]]*\n" in)
	(set! flag-r6rs #t)
	(display "Detected R6RS code: #!r6rs" stderr) (newline stderr) (newline stderr))

  ;; find where the port is set ,line ,column,etc
  (define lc '()) ; line number
  (define cc '())
  (define pc '())
  (set!-values (lc cc pc) (port-next-location in))

  (when verbose
    (display "SRFI-110.rkt : number of skipped lines (comments, spaces, directives,...) at header's beginning : " stderr)
    (display lc stderr)
    (newline stderr)
    (newline stderr)
  
    (display "Parsed curly infix code result = " stderr) (newline stderr) (newline stderr))
  

  (if flag-r6rs
      
      (let ((result (mutable-read in src))) ;; read an expression
	
	(when (eof-object? result)
	    (error "ERROR: EOF : End Of File : " result))
	;;(display "(module aschemeplusr6rsprogram r6rs")
	(display "#!r6rs")
	(newline)
 	
	(pretty-print result
		      stdout
		      1)
	;;(write result)
	;;(newline)
	;;(display ")")
	(newline)
	;;result

	)

      ;; r5rs
      (let ((result (process-input-code-rec-tail-recursive '())))
	(when (null? result)
	  (error "ERROR: Empty program."))

	(for/list ([expr result])
		  (pretty-print expr
				stdout
				1))
	

	)))
	


; parse the input file from command line
(define cmd-ln-vect (current-command-line-arguments))

;;(display "cmd-ln-vect=") (display cmd-ln-vect) (newline)

(define cmd-ln (vector->list cmd-ln-vect))

(define options cmd-ln)
;;(display "options= ") (display options) (newline)

(when (member "--help" options)
      (display "curly-infix2prefix4racket.scm documentation: (see comments in source file for more examples)") (newline) (newline) 
      (display "racket curly-infix2prefix4racket.scm [options] file2parse.scm") (newline) (newline)
      (display "  or simply :") (newline) (newline)
      (display "curly-infix2prefix4racket.scm [options] file2parse.scm") (newline) (newline)
      (display "options:") (newline)(newline)
     ;; (display "  --srfi-105 : set strict compatibility mode with SRFI-105 ") (newline) (newline)
      (display "  --verbose : display code on stderr too ") (newline) (newline)
      (exit))



(when (member "--verbose" options)
      (set! verbose #t))



(define file-name (car (reverse cmd-ln)))

(when (string=? (substring file-name 0 2) "--")
      (error "filename start with -- ,this is confusing with options."))

(define code-lst (literal-read-syntax file-name))

)

