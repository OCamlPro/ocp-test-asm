
open StringCompat

type test = {
  name : string;
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

let prim_externals = [
  "raise", "exn -> 'a", [ "%raise" ];
  "( = )", "'a -> 'a -> bool", ["%equal"];
  "( <> )", "'a -> 'a -> bool", ["%notequal"];
  "( < )", "'a -> 'a -> bool", ["%lessthan"];
  "( > )", "'a -> 'a -> bool", ["%greaterthan"];
  "( <= )", "'a -> 'a -> bool", ["%lessequal"];
  "( >= )", "'a -> 'a -> bool", ["%greaterequal"];
  "compare", "'a -> 'a -> int", ["%compare"];
  "( == )", "'a -> 'a -> bool", ["%eq"];
  "( != )", "'a -> 'a -> bool", ["%noteq"];
  "not", "bool -> bool", ["%boolnot"];
  "( & )", "bool -> bool -> bool", ["%sequand"];
  "( && )", "bool -> bool -> bool", ["%sequand"];
  "( or )", "bool -> bool -> bool", ["%sequor"];
  "( || )", "bool -> bool -> bool", ["%sequor"];
  "( ~- )", "int -> int", ["%negint"];
  "( ~+ )", "int -> int", ["%identity"];
  "(~+)", "int -> int", ["%identity"];
  "succ", "int -> int", ["%succint"];
  "pred", "int -> int", ["%predint"];
  "( + )", "int -> int -> int", ["%addint"];
  "( - )", "int -> int -> int", ["%subint"];
  "( *  )", "int -> int -> int", ["%mulint"];
  "( / )", "int -> int -> int", ["%divint"];
  "( mod )", "int -> int -> int", ["%modint"];

  "( land )", "int -> int -> int", ["%andint"];
  "( lor )", "int -> int -> int", ["%orint"];
  "( lxor )", "int -> int -> int", ["%xorint"];
  "( lsl )", "int -> int -> int", ["%lslint"];
  "( lsr )", "int -> int -> int", ["%lsrint"];
  "( asr )", "int -> int -> int", ["%asrint"];
  "( ~-. )", "float -> float", ["%negfloat"];
  "( ~+. )", "float -> float", ["%identity"];
  "( +. )", "float -> float -> float", ["%addfloat"];
  "( -. )", "float -> float -> float", ["%subfloat"];
  "( *. )", "float -> float -> float", ["%mulfloat"];
  "( /. )", "float -> float -> float", ["%divfloat"];
  "( ** )", "float -> float -> float", ["caml_power_float"; "pow"; "float"];
  "exp", "float -> float", ["caml_exp_float"; "exp"; "float"];
  "expm1", "float -> float", ["caml_expm1_float"; "caml_expm1"; "float"];
  "acos", "float -> float", ["caml_acos_float"; "acos"; "float"];
  "asin", "float -> float", ["caml_asin_float"; "asin"; "float"];
  "atan", "float -> float", ["caml_atan_float"; "atan"; "float"];
  "atan2", "float -> float -> float", ["caml_atan2_float"; "atan2"; "float"];
  "hypot", "float -> float -> float", ["caml_hypot_float"; "caml_hypot"; "float"];
  "cos", "float -> float", ["caml_cos_float"; "cos"; "float"];
  "cosh", "float -> float", ["caml_cosh_float"; "cosh"; "float"];
  "log", "float -> float", ["caml_log_float"; "log"; "float"];
  "log10", "float -> float", ["caml_log10_float"; "log10"; "float"];
  "log1p", "float -> float", ["caml_log1p_float"; "caml_log1p"; "float"];
  "sin", "float -> float", ["caml_sin_float"; "sin"; "float"];
  "sinh", "float -> float", ["caml_sinh_float"; "sinh"; "float"];
  "sqrt", "float -> float", ["caml_sqrt_float"; "sqrt"; "float"];
  "tan", "float -> float", ["caml_tan_float"; "tan"; "float"];
  "tanh", "float -> float", ["caml_tanh_float"; "tanh"; "float"];
  "ceil", "float -> float", ["caml_ceil_float"; "ceil"; "float"];
  "floor", "float -> float", ["caml_floor_float"; "floor"; "float"];
  "abs_float", "float -> float", ["%absfloat"];
  "copysign", "float -> float -> float", ["caml_copysign_float"; "caml_copysign"; "float"];
  "mod_float", "float -> float -> float", ["caml_fmod_float"; "fmod"; "float"];
  "frexp", "float -> float * int", ["caml_frexp_float"];
  "ldexp", "float -> int -> float", ["caml_ldexp_float"];
  "modf", "float -> float * float", ["caml_modf_float"];
  "float", "int -> float", ["%floatofint"];
  "float_of_int", "int -> float", ["%floatofint"];
  "truncate", "float -> int", ["%intoffloat"];
  "int_of_float", "float -> int", ["%intoffloat"];
  "float_of_bits", "int64 -> float", ["caml_int64_float_of_bits"];
  "string_length", "string -> int", ["%string_length"];
  "string_create", "int -> string", ["caml_create_string"];
  "string_blit", "string -> int -> string -> int -> int -> unit
                    ", ["caml_blit_string"; "noalloc"];
  "int_of_char", "char -> int", ["%identity"];
  "unsafe_char_of_int", "int -> char", ["%identity"];
  "ignore", "'a -> unit", ["%ignore"];
  "fst", "'a * 'b -> 'a", ["%field0"];
  "snd", "'a * 'b -> 'b", ["%field1"];
  "format_int", "string -> int -> string", ["caml_format_int"];
  "format_float", "string -> float -> string", ["caml_format_float"];
  "int_of_string", "string -> int", ["caml_int_of_string"];
  "string_get", "string -> int -> char", ["%string_safe_get"];
  "float_of_string", "string -> float", ["caml_float_of_string"];
  "ref", "'a -> 'a ref", ["%makemutable"];
  "( ! )", "'a ref -> 'a", ["%field0"];
  "( := )", "'a ref -> 'a -> unit", ["%setfield0"];
  "incr", "int ref -> unit", ["%incr"];
  "decr", "int ref -> unit", ["%decr"];

]

let makefile = "Makefile.tests"
let make_rec =
  Printf.sprintf "$(MAKE) -f %s --no-print-directory" makefile

let externals_map =
  let map = ref StringMap.empty in

  (* basic_externals *)
  List.iter (fun (ex_name, ex_type) ->
      map := StringMap.add ex_name (ex_type, [ex_name]) !map
  ) basic_externals;

  (* prim_externals *)
  List.iter (fun (ex_name, ex_type, ex_names) ->
      map := StringMap.add ex_name (ex_type, ex_names) !map
  ) prim_externals;
  map

let print_external ml_oc ex_name (ex_type, ex_names) =
  Printf.fprintf ml_oc "external %s : %s =" ex_name ex_type;
  List.iter (fun ex_name -> Printf.fprintf ml_oc " %S" ex_name) ex_names;
  Printf.fprintf ml_oc "\n";
  ()

let test_counter = ref 0
let generate_test make_oc test =
  incr test_counter;
  let i = !test_counter in
  let basename = Printf.sprintf "test_%d" i in

  (* empty .mli since no external should be created *)
  let mli_oc = open_out (basename ^ ".mli") in
  close_out mli_oc;

  let ml_oc = open_out (basename ^ ".ml") in
  Printf.fprintf ml_oc "(* %s *)\n" test.name;

  if test.externals = [] then
    StringMap.iter (print_external ml_oc) !externals_map
  else
  List.iter (fun ex_name ->
    let ex =
      try
        StringMap.find ex_name !externals_map
      with Not_found ->
        Printf.eprintf "Error: test %d, unknown external %S\n%!" i ex_name;
        exit 2
    in
    print_external ml_oc ex_name ex
  ) test.externals;
  output_string ml_oc test.source;
  close_out ml_oc;

  Printf.fprintf make_oc "%s.log:\n" basename;
  Printf.fprintf make_oc "\t%s %s > %s.log 2>&1\n"
    make_rec basename basename;
  Printf.fprintf make_oc "%s:\n" basename;
  Printf.fprintf make_oc "\t@echo Test %s = %s\n" test.name basename;
  Printf.fprintf make_oc "\t@echo Compiling %s:\n" basename;
  Printf.fprintf make_oc "\trm -f %s.asm %s.cm? %s.o\n"
    basename basename basename;
  Printf.fprintf make_oc "\t$(OCAMLOPT) -S -g -c %s.mli\n" basename;
  Printf.fprintf make_oc "\t$(OCAMLOPT) -S -verbose -g -c %s.ml\n" basename;
  Printf.fprintf make_oc "\t$(OCAMLOPT) -S -dstartup -verbose -g -o %s.asm %s.cmx\n"
    basename basename;
  Printf.fprintf make_oc "\t@echo Executing %s:\n" basename;
  Printf.fprintf make_oc "\t./%s.asm > %s.$(RESULT) || echo execution failed\n"
    basename basename;
  Printf.fprintf make_oc "\t@if $(CMP) %s.$(RESULT) %s.reference; then echo PASSED TEST %s %s; else echo FAILED TEST %s %s; fi\n"
    basename basename
    basename test.name
    basename test.name;
  Printf.sprintf "%s.log" basename

let generate_tests tests =

  let make_oc = open_out makefile in
  Printf.fprintf make_oc "# Use 'Makefile.config' to configure for your host\n";
  Printf.fprintf make_oc "-include Makefile.config\n";
  Printf.fprintf make_oc "RESULT ?= result\n";
  Printf.fprintf make_oc "OCAMLOPT ?= ocamlopt\n";
  Printf.fprintf make_oc "#CMP could also be 'diff -q'\n";
  Printf.fprintf make_oc "CMP ?= cmp\n";
  Printf.fprintf make_oc "\n";
  Printf.fprintf make_oc "all:\n";
  Printf.fprintf make_oc "\t$(MAKE) -f %s clean\n" makefile;
  Printf.fprintf make_oc "\t$(MAKE) -f %s results\n" makefile;
  Printf.fprintf make_oc "update-references:\n";
  Printf.fprintf make_oc "\t$(MAKE) -f %s RESULT=reference\n" makefile;
  Printf.fprintf make_oc "clean:\n";
  Printf.fprintf make_oc "\trm -f *.asm *.cm? *.o *.result *.log *.s\n";
  let targets = ref [] in
  List.iter (fun test ->
    let target = generate_test make_oc test in
    targets := target :: !targets;
  ) tests;
  let targets = List.rev !targets in
  Printf.fprintf make_oc ".PHONY:";
  List.iter (fun target ->
    Printf.fprintf make_oc " %s" target
  ) targets;
  Printf.fprintf make_oc "\n";
  Printf.fprintf make_oc "results:";
  List.iter (fun target ->
    Printf.fprintf make_oc " %s" target
  ) targets;
  Printf.fprintf make_oc "\n";
  Printf.fprintf make_oc "\techo Testsuite results > testsuite.log\n";
  List.iter (fun target ->
    Printf.fprintf make_oc "\t@echo '--------------------- %s --------------------' >> testsuite.log\n" target;
    Printf.fprintf make_oc "\tcat %s >> testsuite.log\n" target;
    Printf.fprintf make_oc "\t@echo >> testsuite.log\n";
  ) targets;
  Printf.fprintf make_oc "\tgrep TEST testsuite.log\n";
  close_out make_oc;

  ()


let tests = ref []

let new_test name externals source =
  tests := { name; externals; source } :: !tests

let () =
  new_test "print_char"
    [
      "caml_ml_open_descriptor_out";
      "caml_ml_flush";
      "caml_sys_exit";
      "caml_ml_output_char";
    ]

    "\
let () =
   let stdout = caml_ml_open_descriptor_out 1 in\n\
   caml_ml_output_char stdout 'a';\n\
   caml_ml_flush stdout;\n\
   caml_sys_exit 0;\n\
";
  new_test "all externals"
    []
    "\
let () =
  caml_sys_exit 0;\n\
";
  ()


let () =
  generate_tests (List.rev !tests)
