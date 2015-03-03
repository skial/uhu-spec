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
		
		Assert.equals( 17, codepoints0.length );
		
		Assert.isTrue( codepoints0.indexOf( 0x0020 ) > -1 );
		Assert.isTrue( codepoints0.indexOf( 0x00A0 ) > -1 );
		Assert.isTrue( codepoints0.indexOf( 0x1680 ) > -1 );
		Assert.isTrue( codepoints0.indexOf( 0x2000 ) > -1 );
		Assert.isTrue( codepoints0.indexOf( 0x2001 ) > -1 );
		Assert.isTrue( codepoints0.indexOf( 0x2002 ) > -1 );
		Assert.isTrue( codepoints0.indexOf( 0x2003 ) > -1 );
		Assert.isTrue( codepoints0.indexOf( 0x2004 ) > -1 );
		Assert.isTrue( codepoints0.indexOf( 0x2005 ) > -1 );
		Assert.isTrue( codepoints0.indexOf( 0x2006 ) > -1 );
		Assert.isTrue( codepoints0.indexOf( 0x2007 ) > -1 );
		Assert.isTrue( codepoints0.indexOf( 0x2008 ) > -1 );
		Assert.isTrue( codepoints0.indexOf( 0x2009 ) > -1 );
		Assert.isTrue( codepoints0.indexOf( 0x200A ) > -1 );
		Assert.isTrue( codepoints0.indexOf( 0x202F ) > -1 );
		Assert.isTrue( codepoints0.indexOf( 0x205F ) > -1 );
		Assert.isTrue( codepoints0.indexOf( 0x3000 ) > -1 );
		
		var codepoints1 = Seri.getCategory( 'Po' );
		
		Assert.equals( 484, codepoints1.length );
		
		// Test a random selection of codepoints existence.
		Assert.isTrue( codepoints1.indexOf( 0x0021 ) > -1 );
		Assert.isTrue( codepoints1.indexOf( 0x1B5D ) > -1 );
		Assert.isTrue( codepoints1.indexOf( 0x2E0F ) > -1 );
		Assert.isTrue( codepoints1.indexOf( 0xA6F6 ) > -1 );
		Assert.isTrue( codepoints1.indexOf( 0xFF1B ) > -1 );
		Assert.isTrue( codepoints1.indexOf( 0x11049 ) > -1 );
		Assert.isTrue( codepoints1.indexOf( 0x1BC9F ) > -1 );
	}
	
}