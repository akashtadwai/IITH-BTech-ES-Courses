open Ast
open Str
open Printf

type env = {
	mutable functions : func_decl list;
}

(* returns true when given name is same as that of variables's name else returns false *)
let function_var_name name = function
	variable -> variable.vname = name


(* returns true when given name is same as that of function's name else returns false *)
let function_equal_name name = function
	func -> func.fname = name


(* returns true when given name is same as that of parameters's name else returns false *)
let function_fparam_name name = function
	par -> par.pname = name


(*Checks if function has been declared or not*)
let exist_function_name name env = List.exists (function_equal_name name) env.functions


(* Checks whether a function has been defined more than once *)
let function_exist func env = 
	let name = func.fname in
	   try
		   let _ = List.find (function_equal_name name) env.functions in             
			   let e = "Duplicate function: "^ name ^" has been defined more than once" in
				   raise (Failure e)
		with Not_found -> false


(* checks if the function name is there in the list of functions *)
let get_function_by_name name env = 
	try
		   let result = List.find (function_equal_name name) env.functions in
			      result
  with Not_found -> raise(Failure("Function "^ name ^ " has not been declared"))


(* checks if the a variable 'name' has been declared *)
let get_variable_by_name name func = 
	try
		let result = List.find(function_var_name name) func.locals in
		result
	with Not_found -> raise(Failure("Local Variable " ^ name ^ "is not declared"))


(* checks if the a parameter 'name' has been declared *)
let get_formal_by_name name func = 
	try
		let result = List.find(function_fparam_name name) func.arguments in
			result
	with Not_found -> raise(Failure("Parameter" ^ name ^ " is not declared"))


let count_function_variables func = function
	a -> let f count b = 
	if b = a 
		then count+1
		else count 
in 
	let count = List.fold_left f 0 func.locals in
		if count > 0
			then raise (Failure("Duplicate variable in function " ^ func.fname))
			else count


let count_function_params func = function
	a -> let f count b = 
	if b = a 
		then count+1
		else count 
in 
	let count = List.fold_left f 0 func.arguments in
		if count > 0
			then raise (Failure("Duplicate parameter in function " ^ func.fname))
			else count


(* checks if a variable with the given name "vname" exists in our function *)
let exists_variable_decl func vname =
try
 List.exists (function_var_name vname) func.locals
with Not_found -> raise (Failure ("Variable " ^ vname ^ " not found in function " ^ func.fname))


(* checks if a formal paramter with the given name ‘fpname’ exists in our function*)
let exists_formal_param func fpname =
try
 List.exists (function_fparam_name fpname) func.arguments
with Not_found -> raise (Failure ("Formal Parameter " ^ fpname ^ " not found in function " ^ func.fname))


(* checks if there are duplicate parameter names *)
let dup_param_name func fpname = 
	let name = func.arguments in
		try 
			List.find (function name -> name.pname = fpname.pname ) name 
	with Not_found -> raise (Failure ("Duplicate parameter names"))


(* finds the given parameter in the list of function parameters *)
let get_fparam_type func fpname = 
	let name = func.arguments in
		try
			let fparam = List.find(function_fparam_name fpname) name in
				fparam.ptype
		with Not_found -> raise (Failure ("Formal parameter should exist but not found"))


(* gets the type of the given variable name *)
let get_var_type func vname = 
	let name = func.locals in 
		try
			let var = List.find(function_var_name vname) name in 
				var.vtype
		with Not_found -> raise (Failure ("Variable not found"))


(* checks if there exits a function with given name or not *)
let find_function func env =
 try
 let _ = List.find (function_equal_name func) env.functions in
 true (*return true on success*)
 with Not_found -> raise Not_found


(* checks if the identifier given exists or not *)
let exists_id name func = (exists_variable_decl func name) || (exists_formal_param func name)


let is_int s =
 try ignore (int_of_string s); true
 with _ -> false

let is_float s =
 try ignore (float_of_string s); true
 with _ -> false

(* checks if s is a number or not *)
let rec is_num func = function
	  Int(_) -> true
	| Double(_) -> true
	| Binop(e1,_,e2) -> (is_num func e1) && (is_num func e2)
	| _ -> false

(* checks if s is a letter or not *)
let is_letter s = string_match (regexp "[A-Za-z]") s 0    

(* checks if s is a string or not *)
let is_string s = string_match (regexp "\".*\"") s 0

(* checks if s is a boolean or not *)
let rec is_boolean func = function
	Boolean(_) -> true
	| _ -> false 

(* checks if s is either "true" or "false" or not *)
let is_string_bool = function "true" -> true | "false" -> true | _ -> false


let rec get_expr_type e func =
	match e with
		| String(s) -> StringType
		| Int(s) -> IntType
		| Double(f) -> DoubleType
		| Bool (s) -> BooleanType
		| Boolean(_,_,_) -> BooleanType
		| Binop(e1,_,e2) -> get_expr_type e1 func
		| Brela(e1,_,e2) -> BooleanType
		| Asn(expr, expr2) -> get_expr_type expr2 func
		| Concat(s, s2) -> StringType
		| Bracket(e1) -> get_expr_type e1 func
		| Access(id,attr) ->  (* Call only returns mass, charge, or electrons *)
			begin 
				match attr with 
				  "mass"  -> DoubleType 
				| _ -> IntType 
			end
		| Equation (_, _, _) -> EquationType
		| Balance (_, _) -> StringType
		| Print _ -> StringType
		| List _ -> IntType
		| Call (_, _) -> IntType
		| Charge _ -> IntType (* change type *)
		| Electrons _ -> IntType
		| Mass _ -> DoubleType
		| Null -> IntType
		| Noexpr -> IntType

let rec valid_expr (func : Ast.func_decl) expr env =
	match expr with
	  Int(_) -> true
	| Double(_) ->  true
	| Boolean(_) -> true
	| String(_) -> true
	| Binop(e1,_,e2) -> let t1 = get_expr_type e1 func and t2 = get_expr_type e2 func in
			begin 
				match t1, t2 with 
				  DoubleType, DoubleType -> true
				| IntType, IntType -> true (*try adding Int + Double *)
				| _,_ -> raise (Failure "Types for binary expresion must be matching int or double")
			end
	| Brela (e1,_,e2) -> let t1 = get_expr_type e1 func and t2 = get_expr_type e2 func in 
			begin
				match t1, t2 with 
					BooleanType, BooleanType -> true
				| _,_ -> raise (Failure "Invalid type for AND, OR expression") 
			end
	| Asn(id, expr2) ->
		begin
			let t1 = (get_var_type func id) and t2 = get_expr_type expr2 func in 
				match t1,t2 with
				  StringType, StringType -> true
				| IntType, IntType -> true
				| DoubleType, DoubleType -> true
				| ElementType, ElementType -> true
				| MoleculeType, MoleculeType -> true
				| EquationType, EquationType -> true
				| IntType, StringType -> true
				| StringType, IntType -> true
				| BooleanType,BooleanType ->true
				| _,_ -> raise(Failure ("variable's data type doesnt match in the assign expression"))
		end
	| Concat(e1,e2) -> 
		begin
			match get_expr_type e1 func, get_expr_type e2 func with
		  		  StringType, StringType -> true
				| _,_ -> raise(Failure("Concatenation only works between two strings"))
		end
	| Call(f_name,_) -> exist_function_name f_name env
	| List(e_list) -> let _ = List.map (fun e -> valid_expr func e env) e_list in true
	| _ -> true

let has_return_stmt list =
	if List.length list = 0
		then false
		else match (List.hd (List.rev list)) with
		  Return(_) -> true
		| _ -> false

let has_return_stmt func =
	let stmt_list = func.body in
		if List.length stmt_list = 0
			then false
			else match List.hd (List.rev stmt_list), func.fname with
			  Return(e),"main" -> raise(Failure("Return statement not permitted in main method"))
			| _, "main" -> false 
			| Return(e), _ -> true
			| _,_ -> false


(*given a variable, the function returns its data type*)
let get_type func name =
	if exists_variable_decl func name
		then get_var_type func name
		else
			if exists_formal_param func name 
				then get_fparam_type func name
				else (*Variable isn't declared*)
					let e = "Variable \"" ^ name ^ "\" is not declared in function \"" ^ func.fname ^ "\"" in
						raise (Failure e)


(* Check that the body is valid *)
let valid_body func env = 
	(* Check all statements in a block recursively, will throw error for an invalid stmt *)
	let rec check_stmt = function
		  Block(stmt_list) -> let _ = List.map(fun s -> check_stmt s) stmt_list in
		  	true
		| Expr(expr) -> let _ = valid_expr func expr env in
			true
		| Return(expr) -> let _ = valid_expr func expr env in
			true
		| If(condition, then_stmts, else_stmts) -> let cond_type = get_expr_type condition func in
			begin
				match cond_type with
					  BooleanType -> 
					  	if (check_stmt then_stmts) && (check_stmt else_stmts)
					  		then true
					  		else raise( Failure("Invalid statements in If statement within function \"" ^ func.fname ^ "\""))
					| _ -> raise( Failure("Condition of If statement is not a valid boolean expression within function \"" ^ func.fname ^ "\"") )
			end
		| For(init, condition, do_expr, stmts) -> let cond_type = get_expr_type condition func in 
			let _ = valid_expr func do_expr env in 
				let _ = valid_expr func init env in
					begin
						match cond_type with 
							  BooleanType -> 
							  	if check_stmt stmts
							  		then true
							  		else raise( Failure("Invalid statements in For loop within function \"" ^ func.fname ^ "\""))
							| _ -> raise( Failure("Condition of For loop is not a valid boolean expression within function \"" ^ func.fname ^ "\"") )
					end
		| While(condition, stmts) -> let cond_type = get_expr_type condition func in
			begin
				match cond_type with
					  BooleanType -> 
					  	if check_stmt stmts
					  		then true
							else raise( Failure("Invalid statments in While loop within function \"" ^ func.fname  ^ "\"") )
					| _ -> raise( Failure("Condition of While loop is not a valid boolean expression within function \"" ^ func.fname ^ "\"") )
			end
		| Print(expr) -> let expr_type = get_expr_type expr func in
			begin
				match expr_type with
					  StringType -> true
					| IntType -> true
					| BooleanType ->true
					| _ -> raise( Failure("Print in function \"" ^ func.fname ^ "\" does not match string type") )
			end

	in
		let _ = List.map(fun s -> check_stmt s) func.body in
			true

let valid_func env f = 
	let duplicate_functions = function_exist f env in 
		(* let duplicate_parameters = count_function_params f in *)
			let v_body = valid_body f env in 
				let _ = env.functions <- f :: env.functions in
				(not duplicate_functions) && (* (not duplicate_parameters) && *) v_body

let check_program flist =
	let (environment : env) = { functions = [] (* ; variables = [] *) } in
		let _validate = List.map ( fun f -> valid_func environment f) flist in
				true