open Values

module ExportMap = Map.Make(String)

type global = value ref

type closure =
  | AstFunc of instance ref * Ast.func
  | HostFunc of (value list -> value list)

and extern =
  | ExternalFunc of closure
  | ExternalTable of Table.t
  | ExternalMemory of Memory.t
  | ExternalGlobal of value

and instance =
{
  module_ : Ast.module_;
  funcs : closure list;
  tables : Table.t list;
  memories : Memory.t list;
  globals : global list;
  exports : extern ExportMap.t;
}

exception Func of closure

let instance m =
  { module_ = m; funcs = []; tables = []; memories = []; globals = [];
    exports = ExportMap.empty }

let export inst name =
  try Some (ExportMap.find name inst.exports) with Not_found -> None
