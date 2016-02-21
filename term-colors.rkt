#lang racket 

(provide
 make-color make-style 
 color style
 compiled-style? compiled-color?
 make-printf/style make-format/style)

(define *color-bases* 
 '((foreground 30)
   (background 40)))

(define *colors*
 '((black   0)
   (red     1)
   (green   2)
   (yellow  3)
   (blue    4)
   (magenta 5)
   (cyan    6)
   (white   7)))

(define *styles*
 '((bright    1)
   (underline 4)
   (italic    3)
   (negative  7)))

; Assoc helper that returns the second item
; in a pair found via assoc
(define (assocv v lst)
 (let ([found (assoc v lst)])
  (if found (cadr found) #f)
 )
)

; Returns #t when 'v' is a compiled color
(define (compiled-color? v)
 (and (pair? v) 
      (eq? (car v) 'compiled-color)))

; Returns #t when 'v' is a compiled style
(define (compiled-style? v)
 (and (pair? v) 
      (eq? (car v) 'compiled-style))
)

(define (make-color color-name [intensity 'normal] [ground 'foreground])
 (let* ([color-num (+ (assocv ground *color-bases*)
                      (assocv color-name *colors*))]
        [color-num-string (number->string color-num)])
  `(compiled-color
    ,(string-append
      (if (eq? intensity 'bright) 
       (string-append (number->string (assocv intensity *styles*)) ";") "")
      color-num-string "m")
   )
 )
)

; Convert a style symbol (or compiled sytle) into a string
(define (style->string style)
 (cond
  [(or (compiled-style? style)
       (compiled-color? style)) (cadr style)]
  [else (number->string (assocv style *styles*))]
 )
)

; Compile the list of styles into a compiled style string
(define (make-style . styles)
 `(compiled-style
   ,(string-join (map style->string styles) ";"))
 )

; Return colored text
(define (color str color-name [intensity 'normal] [ground 'foreground])
 (style str (make-color color-name intensity ground)))

; Return the styled text 
(define (style str . styles)
 (string-append "\e[" (style->string (apply make-style styles)) str "\e[0m")
)

; returns a 'format' function that will format the text with the given
; styles.
(define (make-format/style . styles)
 (lambda ( #:dummy [x #t] . fmt)
  (apply style (apply format fmt) styles)
 )
)

; return a printf function that will printf with the given styles
(define (make-printf/style . styles)
 (let ([formats (apply make-format/style styles)])
  ; Lambdas can't have a . rest-id unless they have at least one argument.
  (lambda ( #:dummy [x #t] . fmt)
   (display (apply formats fmt))
  )
 )
)

;Copyright (c) 2016 Josh Kunz
;
;Permission is hereby granted, free of charge, to any person obtaining a
;copy of this software and associated documentation files (the "Software"),
;to deal in the Software without restriction, including without limitation the
;rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
;sell copies of the Software, and to permit persons to whom the Software is
;furnished to do so, subject to the following conditions:
;
;The above copyright notice and this permission notice shall be included in
;all copies or substantial portions of the Software.
;
;THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
;IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
;FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
;THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
;LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
;OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
;THE SOFTWARE.
