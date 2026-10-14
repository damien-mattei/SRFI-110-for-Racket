#lang racket/base

;; Run the test suite of the sweet-expression reader (SRFI 110) of the "Readable Lisp S-expressions Project"
;; (sweet-testsuite.txt , next to this file) with the reader of SRFI-110-for-Racket.
;;
;; Run it with :   racket run-sweet-testsuite.rkt
;;
;; The file holds pairs : the expected result written as a traditional S-expression (read by read) , then the same
;; expression written as a sweet-expression (read by sweet-read). Same principle as the program tests/sweet-test of the
;; Readable project.
;;
;; The suite is run twice :
;; - in the strict SRFI 105 mode : the curly brackets follow SRFI 105 ({a * b + c} is ($nfx$ a * b + c)) , as the
;;   original reader : all the tests must pass ;
;; - in the mode of Scheme+ : the curly brackets follow the rules of Scheme+ ({a * b + c} is (+ (* a b) c)) , the only
;;   differences are expected for these curly brackets.
;; A pair whose expected result can not be read by the read of Racket (#u8(5 6 7) is R7RS , not Racket) is counted
;; apart.
;; Known difference : test 53 , the sweet-expression  hi (. \\)  with the expected result  (hi \\) .
;; In a symbol the backslash is not read the same way by Guile , for which the test suite was written , and by Racket :
;; - Guile and the readers of SRFI 110 (the original one and this one) read \\ as a symbol of 2 characters \\ (outside
;;   | | the backslash escapes nothing , the escapes are recognized only between | | as in R7RS) ;
;; - the read of Racket reads \\ as a symbol of 1 character \ , displayed |\| (in Racket the backslash escapes the next
;;   character).
;; The expected result is read here by the read of Racket : (hi |\|) , while sweet-read gives (hi |\\|) as Guile does.
;; The original reader fails on this test under Racket exactly the same way : this is not an error of the reader.

(require racket/runtime-path
	 (only-in SRFI-110/kernel sweet-read)
	 (only-in Scheme+/parser-declarations reset-declarations-for-parser!))

(define-runtime-path testsuite-file "sweet-testsuite.txt")

;; skip the rest of the pair : until the next empty line
(define (skip-to-empty-line port)
  (let loop ()
    (let ((l (read-line port)))
      (unless (or (eof-object? l)
		  (string=? l ""))
	(loop)))))

(define (run-testsuite title)
  (define port (open-input-file testsuite-file))
  (define n 0) ; tests
  (define ok 0)
  (define bad 0)
  (define unreadable 0) ; expected result not readable by read
  (reset-declarations-for-parser!) ; the procedures defined by the previous run are forgotten
  (printf "~a\n" title)
  (let loop ()
    (define expected (with-handlers ((exn:fail:read? (lambda (e) 'unreadable)))
		       (read port)))
    (cond ((eof-object? expected)
	   (printf "~a : ~a tests , ~a passed , ~a failed , ~a expected results not readable by read\n\n"
		   title n ok bad unreadable))
	  ((eq? expected 'unreadable)
	   (set! unreadable (+ unreadable 1))
	   (skip-to-empty-line port)
	   (loop))
	  (else
	   (define start (file-position port))
	   (define got (with-handlers ((exn:fail? (lambda (e) (list 'sweet-read-error (exn-message e)))))
			 (sweet-read port)))
	   (define end (file-position port))
	   (set! n (+ n 1))
	   (cond ((equal? expected got)
		  (set! ok (+ ok 1)))
		 (else
		  (set! bad (+ bad 1))
		  (file-position port start)
		  (printf "FAILED test ~a\n  sweet-expression : ~s\n  expected : ~s\n  got      : ~s\n"
			  n (read-string (- end start) port) expected got)
		  (file-position port end)))
	   (when (and (pair? got)
		      (eq? (car got) 'sweet-read-error))
	     (skip-to-empty-line port))
	   (loop))))
  (close-input-port port)
  bad)

;; the strict SRFI 105 mode : the pragma read once (sweet-read removes it)
(void (sweet-read (open-input-string "BEGIN-STRICT-SRFI-105-REGION\nx\n")))
(void (run-testsuite "Strict SRFI 105 mode (as the original reader)"))

;; the mode of Scheme+
(void (sweet-read (open-input-string "END-STRICT-SRFI-105-REGION\nx\n")))
(void (run-testsuite "Mode of Scheme+ (differences expected only for the curly brackets)"))
