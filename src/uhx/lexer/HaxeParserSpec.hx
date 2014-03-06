package uhx.lexer;

import utest.Assert;
import byte.ByteData;
import uhx.mo.TokenDef;
import uhx.lexer.HaxeLexer;
import uhx.lexer.HaxeParser;

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
		
		Assert.isTrue( Keyword(New).equals( i.next().token ) );
		Assert.isTrue( Space(1).equals( i.next().token ) );
		Assert.isTrue( Const(CIdent('EReg')).equals( i.next().token ) );
		Assert.isTrue( ParenthesesOpen.equals( i.next().token ) );
		Assert.isTrue( Const(CString('\t(};?</pre>)')).equals( i.next().token ) );
	}
	
	public function testEReg_html() {
		// Remember that `'` are replaced with `"` for String constants.
		var reg = "new EReg('\t(};?</pre>)', '');";
		var p = new HaxeParser();
		var t = p.toTokens( ByteData.ofString( reg ), 'ereg_test' );
		var i = t.iterator();
		
		for (x in 0...4) i.next();
		
		var h = p.printHTML( i.next() );
		
		Assert.isTrue( h.indexOf( '&#34;&#92;&#116;' ) > -1 );
	}
	
}