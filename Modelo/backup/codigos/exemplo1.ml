type binop =
    Plus
  | Minus
  | Times
  | Div
  | Mod
  | Le
  | Leq
  | Ge
  | Geq
  | Eq
  | Neq
  | And
  | Or

type uop = Uminus | Neg

type mptype = Integer | Boolean | Void | Record of string | Pointer

