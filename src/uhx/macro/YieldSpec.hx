package uhx.macro;

import haxe.Timer;
import utest.Assert;

/**
 * ...
 * @author Skial Bainn
 */
class YieldSpec {

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
		var range = range_loop();
		Assert.equals(0, range.next());
		Assert.equals(1, range.next());
	}
	
	public function testLoop_range_for() {
		var range = range_loop();
		var values = [for (r in range) r];
		Assert.equals('' + [0, 1, 2, 3, 4], '' + values);
		Assert.equals(false, range.hasNext());
	}
	
	public function testLoop_range_while() {
		var values = [];
		var range = range_loop();
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
	
	public function testArg_for() {
		var args = arg(2);
		var values = [for (a in args) a];
		Assert.equals('' + [0, 2, 4, 6, 8], '' + values);
		Assert.equals(false, args.hasNext());
	}
	
	public function testArg_while() {
		var values = [];
		var args = arg(2);
		while (args.hasNext()) values.push( args.next() );
		Assert.equals('' + [0, 2, 4, 6, 8], '' + values);
		Assert.equals(false, args.hasNext());
	}
	
	public function testWhileIf_manual() {
		var whif = whileIf(10);
		Assert.equals(0, whif.next());
		Assert.equals(1, whif.next());
		Assert.equals(2, whif.next());
	}
	
	public function testWhileIf_for() {
		var whifs = whileIf(2);
		var values = [for (w in whifs) w];
		Assert.equals('' + [0, 1], '' + values);
		Assert.equals(false, whifs.hasNext());
	}
	
	public function testIfs_manual() {
		var ifs = ifs();
		Assert.equals(20, ifs.next());
		Assert.equals(30, ifs.next());
		Assert.equals(5, ifs.next());
		Assert.equals(5, ifs.next());
		Assert.equals(false, ifs.hasNext());
		Assert.equals(5, ifs.next());
	}
	
	public function testFib_manual() {
		var fib = fibonacci(10);
		// http://en.wikipedia.org/wiki/Fibonacci_number
		// This is correct, but my initial intention was to output
		// the following `1, 1, 2, 3, 5, 8, ...`. TODO `this.current` is being generated to soon, I think :)
		Assert.equals( 0, fib.next() );
		Assert.equals( 1, fib.next() );
		Assert.equals( 1, fib.next() );
		Assert.equals( 2, fib.next() );
		Assert.equals( 3, fib.next() );
		Assert.equals( 5, fib.next() );
		Assert.equals( 8, fib.next() );
		Assert.equals( false, fib.hasNext() );
	}
	
	public function testFib_for() {
		var fib = fibonacci(10);
		var values = [for (f in fib) f];
		Assert.equals('' + [0, 1, 1, 2, 3, 5, 8], '' + values);
		Assert.equals(false, fib.hasNext());
	}
	
	public function log(v:Dynamic) {
		return v;
	}
	
	@:generator public function ticker() {
		log( 'Hello' );
		return 1;
		log( 'Hello World' );
		return 2;
		log( 'Hello Universe' );
		return 3;
		log( 'Goodbye' );
		return 4;
		log( 'Goodbye World' );
		return 5;
	}
	
	@:generator public function range_loop() {
		for (i in 0...5) {
			return i;
		}
	}
	
	@:generator public function multi_range() {
		for (i in 0...2) {
			return i + 1;
			return i + 2;
			return i + 3;
		}
	}
	
	@:generator public function arg(v:Int) {
		for (i in 0...5) {
			return v * i;
		}
	}
	
	@:generator public function whileIf(limit:Int) {
		var v = 0;
		while (true) {
			if (v == v) {
				if (v == limit) break;
				return v++;
			}
		}
	}
	
	@:generator public function ifs() {
		var v = 10;
		if (v < 11) return v * 2;
		if (v < 12) return v * 3;
		if (v > 9) {
			return v / 2;
		}
		if (v > 2) {
			break;
		}
		return v;
	}
	
	@:generator public function fibonacci(limit:Int) {
		var f1:Int = 1;
		var f2:Int = 1;
		var result:Int = 0;
		while (true) {
			result = f2;
			f2 = f1;
			f1 = f1 + result;
			if (result > limit) break;
			return result;
		}
	}
	
}