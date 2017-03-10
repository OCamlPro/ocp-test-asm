
open StringCompat

open TestTypes

let makefile = "Makefile.tests"
let make_rec =
  Printf.sprintf "$(MAKE) -f %s --no-print-directory" makefile

let externals_of_source s =
  let len = String.length s in
  let externals = ref StringSet.empty in
  let new_external i0 i =
    let ex_name = String.sub s i0 (i-i0) in
    if StringMap.mem ex_name !TestExternals.externals_map
    && not (StringSet.mem ex_name !externals) then
      externals := StringSet.add ex_name !externals
  in
  let rec iter i =
    if i < len then
      match s.[i] with
        'a'..'z' -> iter1 i (i+1)
      | _ -> iter (i+1)

  and iter1 i0 i =
    if i < len then
      match s.[i] with
      | 'a'..'z'
      | 'A'..'Z'
      | '0'..'9'
      | '_' -> iter1 i0 (i+1)
      | _ ->
        new_external i0 i;
        iter (i+1)
    else
      new_external i0 i
  in
  iter 0;
  StringSet.to_list !externals @ TestExternals.operators

let test_counter = ref 0
let print_test make_oc test =
  incr test_counter;
  let i = !test_counter in
  let basename = Printf.sprintf "test_%d" i in

  (* empty .mli since no external should be created *)
  let mli_oc = open_out (basename ^ ".mli") in
  close_out mli_oc;

  let ml_oc = open_out (basename ^ ".ml") in
  Printf.fprintf ml_oc "(* %s *)\n" test.name;
  Printf.fprintf ml_oc "type out_channel\n";
  Printf.fprintf ml_oc "type 'a ref\n";
  let externals =
    if test.externals = [] then
      externals_of_source test.source
        (*
    StringMap.iter (TestExternals.print_external ml_oc)
          !TestExternals.externals_map *)
    else test.externals
  in
  List.iter (fun ex_name ->
    let ex =
      try
        StringMap.find ex_name !TestExternals.externals_map
      with Not_found ->
        Printf.eprintf "Error: test %d, unknown external %S\n%!" i ex_name;
        exit 2
    in
    TestExternals.print_external ml_oc ex_name ex
  ) externals;
  output_string ml_oc test.source;
  close_out ml_oc;

  Printf.fprintf make_oc "%s.log: %s.ml\n" basename basename;
  Printf.fprintf make_oc "\t@echo 'make -f %s %s > %s.log'\n" makefile basename basename;
  Printf.fprintf make_oc "\t@%s %s > %s.log 2>&1 || echo FAILED TEST %s %s '(by error status: cat %s.log)'>> %s.log\n"
    make_rec basename basename
  basename test.name basename basename;
  Printf.fprintf make_oc "%s.cmm: %s.ml\n" basename basename;
  Printf.fprintf make_oc "\t$(OCAMLOPT) $(ASMCOMP) -c %s.mli\n" basename;
  Printf.fprintf make_oc "\t$(OCAMLOPT) $(ASMCOMP) $(ASMDUMP) -c %s.ml 2> %s.cmm\n" basename basename;
  Printf.fprintf make_oc "\tcat %s.s >> %s.cmm\n" basename basename;
  Printf.fprintf make_oc "%s:\n" basename;
  Printf.fprintf make_oc "\t@echo Test %s = %s\n" test.name basename;
  Printf.fprintf make_oc "\t@echo Compiling %s:\n" basename;
  Printf.fprintf make_oc "\trm -f %s.asm %s.cm? %s.o\n"
    basename basename basename;
  Printf.fprintf make_oc "\t$(OCAMLOPT) $(ASMCOMP) -c %s.mli\n" basename;
  Printf.fprintf make_oc "\t$(OCAMLOPT) $(ASMCOMP) -c %s.ml\n" basename;
  Printf.fprintf make_oc "\t$(OCAMLOPT) $(ASMLINK) -o %s.asm %s.cmx\n"
    basename basename;
  Printf.fprintf make_oc "\t@echo Executing %s:\n" basename;
  Printf.fprintf make_oc "\techo './%s.asm > %s.$(RESULT)'\n"
    basename basename;
  Printf.fprintf make_oc "\t@./%s.asm > %s.$(RESULT) || echo execution failed\n"
    basename basename;
  Printf.fprintf make_oc "\t@if $(CMP) %s.$(RESULT) %s.reference; then echo PASSED TEST %s %s; else echo FAILED TEST %s %s '(by diff, cat %s.log)'; fi\n"
    basename basename
    basename test.name
    basename test.name basename;
  Printf.sprintf "%s.log" basename

let print_tests tests =

  let make_oc = open_out makefile in
  Printf.fprintf make_oc "# Use 'Makefile.config' to configure for your host\n";
  Printf.fprintf make_oc "-include Makefile.config\n";
  Printf.fprintf make_oc "RESULT ?= result\n";
  Printf.fprintf make_oc "OCAMLOPT ?= ocamlopt\n";
  Printf.fprintf make_oc "ASMCOMP ?= -S -verbose -g -nostdlib -nopervasives\n";
  Printf.fprintf make_oc "ASMLINK ?= -S -verbose -g\n";
  Printf.fprintf make_oc "#CMP could also be 'diff -q'\n";
  Printf.fprintf make_oc "CMP ?= cmp\n";
  Printf.fprintf make_oc "ECHO_NONL ?= echo -n\n";
  Printf.fprintf make_oc "NONL ?=\n";
  Printf.fprintf make_oc "ASMDUMP := -S -dcmm -dsel -dcombine -dlive -dspill -dinterf -dprefer -dalloc -dreload -dscheduling -dlinear";
  Printf.fprintf make_oc "\n";
  Printf.fprintf make_oc "all:\n";
  Printf.fprintf make_oc "\t%s clean\n" make_rec;
  Printf.fprintf make_oc "\t%s std_exit\n" make_rec;
  Printf.fprintf make_oc "\t%s results\n" make_rec;
  Printf.fprintf make_oc "update-references:\n";
  Printf.fprintf make_oc "\t$(MAKE) -f %s RESULT=reference\n" makefile;
  Printf.fprintf make_oc "clean:\n";
  Printf.fprintf make_oc "\trm -f *.asm *.cm? *.o *.result *.log *.s\n";
  Printf.fprintf make_oc "std_exit:\n";
  Printf.fprintf make_oc "\t@echo > std_exit.ml\n";
  Printf.fprintf make_oc "\t$(OCAMLOPT) -S -c std_exit.ml\n";
  let targets = ref [] in
  List.iter (fun test ->
    let target = print_test make_oc test in
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
  Printf.fprintf make_oc "\t@echo Compiling restuls in testsuite.log...\n";
  Printf.fprintf make_oc "\t@echo Testsuite results > testsuite.log\n";
  List.iter (fun target ->
    Printf.fprintf make_oc "\t@echo '--------------------- %s --------------------' >> testsuite.log\n" target;
    Printf.fprintf make_oc "\t@cat %s >> testsuite.log\n" target;
    Printf.fprintf make_oc "\t@echo >> testsuite.log\n";
  ) targets;
  Printf.fprintf make_oc "\t@grep TEST testsuite.log\n";
  let ntests = List.length targets in
  Printf.fprintf make_oc "\t@$(ECHO_NONL) 'Tests OK (on %d tests): '$(NONL)\n" ntests;
  Printf.fprintf make_oc "\t@grep 'PASSED TEST' testsuite.log | wc -l\n";
  Printf.fprintf make_oc "\t@$(ECHO_NONL) 'Tests KO (on %d tests): '$(NONL)\n" ntests;
  Printf.fprintf make_oc "\t@grep 'FAILED TEST' testsuite.log | wc -l\n";
  close_out make_oc;

  ()
