package example.macroExprFails;

import haxe.macro.Expr;
using haxe.macro.ExprTools;

/**
 * ...
 * @author Skial Bainn
 */
class Foo {

	public static macro function bar(a1:ExprOf<String>, rest:Array<Expr>):ExprOf<StringBuf> {
		var r = macro @:mergeBlock {
			var buf = new StringBuf();
			buf.add( $a1 );
			buf;
		}
		trace( r.toString() );
		return r;
	}
	
}