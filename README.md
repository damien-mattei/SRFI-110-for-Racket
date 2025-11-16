# SRFI-110 Sweet Expressions for Racket Scheme

**Scheme Request For Implementations 110 "Sweet Expressions"** 

Scheme SRFI 110 Sweet expressions , Curly Infix and neoteric expressions for Racket Scheme 

Note: Sweet expression should not work (due to incompatibilities from guile to racket,not even tested)


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

