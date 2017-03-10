val externals_map : (string * string list) StringCompat.StringMap.t ref
val print_external :
           out_channel -> string -> string * string list -> unit
val operators : string list
