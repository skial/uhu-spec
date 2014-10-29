package example.macroExprFails;

import haxe.macro.Expr;
import haxe.macro.Context;

using haxe.macro.ExprTools;

/**
 * ...
 * @author Skial Bainn
 */
class Build
{

	public static function build():Array<Field> {
		var fields = Context.getBuildFields();
		
		for (field in fields) {
			
			switch (field.kind) {
				case FFun(m):
					switch (m.expr) {
						case { expr:EBlock(es), pos:pos } :
							for (e in es) switch (e) {
								case macro @:meta1 $expr( $a { args } ):
									var type = Context.typeof( expr );
									trace( type );
									trace( args );
									/*switch (expr) {
										case { expr:ECall(_, params), pos:pos } :
											params[0].expr = (macro $v { 'WTF' }).expr;
											
										case _:
											
									}*/
									
								case _:
									
							}
							
						case _:
							
					}
					
				case _:
					
			}
			
		}
		
		return fields;
	}
	
}