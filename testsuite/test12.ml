(* try_with_catch_simple *)
type out_channel
type 'a ref
external exit : int -> 'a = "caml_sys_exit"
external flush : out_channel -> unit = "caml_ml_flush"
external open_descriptor_out : int -> out_channel = "caml_ml_open_descriptor_out"
external output_char : out_channel -> char -> unit = "caml_ml_output_char"
external raise : exn -> 'a = "%raise"
external ( := ) : 'a ref -> 'a -> unit = "%setfield0"
external ( ! ) : 'a ref -> 'a = "%field0"
external ( ** ) : float -> float -> float = "caml_power_float" "pow" "float"
external ( /. ) : float -> float -> float = "%divfloat"
external ( *. ) : float -> float -> float = "%mulfloat"
external ( -. ) : float -> float -> float = "%subfloat"
external ( +. ) : float -> float -> float = "%addfloat"
external ( ~+. ) : float -> float = "%identity"
external ( ~-. ) : float -> float = "%negfloat"
external ( asr ) : int -> int -> int = "%asrint"
external ( lsr ) : int -> int -> int = "%lsrint"
external ( lsl ) : int -> int -> int = "%lslint"
external ( lxor ) : int -> int -> int = "%xorint"
external ( lor ) : int -> int -> int = "%orint"
external ( land ) : int -> int -> int = "%andint"
external ( mod ) : int -> int -> int = "%modint"
external ( / ) : int -> int -> int = "%divint"
external ( *  ) : int -> int -> int = "%mulint"
external ( - ) : int -> int -> int = "%subint"
external ( + ) : int -> int -> int = "%addint"
external (~+) : int -> int = "%identity"
external ( ~+ ) : int -> int = "%identity"
external ( ~- ) : int -> int = "%negint"
external ( || ) : bool -> bool -> bool = "%sequor"
external ( or ) : bool -> bool -> bool = "%sequor"
external ( && ) : bool -> bool -> bool = "%sequand"
external ( & ) : bool -> bool -> bool = "%sequand"
external ( != ) : 'a -> 'a -> bool = "%noteq"
external ( == ) : 'a -> 'a -> bool = "%eq"
external ( >= ) : 'a -> 'a -> bool = "%greaterequal"
external ( <= ) : 'a -> 'a -> bool = "%lessequal"
external ( > ) : 'a -> 'a -> bool = "%greaterthan"
external ( < ) : 'a -> 'a -> bool = "%lessthan"
external ( <> ) : 'a -> 'a -> bool = "%notequal"
external ( = ) : 'a -> 'a -> bool = "%equal"
let stdout = open_descriptor_out 1;;
exception A
let () = try
raise A;
output_char stdout 'a'
with A -> output_char stdout 'b';;
;;
let () = flush stdout; exit 0;;