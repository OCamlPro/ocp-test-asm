(* array_abstract_float *)
type out_channel
type 'a ref
external register_named_value : string -> 'a -> unit = "caml_register_named_value"
let () =register_named_value "Pervasives.array_bound_error" (Invalid_argument "index out of bounds")
external array_create : int -> 'a -> 'a array = "caml_make_vect"
external array_get : 'a array -> int -> 'a = "%array_safe_get"
external array_length : 'a array -> int = "%array_length"
external array_unsafe_sub : 'a array -> int -> int -> 'a array = "caml_array_sub"
external exit : int -> 'a = "caml_sys_exit"
external float : int -> float = "%floatofint"
external flush : out_channel -> unit = "caml_ml_flush"
external not : bool -> bool = "%boolnot"
external open_descriptor_out : int -> out_channel = "caml_ml_open_descriptor_out"
external output_char : out_channel -> char -> unit = "caml_ml_output_char"
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

module AbstractFloat =
  (struct
    type t = float
    let to_float x = x
    let from_float x = x
   end :
   sig
    type t
    val to_float: t -> float
    val from_float: float -> t
   end)

module Array = struct let get = array_get end
let array_copy t = array_unsafe_sub t 0 (array_length t)
let () =
  let t1 = AbstractFloat.from_float 1.0
  and t2 = AbstractFloat.from_float 2.0
  and t3 = AbstractFloat.from_float 3.0 in
  let v = [|t1;t2;t3|] in
  let w = array_create 2 t1 in
  let u = array_copy v in
  if not (AbstractFloat.to_float v.(0) = 1.0 &&
          AbstractFloat.to_float v.(1) = 2.0 &&
          AbstractFloat.to_float v.(2) = 3.0) then
    output_char stdout '1';
  if not (AbstractFloat.to_float w.(0) = 1.0 &&
          AbstractFloat.to_float w.(1) = 1.0) then
    output_char stdout '2';
  if not (AbstractFloat.to_float u.(0) = 1.0 &&
          AbstractFloat.to_float u.(1) = 2.0 &&
          AbstractFloat.to_float u.(2) = 3.0) then
    output_char stdout '3';
    ()

;;
let () = flush stdout; exit 0;;
