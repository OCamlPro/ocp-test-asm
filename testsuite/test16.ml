(* array_gc *)
type out_channel
type 'a ref
external register_named_value : string -> 'a -> unit = "caml_register_named_value"
let () =register_named_value "Pervasives.array_bound_error" (Invalid_argument "index out of bounds")
external array_get : 'a array -> int -> 'a = "%array_safe_get"
external array_length : 'a array -> int = "%array_length"
external exit : int -> 'a = "caml_sys_exit"
external flush : out_channel -> unit = "caml_ml_flush"
external gc_full_major : unit -> unit = "caml_gc_full_major"
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

let bigarray n = [|
n+0; n+1; n+2; n+3; n+4; n+5; n+6; n+7; n+8; n+9; n+10; n+11; n+12;
n+13; n+14; n+15; n+16; n+17; n+18; n+19; n+20; n+21; n+22; n+23;
n+24; n+25; n+26; n+27; n+28; n+29; n+30; n+31; n+32; n+33; n+34;
n+35; n+36; n+37; n+38; n+39; n+40; n+41; n+42; n+43; n+44; n+45;
n+46; n+47; n+48; n+49; n+50; n+51; n+52; n+53; n+54; n+55; n+56;
n+57; n+58; n+59; n+60; n+61; n+62; n+63; n+64; n+65; n+66; n+67;
n+68; n+69; n+70; n+71; n+72; n+73; n+74; n+75; n+76; n+77; n+78;
n+79; n+80; n+81; n+82; n+83; n+84; n+85; n+86; n+87; n+88; n+89;
n+90; n+91; n+92; n+93; n+94; n+95; n+96; n+97; n+98; n+99; n+100;
n+101; n+102; n+103; n+104; n+105; n+106; n+107; n+108; n+109; n+110;
n+111; n+112; n+113; n+114; n+115; n+116; n+117; n+118; n+119; n+120;
n+121; n+122; n+123; n+124; n+125; n+126; n+127; n+128; n+129; n+130;
n+131; n+132; n+133; n+134; n+135; n+136; n+137; n+138; n+139; n+140;
n+141; n+142; n+143; n+144; n+145; n+146; n+147; n+148; n+149; n+150;
n+151; n+152; n+153; n+154; n+155; n+156; n+157; n+158; n+159; n+160;
n+161; n+162; n+163; n+164; n+165; n+166; n+167; n+168; n+169; n+170;
n+171; n+172; n+173; n+174; n+175; n+176; n+177; n+178; n+179; n+180;
n+181; n+182; n+183; n+184; n+185; n+186; n+187; n+188; n+189; n+190;
n+191; n+192; n+193; n+194; n+195; n+196; n+197; n+198; n+199; n+200;
n+201; n+202; n+203; n+204; n+205; n+206; n+207; n+208; n+209; n+210;
n+211; n+212; n+213; n+214; n+215; n+216; n+217; n+218; n+219; n+220;
n+221; n+222; n+223; n+224; n+225; n+226; n+227; n+228; n+229; n+230;
n+231; n+232; n+233; n+234; n+235; n+236; n+237; n+238; n+239; n+240;
n+241; n+242; n+243; n+244; n+245; n+246; n+247; n+248; n+249; n+250;
n+251; n+252; n+253; n+254; n+255; n+256; n+257; n+258; n+259; n+260;
n+261; n+262; n+263; n+264; n+265; n+266; n+267; n+268; n+269; n+270;
n+271; n+272; n+273; n+274; n+275; n+276; n+277; n+278; n+279; n+280;
n+281; n+282; n+283; n+284; n+285; n+286; n+287; n+288; n+289; n+290;
n+291; n+292; n+293; n+294; n+295; n+296; n+297; n+298; n+299
|]

module Array = struct let get = array_get end
let () =
  let a = bigarray 12345 in
  gc_full_major();
  for i = 0 to array_length a - 1 do
    if a.(i) <> 12345 + i then output_char stdout 'e'
  done

;;
let () = flush stdout; exit 0;;
