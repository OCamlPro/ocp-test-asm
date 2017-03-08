
open StringCompat

type test = {
  externals : string list;
  source : string;
}

let basic_externals = [
  "caml_ml_open_descriptor_out", "int -> out_channel";
  "caml_ml_output", "out_channel -> string -> int -> int -> unit";
  "caml_ml_output_char", "out_channel -> char -> unit";
  "caml_ml_flush", "out_channel -> unit";
  "caml_sys_exit", "int -> 'a";
]
let externals_map =
  let map = ref StringMap.empty in
  List.iter (fun (ex_name, ex_type) ->
      map := StringMap.add ex_name (ex_type, [ex_name]) !map
  ) basic_externals;
  !map

let generate_test i make_oc test =
  let basename = Printf.sprintf "test_%d" i in

  (* empty .mli since no external should be created *)
  let mli_oc = open_out (basename ^ ".mli") in
  close_out mli_oc;

  let ml_oc = open_out (basename ^ ".ml") in
  List.iter (fun ex_name ->
    let (ex_type, ex_names) =
      try
        StringMap.find ex_name externals_map
      with Not_found ->
        Printf.eprintf "Error: test %d, unknown external %S\n%!" i ex_name;
        exit 2
    in
    Printf.fprintf ml_oc "external %s : %s =" ex_name ex_type;
    List.iter (fun ex_name -> Printf.fprintf ml_oc " %S" ex_name) ex_names;
    Printf.fprintf ml_oc "\n";
  ) test.externals;
  output_string ml_oc test.source;
  close_out ml_oc;

  Printf.fprintf make_oc "\t@echo Compiling %s:\n" basename;
  Printf.fprintf make_oc "\t@rm -f %s.asm %s.cm? %s.o\n"
    basename basename basename;
  Printf.fprintf make_oc "\t@$(OCAMLOPT) -g -c %s.mli\n" basename;
  Printf.fprintf make_oc "\t@$(OCAMLOPT) -g -c %s.ml\n" basename;
  Printf.fprintf make_oc "\t@$(OCAMLOPT) -g -o %s.asm %s.cmx\n"
    basename basename;
  Printf.fprintf make_oc "\t@echo Executing %s:\n" basename;
  Printf.fprintf make_oc "\t@./%s.asm > %s.$(RESULT) || echo execution failed\n"
    basename basename;
  Printf.fprintf make_oc "\t@if cmp %s.$(RESULT) %s.reference; then echo TEST %s passed; else echo TEST %s failed; fi\n"
    basename basename
    basename basename;
  ()

let generate_tests tests =

  let make_oc = open_out "Makefile.tests" in
  Printf.fprintf make_oc "RESULT ?= result\n";
  Printf.fprintf make_oc "OCAMLOPT ?= ocamlopt\n";
  Printf.fprintf make_oc "CMP ?= cmp\n";
  Printf.fprintf make_oc "\n";
  Printf.fprintf make_oc "all: results\n";
  Printf.fprintf make_oc "update-references:\n";
  Printf.fprintf make_oc "\t$(MAKE) -f Makefile.tests RESULT=reference\n";
  Printf.fprintf make_oc "clean:\n";
  Printf.fprintf make_oc "\trm -f *.asm *.cm? *.o *.result\n";
  Printf.fprintf make_oc "results:\n";
  for i = 0 to Array.length tests - 1 do
    generate_test i make_oc tests.(i)
  done;
  close_out make_oc;

  ()

let () =
  let tests = [|
    {
      externals = [
        "caml_ml_open_descriptor_out";
        "caml_ml_flush";
        "caml_sys_exit";
        "caml_ml_output_char";
      ];
      source =  "\
let () =
   let stdout = caml_ml_open_descriptor_out 1 in\n\
   caml_ml_output_char stdout 'a';\n\
   caml_ml_flush stdout;\n\
   caml_sys_exit 0;\n\
";
    }
             |]
  in
  generate_tests tests
