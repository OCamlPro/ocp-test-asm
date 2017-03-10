
open TestTypes

let tests = ref []

let new_test name ?(prims=[]) ?(minimal=false) source =
  let source =
    if minimal then source else
      String.concat "\n" [
        "let stdout = open_descriptor_out 1;;";
        source;
        "let () = flush stdout; exit 0;;"
      ] in
  tests := { name; externals=prims; source } :: !tests

let minimal = true

let () =
  new_test "print_char"
    ~prims:[
      "open_descriptor_out";
      "flush";
      "exit";
      "output_char";
    ]
    ~minimal
    "\
let () =
   let stdout = open_descriptor_out 1 in\n\
   output_char stdout 'a';\n\
   flush stdout;\n\
   exit 0;\n\
";
  new_test "all externals" ~minimal "let () = exit 0\n";
  new_test "exit 2" ~minimal "let () = exit 2\n";
  new_test "compare_float_array_22"
    "output_char stdout (unsafe_char_of_int (66 + compare [| 0.0; 5.0; 2.0 |] [| 0.0; 1.0; 2.0 |]))";
  new_test "print_array_array_22"
    "let () =\
let x = [| 0.0; 5.0; 2.0 |] in
let y = [| 0.0; 1.0; 2.0 |] in
output_char stdout (unsafe_char_of_int (66 + compare (array_get x 0) (array_get y 0)));
output_char stdout (unsafe_char_of_int (66 + compare (array_get x 1) (array_get y 1)));
output_char stdout (unsafe_char_of_int (66 + compare (array_get x 2) (array_get y 2)));
  ()";
  new_test "compare_float_lt"
    "output_char stdout (unsafe_char_of_int (66 + compare 5.0 2.0))";
  new_test "compare_float_array_lt"
    "let () =\
let x = [| 5.0 |] in
let y = [| 1.0 |] in
output_char stdout (unsafe_char_of_int (66 + compare (array_get x 0) (array_get y 0)));
  ()";

  new_test "compare_unsafe_float_array_lt"
    "let () =\
let x = [| 5.0 |] in
let y = [| 1.0 |] in
output_char stdout (unsafe_char_of_int (66 + compare (array_unsafe_get x 0) (array_unsafe_get y 0)));
  ()";

  new_test "float_compare"
    "let () = output_char stdout (unsafe_char_of_int (66 + float_compare 5. 1.))";
  new_test "float_compare_alloc"
    "let () = output_char stdout (unsafe_char_of_int (66 + float_compare_alloc 5. 1.))";

  ()

let get_tests () =
  List.rev !tests
