type operator = Add | Sub | Mul | Div | Mod
type rop = Eq | Neq | Lt | Ltq | Gt | Gtq 
type re = And | Or
(* type bool = True | False *)
type datatypes = IntType | BooleanType | StringType | DoubleType | ElementType | MoleculeType | EquationType
type element = Element of string
type molecule = Molecule of string

type expr =
    Binop of expr * operator * expr
  | Brela of expr * re * expr
  | Int of int
  | String of string 
  | Bool of bool
  | Boolean of expr * rop * expr
  | Double of float
  | Asn of string * expr
  | Equation of string * element list * element list
  | Balance of molecule list * molecule list
  | Concat of expr * expr
  | Print of expr
  | List of expr list 
  | Call of string * expr list
  | Access of expr * string
  | Bracket of expr
  | Charge of string
  | Electrons of string
  | Mass of string
  | Null 
  | Noexpr

type statement = 
    Block of statement list
  | Expr of expr
  | Return of expr
  | If of expr * statement * statement
  | For of expr * expr * expr * statement
  | While of expr * statement
  | Print of expr

type variable_decl = {
  vname : string;
  vtype : datatypes;
}

type element_decl = {
  name : string;
  electrons : int;
  mass : float;
  charge : int;
}

type molecule_decl = {
  mname : string;
  elements: element list;
}

type par_decl = {
  pname : string;
  ptype : datatypes; 
}

type func_decl = {
  fname : string;
  arguments : par_decl list;
  locals: variable_decl list;
  elements : element_decl list;
  molecules : molecule_decl list;
  body : statement list;
}

type program = func_decl list