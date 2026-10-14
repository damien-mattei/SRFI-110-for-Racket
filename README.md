# SRFI-110 Sweet Expressions for Racket Scheme

**Scheme Request For Implementations 110 "Sweet Expressions"** 

Scheme SRFI 110 Sweet expressions , Curly Infix and neoteric expressions for Racket Scheme 

<!-- old note : Sweet expression should not work (due to incompatibilities from guile to racket,not even tested) -->
Sweet-expressions (indentation) work in files: the reader reads a file as sweet-expressions, and code written with parenthesis gives the same forms as before. Scheme+ can be written with this syntax, see ```examples/sweet-expressions+.rkt``` (checks) and ```examples/sweet-example+.rkt``` (a small program):

```scheme
#lang reader SRFI-110
module m racket
  require Scheme+
  define (f x)
    {x + 1}
  display f(2)
```

is ```(module m racket (require Scheme+) (define (f x) (+ x 1)) (display (f 2)))```. With the pragma ```BEGIN-STRICT-SRFI-105-REGION``` the curly brackets follow SRFI 105 (```{a * b + c}``` is ```($nfx$ a * b + c)```): the test suite of sweet-expressions of the Readable project then passes as with the original reader. Notes: an empty line ends an expression (inside a block, separate the lines with comment lines); the blocks of the ```if``` of Scheme+ can be indented under ```then``` and ```else``` (read as ```(then …)``` and ```(else …)```, which the ```if``` accepts), while the keyword that ends a loop (```while``` of ```do```, ```until``` of ```repeat```) is written alone on its line, at the level of the expressions; ```!``` at the beginning of a line is an indentation character (write ```{n !}``` or ```(! n)``` for the factorial); the REPL stays in curly infix (in sweet-expressions an input ends only with an empty line).

A file is read as sweet-expressions. As specified by SRFI 110, a parsing directive written alone at the beginning of a line (not as the very first characters of the file) changes the reading from the next datum: ```#!curly-infix``` reads the rest of the file with the rules of SRFI 105, which accept all the standard Scheme, even two forms glued without a space such as ```(display x)(newline)``` (in sweet-expressions, as in SRFI 110, it is the call ```((display x) newline)```); ```#!sweet``` goes back to the sweet-expressions; ```#!no-sweet``` reads with the ```read``` of Racket.

The test suite of the sweet-expression reader of the Readable project (456 pairs: the expected S-expression, then the sweet-expression, MIT license) is in ```examples/sweet-testsuite/sweet-testsuite.txt```; run it with ```racket examples/sweet-testsuite/run-sweet-testsuite.rkt```: in the strict SRFI 105 mode all the tests pass (except test 53, ```hi (. \\)``` with the expected result ```(hi \\)```: Guile, for which the test suite was written, and the readers of SRFI 110, the original one and this one, read ```\\``` as a symbol of 2 characters, because outside ```| |``` the backslash escapes nothing, while the read of Racket, which reads the expected result, gives a symbol of 1 character ```\``` (in Racket the backslash escapes the next character), so the original reader fails the same way under Racket; and the R7RS bytevector ```#u8(5 6 7)``` is not readable by the read of Racket), in the mode of Scheme+ the other differences come only from the curly brackets.

**Pragmas** (bare symbols written in the code, removed by the reader): ```BEGIN-STRICT-SRFI-105-REGION``` / ```END-STRICT-SRFI-105-REGION```, the strict mode where the reader follows SRFI 110 as the original reader (```{a + b * c}``` is ```($nfx$ a + b * c)```; ```$nfx$``` and ```$bracket-apply$``` can be taken from Scheme+ with ```(require (only-in Scheme+ $nfx$ $bracket-apply$))```), ```ANNOTATION-ON``` / ```ANNOTATION-OFF```, the type annotation pass of Scheme+, and ```CARE-OF-QUOTES-ON``` / ```CARE-OF-QUOTES-OFF```, the quoted lists as data or as infix expressions (symbolic computation). A pragma is written alone, or alone in curly brackets, inside the module form or before it (it then acts on the whole module); in sweet-expressions it is written alone on its line, or alone at the REPL; it acts only on the file where it is written. See the section Pragmas of the documentation: [https://docs.racket-lang.org/SRFI-110/index.html](https://docs.racket-lang.org/SRFI-110/index.html)
<br>

Use:

#lang reader SRFI-110

<!--
## 💙 Support My Work

If my projects help you, you can support me with a donation:

[![Donate via PayPal](https://img.shields.io/badge/Donate-PayPal-003087?style=for-the-badge&logo=paypal&logoColor=white)](https://www.paypal.me/DamienMATTEI27)
-->

<br>

Also provides the parser curly-infix2prefix4racket.rkt in src/ sub-directory:

```racket curly-infix2prefix4racket.rkt [--verbose] file2parse.rkt > parsedfile.rkt```

It writes on the standard output the Racket code that the reader gives to the compiler (the annotated code when the file has the pragma ```ANNOTATION-ON```). The option ```--verbose``` displays the banner and the state of the type annotation on the error output.

<br>

The type annotation and inference system to improve speed to top is now available, see version 2.0 below.
<br>

**Changes of version 2.0:**

Support for DrRacket literal hash table, examples: `#hash((a . 1) (b . 2))` , `#hasheq((a . 1) (b . 2))` ,  `#hasheqv((a . 1) (b . 2))` .

Allow comments on the same line of directive language or reader ,example: #lang reader SRFI-110 ;105

Type annotation and inference for Scheme+ (version 18.0), shared with SRFI 105 (annot+.rkt of SRFI 105): when the types of the operands are known, overloaded operators are replaced by monomorphic primitives (```fl+```, ```fx*```, ...), square bracket accesses are resolved, etc. The types are given with the ```type``` form of Scheme+, including composite types (```#(T)``` vector and ```(T)``` list of elements of type ```T```), see the Scheme+ documentation (section Type annotation and inference) and the README of SRFI 105 (version 15.0).

Pragmas ```ANNOTATION-ON``` and ```ANNOTATION-OFF```: they turn the pass on or off by region, on the elements that follow them in the same list (the body of the module, of a procedure, ...) and on all that is nested in them, until the other pragma or the end of the list; after the end of the list the state of before comes back. The pass is off at the beginning of each file (a pragma acts only on the file where it is written, not on the modules this file requires). The pragma can be written inside the module form or at the top level of the file (before the module form, it acts on the whole module). Nothing remains in the code: the annotation pass removes the pragmas.

The local variables of ```let```, ```let*```, ```letrec```, ```letrec*```, named ```let```, ```let-values``` and ```let*-values``` hide the type of an outer variable of the same name, as the parameters do: Scheme code keeps its meaning in a region ```ANNOTATION-ON``` (```(let ((a 1.5) (b 2.5)) (+ a b))``` no more becomes ```(fx+ a b)``` when ```a``` and ```b``` are fixnums outside).

The parser curly-infix2prefix4racket.rkt produces the same code as the reader: the annotated code when the file has the pragma ```ANNOTATION-ON```, and never the ```type``` forms nor the pragmas. It also takes in account the postfix operators declared at the top level of the file.

The procedures and macros of the program are known by the infix parser of Scheme+ (with Scheme+ 18.0): while reading, the reader stores the procedures and macros defined in the file, the names declared with a type of procedure (```(type procedure? vector-map)```), the overloaded ones, and the variables declared with a type which is not a procedure. Between ```{ }``` ```(vector-map - v)``` is then a call of ```vector-map``` and no more ```(- vector-map v)```, ```(1 2 my-f)``` is ```(my-f 1 2)```, and ```(x 3 +)``` is ```(+ x 3)``` when ```x``` has the type ```flonum?```. These declarations and those of the postfix operators act only on the file where they are written.

Pragmas ```CARE-OF-QUOTES-ON``` and ```CARE-OF-QUOTES-OFF``` (with Scheme+ 18.0), by region like ```ANNOTATION-ON``` / ```ANNOTATION-OFF```. With ```CARE-OF-QUOTES-ON```, the state at the beginning of each file, the quotes are respected: a quoted list is data, and a quoted ```{ }``` is converted at its top level only, its ```( )``` stay as written whatever the number of operators (```'{(x + y) * z + 1}``` is ```(+ (* (x + y) z) 1)```, it was ```(+ (* (+ x y) z) 1)``` while ```'{(x + y) * z}``` was already ```(* (x + y) z)```), ```'{a}``` is ```a``` and ```'{a b}``` is ```(a b)```. ```CARE-OF-QUOTES-OFF``` opens a region for the symbolic computation: the quoted and quasiquoted lists are infix expressions at all levels, ```'(Bₖ · Bₖ₋₁ ⊕ Cₖ · (Bₖ ⊕ Bₖ₋₁))``` is ```(⊕ (· Bₖ Bₖ₋₁) (· Cₖ (⊕ Bₖ Bₖ₋₁)))```, and in a quasiquote the parts ```,…``` and ```,@…``` stay as written. The constant ```care-of-quote``` of the reader is no more used.

Strict SRFI-105 mode repaired: between ```BEGIN-STRICT-SRFI-105-REGION``` and ```END-STRICT-SRFI-105-REGION``` an expression that is not a simple infix one gives ```($nfx$ …)``` (```{a + b * c}``` was converted with the precedence, it is now ```($nfx$ a + b * c)```), a simple infix one gives ```(op a b …)``` also with ```if```, and the pragmas written in curly brackets ```{BEGIN-STRICT-SRFI-105-REGION}``` no more leave ```()``` in the code.

The banner displays also the version of Scheme+ and the author.

<br>

**Changes of version 1.9:**

Support for postfix operators and postfix notation.

<br>

**Changes of version 1.8:**

Match with SRFI 105 update.
Display NO OP module but not annotation if empty.

<br>

**Changes of version 1.7:**


Bootstrapping start to be used. Scheme+ is now written in Scheme+. See: https://en.wikipedia.org/wiki/Bootstrapping_(compilers)
For now the Bootstrapping is only used in SRFI-105 as Scheme+ code do not have changed and as SRFI-110 just import annot+.rkt from SRFI-105.

Type annotation is in progress.(but no new features till)

<br>


**Changes of version 1.4:**

Fixes a bug with nested comments when code was not in a module,set the comment flag to false at each call of read-curly-infix.So it should works also in files with multiple expressions, not only a single big module expression. (note that ,see code, neoteric-read-comment perheaps needs to be checked,see comment in code at this point).But this should works.

<br>

**Changes of version 1.3:**

Correct the bug that was in the original SRFI 105 and SRFI 110 implementations that prevent some comment by #; to be commented when in inner expressions.

<br>

<br>

**Changes of version 1.2:**

Compatible with Scheme+.
Added Makefile and curly-infix2prefix4racket.rkt (should works but not tested).

<br>

**Changes of version 1.1:**

Compatible with Scheme+.


<br>


```scheme

#lang reader SRFI-110
{2 + 3 + sin{0.2} + {3 * 4}}
(+ 2 3 {4 + 5})

```

Parsed curly infix code result =

```scheme
(+ 2 3 (sin 0.2) (* 3 4))
(+ 2 3 (+ 4 5))
17.198669330795063
14
```

