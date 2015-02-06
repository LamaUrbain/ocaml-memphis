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

type t = unit ptr

let t = ptr void

let create_full =
  foreign "memphis_renderer_new_full" (Memphis_rule_set.t @-> Memphis_map.t @-> (returning t))

let destroy =
  foreign "memphis_renderer_free" (t @-> (returning void))

let create_full a b =
  let x = create_full a b in
  Gc.finalise destroy x;
  x

let set_resolution =
  foreign "memphis_renderer_set_resolution" (t @-> uint @-> (returning void))

let get_resolution =
  foreign "memphis_renderer_get_resolution" (t @-> (returning uint))

let get_min_x_tile =
  foreign "memphis_renderer_get_min_x_tile" (t @-> uint @-> (returning int))

let get_max_x_tile =
  foreign "memphis_renderer_get_max_x_tile" (t @-> uint @-> (returning int))

let get_min_y_tile =
  foreign "memphis_renderer_get_min_y_tile" (t @-> uint @-> (returning int))

let get_max_y_tile =
  foreign "memphis_renderer_get_max_y_tile" (t @-> uint @-> (returning int))

let draw_tile =
  foreign "memphis_renderer_draw_tile" (t @-> Cairo_bind.t @-> uint @-> uint @-> uint @-> (returning void))

let draw_tile a b c d e =
  let b = Cairo_bind.create b in
  draw_tile a b c d e
