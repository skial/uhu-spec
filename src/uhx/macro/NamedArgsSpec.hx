package uhx.macro;

import utest.Assert;
/**
 * ...
 * @author Skial Bainn
 */
class NamedArgsSpec implements Klas {

	public function new() {
		
	}
	
	public function testOptionalArgs() {
		var a = new A( @:a 'Hello' );
		var b = new A( @:b 'World' );
		var c = new A( @:c 'Haxe' );
		var d = new A( @:d 'Foo' );
		var e = new A( @:d '<=', @:a '=>' );
		var f = new A( 'Hello', @:d '!!', @:c '??' );
		
		Assert.equals('Hello', a._a);
		Assert.equals('World', b._b);
		Assert.equals('Haxe', c._c);
		Assert.equals('Foo', d._d);
		
		Assert.equals('<=', e._d);
		Assert.equals('=>', e._a);
		
		Assert.equals('Hello', f._a);
		Assert.equals('??', f._c);
		Assert.equals('!!', f._d);
	}
	
	public function testRequiredArgs() {
		var g = new B(1, 2, @:d 99);
		var h = new B(-1, -2, @:c -99);
		
		Assert.equals(1, g._a);
		Assert.equals(2, g._b);
		Assert.equals(0, g._c);
		Assert.equals(99, g._d);
		
		Assert.equals(-1, h._a);
		Assert.equals(-2, h._b);
		Assert.equals(-99, h._c);
		Assert.equals(0, h._d);
	}
	
	public function testColonlessMeta() {
		var d = new A( @d 'Foo' );
		Assert.equals('Foo', d._d);
	}
	
	public function testMethodCall() {
		var ech = echo(@:c 3.3, @a 'Hello Hello Hello', @:b 10);
		Assert.equals( 'Hello Hello Hello', ech.a );
		Assert.equals( 10, ech.b );
		Assert.equals( 3.3, ech.c );
	}
	
	public function testNestedMethodCall() {
		var m = function(a:String, b:Int, c:Float) return function(a:String, b:Int, c:Float) return { a:a, b:b, c:c };
		var r = m(@c 4.4, @a 'Hello', @b 10)(@c 3.3, @a 'Hello', @b 10);
		var r2 = m('', 0, 4.4)('', 0, 3.3);
		Assert.equals( 'Hello', r.a );
		Assert.equals( 10, r.b );
		Assert.equals( 3.3, r.c );
	}
	
	public function echo(a:String, b:Int, c:Float): { a:String, b:Int, c:Float } {
		return { a:a, b:b, c:c };
	}
	
}

class A {
	
	public var _a:String;
	public var _b:String;
	public var _c:String;
	public var _d:String;
	
	public function new(?a:String, ?b:String, ?c:String, ?d:String) {
		_a = a;
		_b = b;
		_c = c;
		_d = d;
	}
	
}

class B {
	
	public var _a:Int;
	public var _b:Int;
	public var _c:Int;
	public var _d:Int;
	
	public function new(a:Int, b:Int, c:Int = 0, d:Int = 0) {
		_a = a;
		_b = b;
		_c = c;
		_d = d;
	}
}