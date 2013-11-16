package uhx.macro;

import haxe.Timer;
import taurine.async._internal.Generator;
import utest.Assert;

/**
 * ...
 * @author Skial Bainn
 */
class YieldSpec implements Klas {

	public function new() {
		
	}
	
	@:access( taurine.async.Generator.test )
	public function testTickTock() {
		var clock = new Generator().change( {
			@yield 'tick';
			@yield 'tock';
		} );
		for (noise in clock) trace( noise );
		// TODO Wait.hx is stripping @:yield from the method body, even though it doesnt detect any @:wait meta. Big problem...
	}
	
}