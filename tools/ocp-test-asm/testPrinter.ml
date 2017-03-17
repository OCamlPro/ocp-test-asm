
open StringCompat

open TestTypes

let makefile_trailer = List.assoc "files/Makefile.trailer" TestFiles.files

let makefile = "Makefile.tests"
let make_rec =
  Printf.sprintf "$(MAKE) -f %s --no-print-directory" makefile

let externals_of_source s =
  let len = String.length s in
  let externals = ref StringSet.empty in
  let new_external i0 i =
    let ex_name = String.sub s i0 (i-i0) in
    if StringMap.mem ex_name !TestExternals.externals_map
    && not (StringSet.mem ex_name !externals) then
      externals := StringSet.add ex_name !externals
  in
  let rec iter i =
    if i < len then
      match s.[i] with
        'a'..'z' -> iter1 i (i+1)
      | _ -> iter (i+1)

  and iter1 i0 i =
    if i < len then
      match s.[i] with
      | 'a'..'z'
      | 'A'..'Z'
      | '0'..'9'
      | '_' -> iter1 i0 (i+1)
      | _ ->
        new_external i0 i;
        iter (i+1)
    else
      new_external i0 i
  in
  iter 0;
  StringSet.to_list !externals @ TestExternals.operators

let test_counter = ref 0
let print_test make_oc test =
  incr test_counter;
  let i = !test_counter in
  let basename = Printf.sprintf "test%d" i in

  (* empty .mli since no external should be created *)
  let mli_oc = open_out (basename ^ ".mli") in
  close_out mli_oc;

  let name_oc = open_out (basename ^ ".name") in
  begin
    match test.subset with
    | None -> Printf.fprintf name_oc "%s\n" test.name;
    | Some sub -> Printf.fprintf name_oc "%s:%s\n" sub.subset_name test.name;
  end;
  close_out name_oc;

  let ml_oc = open_out (basename ^ ".ml") in
  Printf.fprintf ml_oc "(* %s *)\n" test.name;
  Printf.fprintf ml_oc "type out_channel\n";
  Printf.fprintf ml_oc "type 'a ref\n";

  Printf.fprintf ml_oc "\
external register_named_value : string -> 'a -> unit \
                              = \"caml_register_named_value\"\n";
  Printf.fprintf ml_oc "\
let () =\
  register_named_value \"Pervasives.array_bound_error\" \
    (Invalid_argument \"index out of bounds\")\n";

  let externals =
    if test.externals = [] then
      externals_of_source test.source
    (*
      StringMap.iter (TestExternals.print_external ml_oc)
      !TestExternals.externals_map *)
    else test.externals
  in
  List.iter (fun ex_name ->
    let ex =
      try
        StringMap.find ex_name !TestExternals.externals_map
      with Not_found ->
        Printf.eprintf "Error: test %d, unknown external %S\n%!" i ex_name;
        exit 2
    in
    TestExternals.print_external ml_oc ex_name ex
  ) externals;
  output_string ml_oc test.source;
  close_out ml_oc;
  let test_log = Printf.sprintf "%s.log" basename in
  begin
    match test.subset with
    | None -> ()
    | Some sub -> sub.subset_logs <- test_log :: sub.subset_logs
  end;
  test_log

let print_tests (tests, subsets) =

  let make_oc = open_out makefile in
  let targets = ref [] in
  List.iter (fun test ->
    let target = print_test make_oc test in
    targets := target :: !targets;
  ) tests;
  let targets = List.rev !targets in
  let ntests = List.length targets in
  Printf.fprintf make_oc "SUBSETS=all";
  List.iter (fun sub ->
    Printf.fprintf make_oc " %s" sub.subset_name
  ) subsets;
  Printf.fprintf make_oc "\n";
  Printf.fprintf make_oc "all_NTESTS=%d\n" ntests;
  Printf.fprintf make_oc "all_LOGS=";
  List.iter (fun target ->
    Printf.fprintf make_oc " %s" target
  ) targets;
  Printf.fprintf make_oc "\n";
  List.iter (fun sub ->
    Printf.fprintf make_oc "%s_LOGS=%s\n" sub.subset_name
      (String.concat " " (List.rev sub.subset_logs));
    Printf.fprintf make_oc "%s_NTESTS=%d\n" sub.subset_name
      (List.length sub.subset_logs);
  ) subsets;
  Printf.fprintf make_oc "\n";
  Printf.fprintf make_oc "# from files/Makefile.trailer\n%s\n" makefile_trailer;

  close_out make_oc;
  ()
