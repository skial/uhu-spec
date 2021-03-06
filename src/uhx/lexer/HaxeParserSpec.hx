package uhx.lexer;

import utest.Assert;
import uhx.mo.Token;
import byte.ByteData;
import uhx.lexer.Haxe.HaxeKeywords;
import uhx.lexer.Haxe as HaxeLexer;
import uhx.parser.Haxe as HaxeParser;

/**
 * ...
 * @author Skial Bainn
 */
class HaxeParserSpec {

	public function new() {
		
	}
	
	public function testEReg_tokens() {
		var reg = "new EReg('\t(};?</pre>)', '');";
		var p = new HaxeParser();
		var t = p.toTokens( ByteData.ofString( reg ), 'ereg_test' );
		var i = t.iterator();
		
		Assert.isTrue( Keyword(New).equals( i.next() ) );
		Assert.isTrue( Space(1).equals( i.next() ) );
		Assert.isTrue( Const(CIdent('EReg')).equals( i.next() ) );
		Assert.isTrue( ParenthesesOpen.equals( i.next() ) );
		Assert.isTrue( Const(CString('\t(};?</pre>)')).equals( i.next() ) );
	}
	
	public function testEReg_html() {
		// Remember that `'` are replaced with `"` for String constants.
		var reg = "new EReg('\t(};?</pre>)', '');";
		var p = new HaxeParser();
		var t = p.toTokens( ByteData.ofString( reg ), 'ereg_test' );
		var i = t.iterator();
		trace( i );
		for (x in 0...4) i.next();
		
		var h = p.printHTML( i.next() );
		trace( h );
		Assert.isTrue( h.indexOf( '&#34;&#92;&#116;' ) > -1 );
	}
	
}