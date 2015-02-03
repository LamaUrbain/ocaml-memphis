let resolution = 256

let () =
  let (zoom_level, mapfile) =
    let (default_zoom, default_file) as default =
      (Unsigned.UInt.of_int 14, "demos/map.osm")
    in
    match Sys.argv with
    | [|_; zoom_level|] ->
        (Unsigned.UInt.of_string zoom_level, default_file)
    | [|_; zoom_level; mapfile|] ->
        (Unsigned.UInt.of_string zoom_level, mapfile)
    | [|_|] ->
        default
    | _ ->
        prerr_endline "Incorrect number of arguments";
        exit 1
  in

  Unix.mkdir "demos/tiles" 0o755;

  Memphis_debug.set_print_progress true;

  let rules = Memphis_rule_set.create () in
  Memphis_rule_set.load_from_file rules "demos/default-rules.xml";

  let map = Memphis_map.create () in
  begin try
    Memphis_map.load_from_file map mapfile;
  with Memphis_map.FailedToLoad ->
    print_endline "Error";
  end;

  let r = Memphis_renderer.create_full rules map in
  Memphis_renderer.set_resolution r (Unsigned.UInt.of_int resolution);
  Printf.printf "Tile resolution: %u\n" (Unsigned.UInt.to_int (Memphis_renderer.get_resolution r));

  let maxx = Memphis_renderer.get_max_x_tile r zoom_level in
  let maxy = Memphis_renderer.get_max_y_tile r zoom_level in
  let i = Memphis_renderer.get_min_x_tile r zoom_level in

  let rec loop i =
    if i <= maxx then begin
      let j = Memphis_renderer.get_min_y_tile r zoom_level in
      let rec loop' j =
        if j <= maxy then begin
          let surface = Cairo.Image.create Cairo.Image.ARGB32 ~width:resolution ~height:resolution in
          let cr = Cairo.create surface in
          let path = Printf.sprintf "demos/tiles/%i_%i.png" i j in

          Printf.printf "Drawing tile: %i, %i\n%!" i j;
          Memphis_renderer.draw_tile r cr (Unsigned.UInt.of_int i) (Unsigned.UInt.of_int j) zoom_level;
          Cairo.PNG.write surface path;

          (* Cairo.destroy cr; *)
          (* cairo_surface_destroy(surface); *)
          loop' (succ j);
        end
      in
      loop' j;
      loop (succ i);
    end
  in
  loop i;

  Memphis_renderer.destroy r;
  Memphis_map.destroy map;
  Memphis_rule_set.destroy rules;
  ()
