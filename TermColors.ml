open List

type color = 
    | Black | Red | Green | Yellow 
    | Blue | Magenta | Cyan | White;;

type color_bases = Foreground | Background;;
type intensity = Normal | Bright;;

type compiled_color = Color of string;;

let colors = [
     (Black,   0)
    ;(Red,     1)
    ;(Green,   2)
    ;(Yellow,  3)
    ;(Blue,    4)
    ;(Magenta, 5)
    ;(Cyan,    6)
    ;(White,   7)
];;

let color_bases = [
     (Foreground, 30)
    ;(Background, 40)
];;

let intensities = [
     (Normal, -1)
    ;(Bright,  1)
];;

let color_text name ?(intensity=Normal) ?(ground=Foreground) str =
    let color_number =   (List.assoc ground color_bases)
                       + (List.assoc name colors) in
    "\x1B[" ^ 
    (match intensity with
     | Normal -> ""
     | Bright -> string_of_int (List.assoc intensity intensities) ^ ";")
    ^ (string_of_int color_number) ^ "m" ^ str ^ "\x1B[0m";;

(*
Copyright (c) 2016 Josh Kunz

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation the
rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
sell copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*)
