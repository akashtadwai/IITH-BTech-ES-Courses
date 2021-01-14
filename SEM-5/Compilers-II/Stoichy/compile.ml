open Ast
open Str
open Printf
open Parser
open Helper
module StringMap = Map.Make(String);;

let string_of_type = function 
      IntType -> "int"
    | BooleanType -> "Boolean"
    | StringType -> "String"
    | DoubleType -> "double"
    | _ -> ""
let string_of_var = function
    Molecule(s) -> s

let string_of_element = function
  Element(e) -> e

let string_of_molecule = function
  Molecule(m) -> m

let string_of_op = function
    Add -> "+"
  | Sub -> "-"
  | Mul -> "*"
  | Div -> "/"
  | Mod -> "%"

let string_of_rop = function
  | Gt -> ">"
  | Gtq -> ">="
  | Lt -> "<"
  | Ltq -> "<="
  | Eq -> "=="
  | Neq -> "!="

let string_of_re = function
  And -> "&&"
  | Or -> "||"

(* let string_of_boolean = function
  True -> string_of_bool true
  | False -> string_of_bool false *)

let string_of_element = function
   Element(e)-> e

let string_of_molecule = function
   Molecule(m)-> m

let string_of_mdecl_balance mdecl = mdecl.mname

let rec string_of_expr = function
  Int(i) -> string_of_int i
  | Double(d) -> string_of_float d
  | Bool (b) -> string_of_bool b
  | Boolean(e1, rop, e2) -> string_of_expr e1 ^ string_of_rop rop ^ string_of_expr e2
  | String (s) -> s
  | Asn(id, left) -> id ^ " = " ^ (string_of_expr left)
  | Call(s,l) -> s ^ "(" ^ String.concat "" (List.map string_of_expr l) ^ ")"
  | Access(o,m) -> (string_of_expr o) ^ "." ^ m ^"();"
  | Binop (e1, op, e2) ->
  (string_of_expr e1) ^ " " ^ (string_of_op op)
    ^ " " ^ (string_of_expr e2)
  | Brela (e1, op, e2) -> 
  (string_of_expr e1) ^ " " ^ (string_of_re op)
    ^ " " ^ (string_of_expr e2)
    | Noexpr -> ""
    | Null -> "NULL"
    | Concat(s1, s2) -> string_of_expr s1 ^ "+" ^ string_of_expr s2
    | List(elist) -> "[" ^  String.concat ", " (List.map string_of_expr elist) ^ "]"
    | Print(s) -> "System.out.println(" ^ string_of_expr s ^ ");" 
    | Equation(name, rlist, plist) -> "equation " ^ name ^ "{"  ^ String.concat "," (List.map string_of_element rlist) ^ "--" ^ String.concat "," (List.map string_of_element plist) ^ "}"
    | Mass(num) -> num ^ ".mass()"
    | Charge(num) -> num ^ ".charge()"
    | Electrons(num) -> num ^ ".electrons()" 
     | Bracket(e) -> "(" ^ string_of_expr e ^ ")"
    | Balance(llist, rlist) -> "Balance(\"" ^  String.concat " " (List.map string_of_molecule llist) ^ "==" ^ String.concat " " (List.map string_of_molecule rlist) ^ "\")"


let string_of_edecl edecl = "Element " ^ edecl.name ^ "= new Element(" ^ (string_of_int edecl.electrons)^ "," ^ (string_of_float edecl.mass) ^ "," ^ (string_of_int edecl.charge) ^ ");\n" 
let string_of_mdecl mdecl =  "ArrayList<Element> " ^ mdecl.mname ^ "1 = new ArrayList<Element>(Arrays.asList(" ^ String.concat "," (List.map string_of_element mdecl.elements) ^ "));\n" ^ 
"Molecule " ^ mdecl.mname ^ "= new Molecule("^ mdecl.mname ^ "1);\n"

let string_of_pdecl pdecl = string_of_type pdecl.ptype ^ " " ^ pdecl.pname  
let string_of_pdecl_list pdecl_list = String.concat "" (List.map string_of_pdecl pdecl_list)
let string_of_vdecl vdecl = string_of_type vdecl.vtype ^ " " ^ vdecl.vname ^ ";\n" 

let rec string_of_stmt = function
      Block(stmts) ->
        "{\n" ^ String.concat "" (List.map string_of_stmt stmts) ^ "}\n"
    | Expr(expr) -> string_of_expr expr ^ ";\n"
    | Return(expr) -> "return " ^ string_of_expr expr ^ ";\n"
    | If(e, s1, s2) -> "if (" ^ string_of_expr e ^ ")\n" ^ (string_of_stmt s1) ^ "\n" ^ "else\n" ^ (string_of_stmt s2) ^ "\n"
    | For(e1, e2, e3, s) ->
      "for (" ^ string_of_expr e1  ^ " ; " ^ string_of_expr e2 ^ " ; " ^
      string_of_expr e3  ^ ") " ^ string_of_stmt s ^ "\n"
    | While(e, s) -> "while (" ^ string_of_expr e ^ ") {" ^ (string_of_stmt s) ^ "}\n"
    | Print(s) -> "System.out.println(" ^ string_of_expr s ^ ");\n"

let string_of_vdecl vdecl= 
    string_of_type vdecl.vtype ^ " " ^ vdecl.vname ^ ";"

let string_of_fdecl fdecl =
    if fdecl.fname = "main" then "public static void main(String args[])\n{\n" ^
  String.concat "" (List.map string_of_vdecl fdecl.locals) ^
  String.concat "" (List.map string_of_edecl fdecl.elements) ^
  String.concat "" (List.map string_of_mdecl fdecl.molecules) ^
  String.concat "" (List.map string_of_stmt fdecl.body) ^
  "}\n"
else
  "public static void " ^ fdecl.fname ^ "(" ^ String.concat ", " (List.map string_of_pdecl fdecl.arguments) ^ ")\n{\n" ^
  String.concat "" (List.map string_of_vdecl fdecl.locals) ^
  String.concat "" (List.map string_of_edecl fdecl.elements) ^
  String.concat "" (List.map string_of_mdecl fdecl.molecules) ^
  String.concat "" (List.map string_of_stmt fdecl.body) ^
  "}\n"

let string_of_fdecl_list fdecl_list = 
    String.concat "" (List.map string_of_fdecl fdecl_list)

let string_of_program (vars, funcs) =
  String.concat "" (List.map string_of_vdecl (List.rev vars) ) ^ "\n" ^
  String.concat "\n" (List.map string_of_fdecl (List.rev funcs) ) ^ "\n"


let rec charge_sum molecule = match molecule with
	| [] -> 0
	| hd :: tl -> hd.charge + charge_sum tl;;


let contains s1 s2 =
    let re = Str.regexp_string s2
    in
        try ignore (Str.search_forward re s1 0); true
        with Not_found -> false

let program program prog_name =
     let prog_string = Helper.balance_head ^ prog_name ^ Helper.balance_mid  ^ Helper.balance_mid1 ^ prog_name ^ Helper.balance_mid15 ^ Helper.balance_mid2 ^ (string_of_fdecl_list program) ^ Helper.balance_end in
       let out_chan = open_out (Printf.sprintf "%s.java" prog_name) in
          ignore(Printf.fprintf out_chan "%s" prog_string); 
      close_out out_chan; 
        ignore(Sys.command(Printf.sprintf "javac %s.java" prog_name)); 
        ignore(Sys.command(Printf.sprintf "java %s" prog_name)); 