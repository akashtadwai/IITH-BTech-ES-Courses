exception InvalidProgram
exception NoInputFile
open Printf


let usage = Printf.sprintf "Usage: stoichy <filename>"

(* Getting file name *)

let get_prog_name source_file_path =
	let path = (Str.split (Str.regexp_string "/") source_file_path) in
	let file_name = List.nth path ((List.length path) - 1) in
	let split_name = (Str.split (Str.regexp_string ".") file_name) in
		List.nth split_name ((List.length split_name) - 2)


let main () =
  try
    let prog_name = 
			if Array.length Sys.argv > 1 then
				get_prog_name Sys.argv.(1)
			else raise NoInputFile in

		let input = open_in Sys.argv.(1) in

    let lexbuf = Lexing.from_channel input in
      let prog = Parser.start Lexer.tokens lexbuf in
        if Semantic.check_program prog
					then Compile.program prog prog_name
					else raise InvalidProgram
  	with
		| NoInputFile -> ignore(Printf.printf "Please provide a name for a Stoichy file.\n");exit 1
		| InvalidProgram -> ignore(Printf.printf "Invalid program. Semantic errors exist.\n");exit 1
    |  End_of_file -> printf "End of File!!"; exit 1


let _ = Printexc.print main ()