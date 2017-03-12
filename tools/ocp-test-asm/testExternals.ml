
open StringCompat

open TestTypes

let prim_externals = [

  (* From Pervasives *)

  "open_descriptor_out", "int -> out_channel",
  ["caml_ml_open_descriptor_out"];
  "output", "out_channel -> string -> int -> int -> unit",
  [ "caml_ml_output" ];
  "output_char", "out_channel -> char -> unit",
  [ "caml_ml_output_char" ];
  "flush", "out_channel -> unit",
  [ "caml_ml_flush" ];
  "exit", "int -> 'a",
  [ "caml_sys_exit" ];
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

  "int_of_char", "char -> int", ["%identity"];
  "unsafe_char_of_int", "int -> char", ["%identity"];
  "ignore", "'a -> unit", ["%ignore"];
  "fst", "'a * 'b -> 'a", ["%field0"];
  "snd", "'a * 'b -> 'b", ["%field1"];
  "format_int", "string -> int -> string", ["caml_format_int"];
  "format_float", "string -> float -> string", ["caml_format_float"];
  "int_of_string", "string -> int", ["caml_int_of_string"];
  "float_of_string", "string -> float", ["caml_float_of_string"];
  "ref", "'a -> 'a ref", ["%makemutable"];
  "( ! )", "'a ref -> 'a", ["%field0"];
  "( := )", "'a ref -> 'a -> unit", ["%setfield0"];
  "incr", "int ref -> unit", ["%incr"];
  "decr", "int ref -> unit", ["%decr"];

  "nativeint_neg", "nativeint -> nativeint", ["%nativeint_neg"];
  "nativeint_add", "nativeint -> nativeint -> nativeint", ["%nativeint_add"];
  "nativeint_sub", "nativeint -> nativeint -> nativeint", ["%nativeint_sub"];
  "nativeint_mul", "nativeint -> nativeint -> nativeint", ["%nativeint_mul"];
  "nativeint_div", "nativeint -> nativeint -> nativeint", ["%nativeint_div"];
  "nativeint_rem", "nativeint -> nativeint -> nativeint", ["%nativeint_mod"];
  "nativeint_logand", "nativeint -> nativeint -> nativeint", ["%nativeint_and"];
  "nativeint_logor", "nativeint -> nativeint -> nativeint", ["%nativeint_or"];
  "nativeint_logxor", "nativeint -> nativeint -> nativeint", ["%nativeint_xor"];
  "nativeint_shift_left", "nativeint -> int -> nativeint", ["%nativeint_lsl"];
  "nativeint_shift_right", "nativeint -> int -> nativeint", ["%nativeint_asr"];
  "nativeint_shift_right_logical", "nativeint -> int -> nativeint", ["%nativeint_lsr"];
  "nativeint_of_int", "int -> nativeint", ["%nativeint_of_int"];
  "nativeint_to_int", "nativeint -> int", ["%nativeint_to_int"];
  "nativeint_of_float ", "float -> nativeint", ["caml_nativeint_of_float"];
  "nativeint_to_float ", "nativeint -> float", ["caml_nativeint_to_float"];
  "nativeint_of_int32", "int32 -> nativeint", ["%nativeint_of_int32"];
  "nativeint_to_int32", "nativeint -> int32", ["%nativeint_to_int32"];

  "int32_neg", "int32 -> int32", ["%int32_neg"];
  "int32_add", "int32 -> int32 -> int32", ["%int32_add"];
  "int32_sub", "int32 -> int32 -> int32", ["%int32_sub"];
  "int32_mul", "int32 -> int32 -> int32", ["%int32_mul"];
  "int32_div", "int32 -> int32 -> int32", ["%int32_div"];
  "int32_rem", "int32 -> int32 -> int32", ["%int32_mod"];
  "int32_logand", "int32 -> int32 -> int32", ["%int32_and"];
  "int32_logor", "int32 -> int32 -> int32", ["%int32_or"];
  "int32_logxor", "int32 -> int32 -> int32", ["%int32_xor"];
  "int32_shift_left", "int32 -> int -> int32", ["%int32_lsl"];
  "int32_shift_right", "int32 -> int -> int32", ["%int32_asr"];
  "int32_shift_right_logical", "int32 -> int -> int32", ["%int32_lsr"];
  "int32_of_int", "int -> int32", ["%int32_of_int"];
  "int32_to_int", "int32 -> int", ["%int32_to_int"];
  "int32_of_float", "float -> int32", ["caml_int32_of_float"];
  "int32_to_float", "int32 -> float", ["caml_int32_to_float"];
  "int32_bits_of_float", "float -> int32", ["caml_int32_bits_of_float"];
  "int32_float_of_bits", "int32 -> float", ["caml_int32_float_of_bits"];


  "int64_neg", "int64 -> int64", ["%int64_neg"];
  "int64_add", "int64 -> int64 -> int64", ["%int64_add"];
  "int64_sub", "int64 -> int64 -> int64", ["%int64_sub"];
  "int64_mul", "int64 -> int64 -> int64", ["%int64_mul"];
  "int64_div", "int64 -> int64 -> int64", ["%int64_div"];
  "int64_rem", "int64 -> int64 -> int64", ["%int64_mod"];
  "int64_logand", "int64 -> int64 -> int64", ["%int64_and"];
  "int64_logor", "int64 -> int64 -> int64", ["%int64_or"];
  "int64_logxor", "int64 -> int64 -> int64", ["%int64_xor"];
  "int64_shift_left", "int64 -> int -> int64", ["%int64_lsl"];
  "int64_shift_right", "int64 -> int -> int64", ["%int64_asr"];
  "int64_shift_right_logical", "int64 -> int -> int64", ["%int64_lsr"];
  "int64_of_int", "int -> int64", ["%int64_of_int"];
  "int64_to_int", "int64 -> int", ["%int64_to_int"];
  "int64_of_float", "float -> int64", ["caml_int64_of_float"];
  "int64_to_float", "int64 -> float", ["caml_int64_to_float"];
  "int64_of_int32", "int32 -> int64", ["%int64_of_int32"];
  "int64_to_int32", "int64 -> int32", ["%int64_to_int32"];
  "int64_of_nativeint", "nativeint -> int64", ["%int64_of_nativeint"];
  "int64_to_nativeint", "int64 -> nativeint", ["%int64_to_nativeint"];

  "array_length", "'a array -> int", ["%array_length"];
  "array_get", "'a array -> int -> 'a", ["%array_safe_get"];
  "array_set", "'a array -> int -> 'a -> unit", ["%array_safe_set"];
  "array_unsafe_get", "'a array -> int -> 'a", ["%array_unsafe_get"];
  "array_unsafe_set", "'a array -> int -> 'a -> unit", ["%array_unsafe_set"];
  "array_make", "int -> 'a -> 'a array", ["caml_make_vect"];
  "array_create", "int -> 'a -> 'a array", ["caml_make_vect"];
  "array_unsafe_sub", "'a array -> int -> int -> 'a array",
                   ["caml_array_sub"];
  "array_append", "'a array -> 'a array -> 'a array", ["caml_array_append"];
  "array_concat", "'a array list -> 'a array", [ "caml_array_concat" ];
  "array_unsafe_blit", "'a array -> int -> 'a array -> int -> int -> unit",
                   ["caml_array_blit"];

    "string_length", "string -> int", ["%string_length"];
  "string_create", "int -> string", ["caml_create_string"];
  "string_unsafe_blit", "string -> int -> string -> int -> int -> unit
                    ", ["caml_blit_string"; "noalloc"];
  "string_get", "string -> int -> char", ["%string_safe_get"];
  "string_set", "string -> int -> char -> unit", ["%string_safe_set"];
  "string_unsafe_get", "string -> int -> char", ["%string_unsafe_get"];
  "string_unsafe_set", "string -> int -> char -> unit", [ "%string_unsafe_set"];
  "string_unsafe_fill", "string -> int -> int -> char -> unit",
  ["caml_fill_string"; "noalloc"];

  "float_compare", "float -> float -> int", [ "caml_float_compare"; "noalloc" ];
  "float_compare_alloc", "float -> float -> int", [ "caml_float_compare" ];

  "gc_stat", "unit -> stat", ["caml_gc_stat"];
  "gc_quick_stat", "unit -> stat", ["caml_gc_quick_stat"];
  "gc_counters", "unit -> (float * float * float)", ["caml_gc_counters"];
  "gc_get", "unit -> control", ["caml_gc_get"];
  "gc_set", "control -> unit", ["caml_gc_set"];
  "gc_minor", "unit -> unit", ["caml_gc_minor"];
  "gc_major_slice", "int -> int", ["caml_gc_major_slice"];
  "gc_major", "unit -> unit", ["caml_gc_major"];
  "gc_full_major", "unit -> unit", ["caml_gc_full_major"];
  "gc_compact", "unit -> unit", ["caml_gc_compaction"];


]

let abstract_types = [
  "out_channel";
  "ref";
]

let externals_map, operators =
  let map = ref StringMap.empty in
  let operators = ref [] in
  (* prim_externals *)
  List.iter (fun (ex_name, ex_type, ex_names) ->
    map := StringMap.add ex_name (ex_type, ex_names) !map;
    match ex_name.[0] with
      'a'..'z' -> ()
    | _ -> operators := ex_name :: !operators
  ) prim_externals;
  map, !operators

let print_external ml_oc ex_name (ex_type, ex_names) =
  Printf.fprintf ml_oc "external %s : %s =" ex_name ex_type;
  List.iter (fun ex_name -> Printf.fprintf ml_oc " %S" ex_name) ex_names;
  Printf.fprintf ml_oc "\n";
  ()
