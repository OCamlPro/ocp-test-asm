(* print_char *)
type out_channel
type 'a ref
external register_named_value : string -> 'a -> unit = "caml_register_named_value"
let () =register_named_value "Pervasives.array_bound_error" (Invalid_argument "index out of bounds")
external open_descriptor_out : int -> out_channel = "caml_ml_open_descriptor_out"
external flush : out_channel -> unit = "caml_ml_flush"
external exit : int -> 'a = "caml_sys_exit"
external output_char : out_channel -> char -> unit = "caml_ml_output_char"
let () =
   let stdout = open_descriptor_out 1 in
output_char stdout 'a';
flush stdout;
exit 0;
