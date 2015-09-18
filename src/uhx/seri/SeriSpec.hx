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
		
		Assert.isTrue( codepoints0.has( 0x0020 ) );
		Assert.isTrue( codepoints0.has( 0x00A0 ) );
		Assert.isTrue( codepoints0.has( 0x1680 ) );
		Assert.isTrue( codepoints0.has( 0x2000 ) );
		Assert.isTrue( codepoints0.has( 0x2001 ) );
		Assert.isTrue( codepoints0.has( 0x2002 ) );
		Assert.isTrue( codepoints0.has( 0x2003 ) );
		Assert.isTrue( codepoints0.has( 0x2004 ) );
		Assert.isTrue( codepoints0.has( 0x2005 ) );
		Assert.isTrue( codepoints0.has( 0x2006 ) );
		Assert.isTrue( codepoints0.has( 0x2007 ) );
		Assert.isTrue( codepoints0.has( 0x2008 ) );
		Assert.isTrue( codepoints0.has( 0x2009 ) );
		Assert.isTrue( codepoints0.has( 0x200A ) );
		Assert.isTrue( codepoints0.has( 0x202F ) );
		Assert.isTrue( codepoints0.has( 0x205F ) );
		Assert.isTrue( codepoints0.has( 0x3000 ) );
		
		var codepoints1 = Seri.getCategory( 'Po' );
		
		Assert.equals( 484, codepoints1.length );
		
		// Test a random selection of codepoints existence.
		Assert.isTrue( codepoints1.has( 0x0021 ) );
		Assert.isTrue( codepoints1.has( 0x1B5D ) );
		Assert.isTrue( codepoints1.has( 0x2E0F ) );
		Assert.isTrue( codepoints1.has( '\u2E0F'.code ) );
		Assert.isTrue( codepoints1.has( '⸏'.code ) );
		Assert.isTrue( codepoints1.has( 0xA6F6 ) );
		Assert.isTrue( codepoints1.has( 0xFF1B ) );
		Assert.isTrue( codepoints1.has( 0x11049 ) );
		Assert.isTrue( codepoints1.has( 0x1BC9F ) );
		
		var category0 = 'Nd';
		var codepoints2 = Seri.getCategory( category0 );
		
		var category1 = 'P';
		var codepoints3 = Seri.getCategory( category1 );
	}
	
	// @see http://en.wikipedia.org/wiki/Unicode_block
	public function testBlocks() {
		var blockpoints0 = Seri.getBlock( 'Basic Latin' );
		
		Assert.notNull( blockpoints0 );
		Assert.equals( 128, blockpoints0.length );
		Assert.isTrue( blockpoints0.has( 0x0000 ) );
		Assert.isTrue( blockpoints0.has( 0x007F ) );
		
		var blockpoints1 = Seri.getBlock( 'Cyrillic' );
		
		Assert.notNull( blockpoints1 );
		Assert.equals( 256, blockpoints1.length );
		Assert.isTrue( blockpoints1.has( 0x0400 ) );
		Assert.isTrue( blockpoints1.has( 0x04FF ) );
		
		var blockpoints2 = Seri.getBlock( 'Ethiopic' );
		
		Assert.notNull( blockpoints2 );
		Assert.equals( 384, blockpoints2.length );
		Assert.isTrue( blockpoints2.has( 0x1200 ) );
		Assert.isTrue( blockpoints2.has( 0x137F ) );
		
		var blockpoints3 = Seri.getBlock( 'Unified Canadian Aboriginal Syllabics' );
		
		Assert.notNull( blockpoints3 );
		Assert.equals( 640, blockpoints3.length );
		Assert.isTrue( blockpoints3.has( 0x1400 ) );
		Assert.isTrue( blockpoints3.has( 0x167F ) );
	}
	
	// @see http://en.wikipedia.org/wiki/Script_(Unicode)
	public function testScripts() {
		var scriptpoints0 = Seri.getScript( 'Syriac' );
		
		Assert.notNull( scriptpoints0 );
		Assert.equals( 77, scriptpoints0.length );
		Assert.isTrue( scriptpoints0.has( 0x0700 ) );
		Assert.isTrue( scriptpoints0.has( 0x070F ) );
		Assert.isTrue( scriptpoints0.has( 0x0710 ) );
		Assert.isTrue( scriptpoints0.has( 0x071F ) );
		Assert.isTrue( scriptpoints0.has( 0x0720 ) );
		Assert.isTrue( scriptpoints0.has( 0x072F ) );
		Assert.isTrue( scriptpoints0.has( 0x0730 ) );
		Assert.isTrue( scriptpoints0.has( 0x073F ) );
		Assert.isTrue( scriptpoints0.has( 0x0740 ) );
		Assert.isTrue( scriptpoints0.has( 0x074F ) );
		
		var expandedscripts = [for (p in scriptpoints0) p];
		Assert.equals( 77, expandedscripts.length );
		
		var scriptpoints1 = Seri.getScript( 'Warang_Citi' );
		
		Assert.notNull( scriptpoints1 );
		Assert.equals( 84, scriptpoints1.length );
		Assert.isTrue( scriptpoints1.has( 0x118A0 ) );
		Assert.isTrue( scriptpoints1.has( 0x118AF ) );
		Assert.isTrue( scriptpoints1.has( 0x118B0 ) );
		Assert.isTrue( scriptpoints1.has( 0x118BF ) );
		Assert.isTrue( scriptpoints1.has( 0x118C0 ) );
		Assert.isTrue( scriptpoints1.has( 0x118CF ) );
		Assert.isTrue( scriptpoints1.has( 0x118D0 ) );
		Assert.isTrue( scriptpoints1.has( 0x118DF ) );
		Assert.isTrue( scriptpoints1.has( 0x118E0 ) );
		Assert.isTrue( scriptpoints1.has( 0x118EF ) );
		
		var expandedscripts = [for (p in scriptpoints1) p];
		Assert.equals( 84, expandedscripts.length );
	}
	
}