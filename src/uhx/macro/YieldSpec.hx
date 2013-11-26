package uhx.macro;

import haxe.Timer;
import utest.Assert;

/**
 * ...
 * @author Skial Bainn
 */
class YieldSpec implements Klas {

	public function new() {
		
	}
	
	public function testTicker_manual() {
		var count = ticker();
		Assert.equals(1, count.next());
		Assert.equals(2, count.next());
	}
	
	public function testTicker_for() {
		var values = [for (t in ticker()) t];
		Assert.equals('' + [1, 2, 3, 4, 5], '' + values);
	}
	
	public function ticker() {
		trace( 'Hello' );
		@:yield return 1;
		trace( 'Hello World' );
		@:yield return 2;
		trace( 'Hello Universe' );
		@:yield return 3;
		trace( 'Goodbye' );
		@:yield return 4;
		trace( 'Goodbye World' );
		@:yield return 5;
	}
	
}