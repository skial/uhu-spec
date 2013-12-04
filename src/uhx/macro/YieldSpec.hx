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
	
	public function testTicker_simple_manual() {
		var count = ticker();
		Assert.equals(1, count.next());
		Assert.equals(2, count.next());
	}
	
	public function testTicker_simple_for() {
		var tick = ticker();
		var values = [for (t in tick) t];
		Assert.equals('' + [1, 2, 3, 4, 5], '' + values);
		Assert.equals(false, tick.hasNext());
	}
	
	public function testTicker_simple_while() {
		var values = [];
		var tick = ticker();
		while (tick.hasNext()) values.push( tick.next() );
		Assert.equals('' + [1, 2, 3, 4, 5], '' + values);
		Assert.equals(false, tick.hasNext());
	}
	
	public function testLoop_range_manual() {
		var range = range();
		Assert.equals(0, range.next());
		Assert.equals(1, range.next());
	}
	
	public function testLoop_range_for() {
		var range = range();
		var values = [for (r in range) r];
		Assert.equals('' + [0, 1, 2, 3, 4], '' + values);
		Assert.equals(false, range.hasNext());
	}
	
	public function testLoop_range_while() {
		var values = [];
		var range = range();
		while (range.hasNext()) values.push( range.next() );
		Assert.equals('' + [0, 1, 2, 3, 4], '' + values);
		Assert.equals(false, range.hasNext());
	}
	
	public function testLoop_multi_range_manual() {
		var range = multi_range();
		Assert.equals(1, range.next());
		Assert.equals(2, range.next());
		Assert.equals(3, range.next());
	}
	
	public function testLoop_multi_range_for() {
		var range = multi_range();
		var values = [for (r in range) r];
		Assert.equals('' + [1, 2, 3, 2, 3, 4], '' + values);
		Assert.equals(false, range.hasNext());
	}
	
	public function testLoop_multi_range_while() {
		var values = [];
		var range = multi_range();
		while (range.hasNext()) values.push( range.next() );
		Assert.equals('' + [1, 2, 3, 2, 3, 4], '' + values);
		Assert.equals(false, range.hasNext());
	}
	
	public function testArg_manual() {
		var range = arg(2);
		Assert.equals(0, range.next());
		Assert.equals(2, range.next());
		Assert.equals(4, range.next());
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
	
	public function range() {
		for (i in 0...5) {
			@:yield return i;
		}
	}
	
	public function multi_range() {
		for (i in 0...2) {
			@:yield return i + 1;
			@:yield return i + 2;
			@:yield return i + 3;
		}
	}
	
	public function arg(v:Int) {
		for (i in 0...5) {
			@:yield return v * i;
		}
	}
	
}