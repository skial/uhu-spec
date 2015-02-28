package uhx.seri;

import uhx.sys.Seri;
import utest.Assert;

/**
 * ...
 * @author Skial Bainn
 */
class SeriSpec {

	public function new() {
		
	}
	
	public function testVersion() {
		Assert.equals( '7.0.0', Seri.version );
	}
	
	public function testCategory() {
		var codepoints0 = Seri.getCategory( 'Zs' );
		var codepoints1 = Seri.getCategory( 'P' );
	}
	
}