package ;

import haxe.macro.*;
import haxe.macro.Expr.ComplexType;
using haxe.macro.ExprTools;

/**
 * ...
 * @author Skial Bainn
 */
class Builder {
	
	public static var localVars:Array<Expr> = [];
	
	public static function build() {
		var cls = Context.getLocalClass().get();
		var fields = Context.getBuildFields();
		
		for (field in fields) switch (field.kind) {
			case FFun(m) if (m.expr != null):
				m.expr.iter( process );
				
			case _:
				
		}
		
		return fields;
	}
	
	public static function process(expr:Expr) {
		switch (expr) {
			case macro var $id:$type:
				localVars.push( expr );
				
			case macro var $id:$type = $e:
				localVars.push( expr );
				
			case { expr:EBinop(OpBoolOr, e1, e2), pos:p } :
				for (ee in [e1, e2]) inspect( ee, findLastType( expr ) );
				
			case _:
				expr.iter( process );
		}
	}
	
	public static function inspect(expr:Expr, ctype:ComplexType) {
		switch (expr) {
			case { expr:EBinop(OpBoolOr, _, _), pos:_ }:
				expr.iter( inspect.bind(_, ctype) );
				
			case { expr:EConst(CIdent(ident)), pos:p } :
				for (i in 0...localVars.length) switch (localVars[i]) {
					case { expr:EVars([v = { name:n, type:t, expr:e } ]), pos:_ } :
						
						if (n == ident) {
							if (t == null) {
								t = ctype;
							}
							if (!Context.unify(ComplexTypeTools.toType(t), Context.getType('Bool'))) {
								v.type = macro :Main.N<$t>;
							}
							
						}
						
					case _:
						
				}
				
			case _:
				
				
		}
	}
	
	public static function findLastType(expr:Expr) {
		var result = null;
		
		switch (expr) {
			case { expr:EConst(c), pos:_ } :
				result = switch(c) {
					case CInt(_): macro:Int;
					case CFloat(_): macro:Float;
					case CString(_): macro:String;
					case CRegexp(_, _): macro:EReg;
					case CIdent(i):
						null;
				}
				
			case _:
				expr.iter( function(e) result = findLastType(e) );
		}
		
		return result;
	}
	
}