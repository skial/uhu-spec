package uhx.macro;

import utest.Assert;

/**
 * ...
 * @author Skial Bainn
 */
private class TraitA {
	
	public function new() {
		
	}
	
	public var counter:Int = 0;
	
	public function sayHelloWorld():String {
		return 'Hello World';
	}
	
	public static function sayHelloUniverse():String {
		return 'Hello Universe';
	}
	
}

private class Test implements Klas {
	
	@:use var traits = [TraitA];
	
	public function new() {
		
	}
	
	public function doSomething():String {
		return 'no';
	}
	
}

class TraitSpec {
	
	public function new() {
		
	}
	
	public function testTrait_forwarding() {
		var t = new Test();
		var o = new TraitA();
		
		Assert.equals( 'Hello World', t.sayHelloWorld() );
		Assert.equals( 0, t.counter );
		t.counter++;
		Assert.equals( 1, t.counter );
		Assert.equals( 0, o.counter );
		Assert.equals( 'Hello Universe', Test.sayHelloUniverse() );
	}
	
}