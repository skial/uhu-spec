package ;

import haxe.ds.StringMap;
import haxe.macro.Compiler;
import haxe.macro.Printer;
import haxe.macro.Type;
import haxe.macro.Expr;
import haxe.macro.Context;

using StringTools;
using haxe.macro.MacroStringTools;

/**
 * ...
 * @author Skial Bainn
 */
class Macro {
	
	public static var previous:String = 'Helper';
	public static var parent:ClassType = null;
	public static var processed:StringMap<String> = new StringMap();
	public static var values:Array<Expr> = [];

	public static function build() {
		var cls:ClassType = Context.getLocalClass().get();
		var path = cls.pack.toDotPath( cls.name );
		var fields = Context.getBuildFields();
		
		parent = cls;
		var superCls = cls.superClass;
		while (superCls != null) {
			var c = superCls.t.get();
			var n = c.pack.toDotPath( c.name );
			
			parent = c;
			
			if (!processed.exists(n)) {
				for (field in c.fields.get()) {
					
					for (meta in field.meta.get()) if (meta.name == 'f' && meta.params != null) {
						values = values.concat( meta.params );
					}
					
				}
				processed.set(n, '');
			}
			
			superCls = c.superClass;
			
		}
		
		if (!processed.exists( path )) {
			for (field in fields) for (meta in field.meta) if (meta.name == 'f' && meta.params != null) {
				values = values.concat( meta.params );
			}
			processed.set( path, '' );
		}
		
		var helperName = 'H${Math.random()}'.replace('.', '_');
		var helperClass = {
			pack:[], name: helperName, pos: cls.pos, 
			meta: [ { name:':native', params:[macro 'Helper'], pos:cls.pos }, { name:':keep', params:[], pos:cls.pos } ],
			kind: TDClass(), fields:[{name:'values', access:[APublic, AStatic], kind:FVar(macro:Array<String>, macro $a{values}), pos:cls.pos}]
		}
		
		Context.defineType( helperClass );
		Compiler.exclude( previous );
		previous = helperName;
		
		return fields;
	}
	
}