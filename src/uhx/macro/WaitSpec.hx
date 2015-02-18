package uhx.macro;

import haxe.Timer;
import utest.Assert;

/**
 * ...
 * @author Skial Bainn
 */
class WaitSpec implements Klas {

	public function new() {
		
	}
	
	public function testSingle() {
		@:wait doSomething( '123', [cbr] );
		
		Assert.equals( '123', cbr );
	}
	
	public function testNested() {
		@:wait doSomething( '123', [c1] );
		Assert.equals( '123', c1 );
		
		@:wait doSomething( c1 + '456', [c2] );
		Assert.equals( '123456', c2 );
		
		@:wait doSomething( c2 + '789', [c3] );
		Assert.equals( '123456789', c3 );
	}
	
	public function testMany() {
		@:wait doOther( 'abc', [success], [error] );
		Assert.equals( null, error );
		Assert.equals( 'abc', success );
	}
	
	public function testNestedMethod() {
		var async = Assert.createAsync( function() {
			@:wait doSomething( 'WOOOT', [cbr] );
			
			Assert.equals( 'WOOOT', cbr );
		} );
		
		async();
	}
	
	public function doSomething(v:String, cb:String->Void) cb(v);
	public function doOther(v:String, success:String->Void, error:String->Void) v == null? error('bugger') : success(v);
	
}