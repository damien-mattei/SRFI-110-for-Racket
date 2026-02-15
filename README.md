# SRFI-110 Sweet Expressions for Racket Scheme

**Scheme Request For Implementations 110 "Sweet Expressions"** 

Scheme SRFI 110 Sweet expressions , Curly Infix and neoteric expressions for Racket Scheme 

Note: Sweet expression should not work (due to incompatibilities from guile to racket,not even tested)
<br>

#lang reader SRFI-105


## 💙 Support My Work

If my projects help you, you can support me with a donation:

[![Donate via PayPal](https://img.shields.io/badge/Donate-PayPal-003087?style=for-the-badge&logo=paypal&logoColor=white)](https://www.paypal.me/DamienMATTEI27)

<br>

Future: the next release is more complex and will take more time to be achieved,i'm working on a type annotation system to improve speed to top.


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

