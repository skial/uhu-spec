package uhx.mo;

import utest.Assert;
import byte.ByteData;
import uhx.mo.TokenDef;
import uhx.lexer.HaxeLexer;
import uhx.lexer.HaxeParser;

/**
 * ...
 * @author Skial Bainn
 */
class MoSpec {

	public function new() {
		
	}
	
	public function testToCSS() {
		var reg = "new EReg('\t(};?</pre>)', '');";
		var p = new HaxeParser();
		var t = p.toTokens( ByteData.ofString( reg ), 'ereg_test' );
		var i = t.iterator();
		
		Assert.equals( 'keyword new', Mo.toCSS( i.next().token ) );
		Assert.equals( 'space', Mo.toCSS( i.next().token ) );
		Assert.equals( 'const ident', Mo.toCSS( i.next().token ) );
		Assert.equals( 'parentheses open', Mo.toCSS( i.next().token ) );
		Assert.equals( 'const string', Mo.toCSS( i.next().token ) );
	}
	
}