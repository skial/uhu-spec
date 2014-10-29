package ;

/**
 * ...
 * @author Skial Bainn
 */
@:build( Builder.build() )
class Main {
	
	public static function main() new Main();

	public function new() {
		var a = null;
		var b = null;
		
		trace( a || b || 'woot' );
	}
	
}


abstract N<T>(T) from T to T {
	
	public inline function new(v:T) this = v;
	
	@:to public inline function toBool():Bool return this != null;
	
	@:op(A || B)
	public static inline function or<T>(a:N<T>, b:N<T>) {
		return (a:N<T>) ? a : b;
	}
	
}