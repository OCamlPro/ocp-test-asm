external caml_ml_open_descriptor_out : int -> out_channel = "caml_ml_open_descriptor_out"
external caml_ml_flush : out_channel -> unit = "caml_ml_flush"
external caml_sys_exit : int -> 'a = "caml_sys_exit"
external caml_ml_output_char : out_channel -> char -> unit = "caml_ml_output_char"
let () =
   let stdout = caml_ml_open_descriptor_out 1 in
caml_ml_output_char stdout 'a';
caml_ml_flush stdout;
caml_sys_exit 0;
