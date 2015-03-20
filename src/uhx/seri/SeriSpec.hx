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
	
	// @see http://en.wikipedia.org/wiki/Unicode#Character_General_Category
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
		Assert.isTrue( codepoints1.indexOf( '\u2E0F'.code ) > -1 );
		Assert.isTrue( codepoints1.indexOf( '⸏'.code ) > -1 );
		Assert.isTrue( codepoints1.indexOf( 0xA6F6 ) > -1 );
		Assert.isTrue( codepoints1.indexOf( 0xFF1B ) > -1 );
		Assert.isTrue( codepoints1.indexOf( 0x11049 ) > -1 );
		Assert.isTrue( codepoints1.indexOf( 0x1BC9F ) > -1 );
		
		var category0 = 'Nd';
		var codepoints2 = Seri.getCategory( category0 );
		
		var category1 = 'P';
		var codepoints3 = Seri.getCategory( category1 );
	}
	
	// @see http://en.wikipedia.org/wiki/Unicode_block
	public function testBlocks() {
		var blockpoints0 = Seri.getBlock( 'Basic Latin' );
		
		Assert.equals( 128, blockpoints0.length );
		Assert.isTrue( blockpoints0.indexOf( 0x0000 ) > -1 );
		Assert.isTrue( blockpoints0.indexOf( 0x007F ) > -1 );
		
		var blockpoints1 = Seri.getBlock( 'Cyrillic' );
		
		Assert.equals( 256, blockpoints1.length );
		Assert.isTrue( blockpoints1.indexOf( 0x0400 ) > -1 );
		Assert.isTrue( blockpoints1.indexOf( 0x04FF ) > -1 );
		
		var blockpoints2 = Seri.getBlock( 'Ethiopic' );
		
		Assert.equals( 384, blockpoints2.length );
		Assert.isTrue( blockpoints2.indexOf( 0x1200 ) > -1 );
		Assert.isTrue( blockpoints2.indexOf( 0x137F ) > -1 );
		
		var blockpoints3 = Seri.getBlock( 'Unified Canadian Aboriginal Syllabics' );
		
		Assert.equals( 640, blockpoints3.length );
		Assert.isTrue( blockpoints3.indexOf( 0x1400 ) > -1 );
		Assert.isTrue( blockpoints3.indexOf( 0x167F ) > -1 );
	}
	
	// @see http://en.wikipedia.org/wiki/Script_(Unicode)
	public function testScripts() {
		var scriptpoints0 = Seri.getScript( 'Syriac' );
		
		Assert.equals( 77, scriptpoints0.length );
		Assert.isTrue( scriptpoints0.indexOf( 0x0700 ) > -1 );
		Assert.isTrue( scriptpoints0.indexOf( 0x070F ) > -1 );
		Assert.isTrue( scriptpoints0.indexOf( 0x0710 ) > -1 );
		Assert.isTrue( scriptpoints0.indexOf( 0x071F ) > -1 );
		Assert.isTrue( scriptpoints0.indexOf( 0x0720 ) > -1 );
		Assert.isTrue( scriptpoints0.indexOf( 0x072F ) > -1 );
		Assert.isTrue( scriptpoints0.indexOf( 0x0730 ) > -1 );
		Assert.isTrue( scriptpoints0.indexOf( 0x073F ) > -1 );
		Assert.isTrue( scriptpoints0.indexOf( 0x0740 ) > -1 );
		Assert.isTrue( scriptpoints0.indexOf( 0x074F ) > -1 );
		
		var scriptpoints1 = Seri.getScript( 'Warang_Citi' );
		
		Assert.equals( 84, scriptpoints1.length );
		Assert.isTrue( scriptpoints1.indexOf( 0x118A0 ) > -1 );
		Assert.isTrue( scriptpoints1.indexOf( 0x118AF ) > -1 );
		Assert.isTrue( scriptpoints1.indexOf( 0x118B0 ) > -1 );
		Assert.isTrue( scriptpoints1.indexOf( 0x118BF ) > -1 );
		Assert.isTrue( scriptpoints1.indexOf( 0x118C0 ) > -1 );
		Assert.isTrue( scriptpoints1.indexOf( 0x118CF ) > -1 );
		Assert.isTrue( scriptpoints1.indexOf( 0x118D0 ) > -1 );
		Assert.isTrue( scriptpoints1.indexOf( 0x118DF ) > -1 );
		Assert.isTrue( scriptpoints1.indexOf( 0x118E0 ) > -1 );
		Assert.isTrue( scriptpoints1.indexOf( 0x118EF ) > -1 );
	}
	
}