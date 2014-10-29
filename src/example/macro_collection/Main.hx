package ;

/**
 * ...
 * @author Skial Bainn
 */
class Main {
	
	public static function main() new Main();

	public function new() {
		new A();
		trace( Helper.values );
	}
	
}

class Helper {
	public static var values:Array<String> = [];
}

// Need to use an interface as opposed to putting it
// on `A` so `A` actually gets passed to the build 
// macro.
@:autoBuild( Macro.build() )
interface Builder{}

class A implements Builder {
	@f('1') public var a:String = 'a';
	public function new() {}
}

class B extends A {
	@f('2') public var b:String = 'b';
	public function new() { super(); }
}

class C extends B {
	@f('3') public var c:String = 'c';
	public function new() { super(); }
}

class D extends C {
	@f('4') public var d:String = 'd';
	public function new() { super(); }
}