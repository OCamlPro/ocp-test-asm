
open StringCompat

type test = {
  name : string;
  externals : string list;
  source : string;
  subset : subset option;
}

and subset = {
  subset_name : string;
  mutable subset_logs : string list;
}
