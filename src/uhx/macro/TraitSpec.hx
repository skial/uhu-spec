package uhx.macro;

import utest.Assert;

/**
 * ...
 * @author Skial Bainn
 */
private class TraitA {
	
	public function new() {
		
	}
	
	public var word:String = 'om nom nom';
	public var counter:Int = 0;
	
	public function sayHelloWorld():String {
		return 'Hello World';
	}
	
	public static function sayHelloUniverse():String {
		return 'Hello Universe';
	}
	
}

private class TestA {
	
	public var word:String = 'nik';
	
	@:use var traits = [TraitA];
	
	public function new() {
		
	}
	
	public function doSomething():String {
		return 'no';
	}
	
}

private class TestB {
	
	@:use var traits = [TraitA];
	
	public function new() {
		
	}
	
}

class TraitSpec {
	
	public function new() {
		
	}
	
	public function testTrait_forwarding() {
		var a = new TestA();
		var b = new TestB();
		var o = new TraitA();
		
		Assert.equals( 'Hello World', a.sayHelloWorld() );
		Assert.equals( 0, a.counter );
		a.counter++;
		Assert.equals( 1, a.counter );
		Assert.equals( 0, o.counter );
		Assert.equals( 'Hello Universe', TestA.sayHelloUniverse() );
		Assert.equals( 'nik', a.word );
		Assert.equals( 'om nom nom', b.word );
	}
	
}