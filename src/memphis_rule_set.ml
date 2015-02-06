(*
Copyright (c) 2015 Jacques-Pascal Deplaix <jp.deplaix@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*)

open Ctypes
open Foreign

exception FailedToLoad

type t = unit ptr

let t = ptr void

let create =
  foreign "memphis_rule_set_new" (void @-> (returning t))

let destroy =
  foreign "memphis_rule_set_free" (t @-> (returning void))

let create a =
  let x = create a in
  Gc.finalise destroy x;
  x

let load_from_file =
  foreign "memphis_rule_set_load_from_file" (t @-> string @-> ptr Glib.gerror @-> (returning void))

let load_from_file a b =
  let c = allocate (ptr void) null in
  load_from_file a b c;
  let c = !@c in
  if ptr_compare c null <> 0 then begin
    Glib.gerror_destroy c;
    raise FailedToLoad;
  end;
  ()
