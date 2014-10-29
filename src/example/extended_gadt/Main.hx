package;

/**
 * ...
 * @author Skial Bainn
 */
class Main {
	
	public static function main() {
		new Main();
	}

	public function new() {
		var c = new C();
		var tc:TC = new C();
		
		// Doesnt compile, errors with `C has no field a that can be matched against`
		/*switch (c) {
			case { a:'a', b:'b', c:'c' } :
				trace( 'correct' );
				
			case _:
				trace( 'bugger' );
		}*/
		
		switch (tc) {
			case { a:'a', b:'b', c:'c' } :
				trace( 'correct' );
				
			case _:
				trace( 'bugger' );
		}
		
	}
	
}

class A {
	
	public var a:String = 'a';
	
	public function new() {
		
	}
	
}

class B extends A {
	
	public var b:String = 'b';
	
	public function new() {
		super();
	}
	
}

class C extends B {
	
	public var c:String = 'c';
	
	public function new() {
		super();
	}
	
}

typedef TC = {
	var a:String;
	var b:String;
	var c:String;
}