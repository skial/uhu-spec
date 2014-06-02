package uhx.lexer;

import haxe.io.Eof;
import utest.Assert;
import uhx.mo.Token;
import byte.ByteData;
import uhx.lexer.CssLexer;

/**
 * ...
 * @author Skial Bainn
 */
class CssParserSpec {
	
	public var lexer:CssLexer;
	public var parser:CssParser;

	public function new() {
		parser = new CssParser();
	}
	
	public function parse(value:String):Array<Token<CssKeywords>> {
		var tokens = [];
		
		lexer = new CssLexer( ByteData.ofString( value ), 'css-lexer-spec' );
		
		try while (true) {
			tokens.push( lexer.token( CssLexer.root ) );
		} catch (e:Eof) { } catch (e:Dynamic) {
			trace( e );
		}
		
		return tokens;
	}
	
	public function testTypeDeclaration() {
		var t = parse( 'div { display: block; }' );
		//untyped console.log( t );
		Assert.equals( 1, t.length );
		
		switch (t[0].token) {
			case Keyword(RuleSet(s, t)):
				Assert.isTrue( s.match( CssSelectors.Type( 'div' ) ) );
				Assert.equals( 1, t.length );
				
				switch (t[0].token) {
					case Keyword(Declaration(n, v)):
						Assert.equals( 'display', n );
						Assert.equals( 'block', v );
						
					case _:
						
				}
				
			case _:
				
		}
	}
	
	public function testTypeDeclaration_Newline() {
		var t = parse( 'div,\nimg { display: block; }' );
		//untyped console.log( t );
		Assert.equals( 1, t.length );
		
		switch (t[0].token) {
			case Keyword(RuleSet(s, t)):
				Assert.isTrue(
					s.match( Group( [Type( 'div' ), Type( 'img' )] ) )
				);
				
				switch (t[0].token) {
					case Keyword(Declaration(n, v)):
						Assert.equals( 'display', n );
						Assert.equals( 'block', v );
						
					case _:
						
				}
				
			case _:
				
		}
	}
	
	public function testTypeDeclaration_NewlineCarriageTab() {
		var t = parse( 'div,\r\nimg\t{ display: block; }' );
		//untyped console.log( t );
		Assert.equals( 1, t.length );
		
		switch (t[0].token) {
			case Keyword(RuleSet(s, t)):
				Assert.isTrue(
					s.match( Group( [Type( 'div' ), Type( 'img' )] ) )
				);
				
				switch (t[0].token) {
					case Keyword(Declaration(n, v)):
						Assert.equals( 'display', n );
						Assert.equals( 'block', v );
						
					case _:
						
				}
				
			case _:
				
		}
	}
	
	public function testClassDeclaration() {
		var t = parse( '.class { display: block; }' );
		//untyped console.log( t );
		Assert.equals( 1, t.length );
		
		switch( t[0].token ) {
			case Keyword(RuleSet(s, t)):
				Assert.isTrue(
					s.match( CssSelectors.Class( ['class'] ) )
				);
				Assert.equals( 1, t.length );
				
				switch (t[0].token) {
					case Keyword(Declaration(n, v)):
						Assert.equals( 'display', n );
						Assert.equals( 'block', v );
						
					case _:
						
				}
				
			case _:
				
		}
	}
	
	public function testClassDeclaration_Newline() {
		var t = parse( '.class1\n.class2 { display: block; }' );
		//untyped console.log( t );
		Assert.equals( 1, t.length );
		
		switch( t[0].token ) {
			case Keyword(RuleSet(s, t)):
				Assert.isTrue(
					s.match( Group( [CssSelectors.Class( ['class1'] ), CssSelectors.Class( ['class2'] )] ) )
				);
				Assert.equals( 1, t.length );
				
				switch (t[0].token) {
					case Keyword(Declaration(n, v)):
						Assert.equals( 'display', n );
						Assert.equals( 'block', v );
						
					case _:
						
				}
				
			case _:
				
		}
	}
	
	public function testClassDeclaration_NewlineCarriageTab() {
		var t = parse( '.class1\r\n\t.class2 { display: block; }' );
		//untyped console.log( t );
		Assert.equals( 1, t.length );
		
		switch( t[0].token ) {
			case Keyword(RuleSet(s, t)):
				Assert.isTrue(
					s.match( Group( [CssSelectors.Class( ['class1'] ), CssSelectors.Class( ['class2'] )] ) )
				);
				Assert.equals( 1, t.length );
				
				switch (t[0].token) {
					case Keyword(Declaration(n, v)):
						Assert.equals( 'display', n );
						Assert.equals( 'block', v );
						
					case _:
						
				}
				
			case _:
				
		}
	}
	
	public function testComment() {
		var t = parse( '/* div http://url.org/index.php?f=1&g=11#blob !@?& */' );
		//untyped console.log( t );
		Assert.equals( 1, t.length );
		
		switch (t[0].token) {
			case Comment( value ):
				Assert.equals( 'div http://url.org/index.php?f=1&g=11#blob !@?&', value );
				
			case _:
				
		}
	}
	
	public function testComment_Multiline() {
		var t = parse( '/*\r\nrgb(241,89,34) - http://www.colorhexa.com/f15922\r\ncomplementary colour \r\nrgb(34,186,241) - http://www.colorhexa.com/22baf1\r\n*/' );
		//untyped console.log( t );
		Assert.equals( 1, t.length );
		
		switch (t[0].token) {
			case Comment( value ):
				Assert.equals( 'rgb(241,89,34) - http://www.colorhexa.com/f15922\r\ncomplementary colour \r\nrgb(34,186,241) - http://www.colorhexa.com/22baf1', value );
				
			case _:
				
		}
	}
	
	public function testComment_MultiAsterisk() {
		var t = parse( '/**\r\n* something\r\n\t* else\r\n * again\r\n*/' );
		//untyped console.log( t );
		Assert.equals( 1, t.length );
		
		switch (t[0].token) {
			case Comment( value ):
				Assert.equals( '*\r\n* something\r\n\t* else\r\n * again', value );
				
			case _:
				
		}
	}
	
	public function testCommentTypeClass() {
		var t = parse( '/* comment1 */\r\n\r\nimg,\r\n.class {\r\n\tdisplay: block;\r\n}/*comment2*/' );
		////untyped console.log( t );
		Assert.equals( 3, t.length );
		Assert.isTrue( t[0].token.match( Comment( 'comment1' ) ) );
		Assert.isTrue( t[2].token.match( Comment( 'comment2' ) ) );
		
		switch (t[1].token) {
			case Keyword(RuleSet(s, t)):
				Assert.isTrue( s.match( Group( [CssSelectors.Type( 'img' ), CssSelectors.Class( ['class'] )] ) ) );
				Assert.equals( 1, t.length );
				
				switch (t[0].token) {
					case Keyword(Declaration(n, v)):
						Assert.equals( 'display', n );
						Assert.equals( 'block', v );
						
					case _:
						
				}
				
			case _:
				
		}
		
		var html = [for (i in t) parser.printHTML( i )].join('\r\n');
		var string = [for (i in t) parser.printString( i )].join('\r\n');
		
		Assert.equals( '<span class="comment"><wbr>&shy;/*comment1*/</span>\r\n<span class="keyword ruleset">img,\r\n.class {\r\n\t<span class="keyword declaration">display: block;</span>\r\n}</span>\r\n<span class="comment"><wbr>&shy;/*comment2*/</span>', html );
		Assert.equals( '/*comment1*/\r\nimg,\r\n.class {\r\n\tdisplay: block;\r\n}\r\n/*comment2*/', string );
	}
	
	public function testChild() {
		var t = parse( 'a > b { display: block; }' );
		//untyped console.log( t );
		Assert.equals( 1, t.length );
		
		switch (t[0].token) {
			case Keyword(RuleSet(s, t)):
				Assert.isTrue( s.match( Combinator( Type( 'a' ), Type( 'b' ), Child ) ) );
				Assert.equals( 1, t.length );
				
				switch (t[0].token) {
					case Keyword(Declaration(n, v)):
						Assert.equals( 'display', n );
						Assert.equals( 'block', v );
						
					case _:
						
				}
				
			case _:
				
		}
	}
	
	public function testSingleCharacters() {
		var t = parse( 'a { b: 1; }' );
		//untyped console.log( t );
		Assert.equals( 1, t.length );
	}
	
	public function testDecimalValue() {
		var t = parse( 'a { b: 1.1; }' );
		//untyped console.log( t );
		Assert.equals( 1, t.length );
		
		switch (t[0].token) {
			case Keyword(RuleSet(s, t)):
				Assert.isTrue( s.match( Type( 'a' ) ) );
				Assert.equals( 1, t.length );
				
				switch (t[0].token) {
					case Keyword(Declaration(n, v)):
						Assert.equals( 'b', n );
						Assert.equals( '1.1', v );
						
					case _:
						
				}
				
			case _:
				
		}
	}
	
	public function testStringValue() {
		var t = parse( 'a { b: "/unicode0123456789!?"£$"; }' );
		//untyped console.log( t );
		Assert.equals( 1, t.length );
		
		switch (t[0].token) {
			case Keyword(RuleSet(s, t)):
				Assert.isTrue( s.match( Type( 'a' ) ) );
				Assert.equals( 1, t.length );
				
				switch (t[0].token) {
					case Keyword(Declaration(n, v)):
						Assert.equals( 'b', n );
						Assert.equals( '"/unicode0123456789!?"£$"', v );
						
					case _:
						
				}
				
			case _:
				
		}
	}
	
	public function testMultiValue() {
		var t = parse( 'a { b: 1, 2, 3; }' );
		//untyped console.log( t );
		Assert.equals( 1, t.length );
		
		switch (t[0].token) {
			case Keyword(RuleSet(s, t)):
				Assert.isTrue( s.match( Type( 'a' ) ) );
				Assert.equals( 1, t.length );
				
				switch (t[0].token) {
					case Keyword(Declaration(n, v)):
						Assert.equals( 'b', n );
						Assert.equals( '1, 2, 3', v );
						
					case _:
						
				}
				
			case _:
				
		}
	}
	
	public function testAttributeSelector() {
		var t = parse( 'a[b="/"] { c: d; }' );
		//untyped console.log( t );
		
		Assert.equals( 1, t.length );
		
		switch (t[0].token) {
			case Keyword(RuleSet(s, t)):
				Assert.isTrue( s.match( Group( [ Type( 'a' ), Attribute( 'b', Exact, '"/"' ) ] ) ) );
				Assert.equals( 1, t.length );
				
				switch (t[0].token) {
					case Keyword(Declaration(n, v)):
						Assert.equals( 'c', n );
						Assert.equals( 'd', v );
						
					case _:
						
				}
				
			case _:
				
		}
		
		var html = parser.printHTML( t[0] );
		var string = parser.printString( t[0] );
		
		Assert.equals( '<span class="keyword ruleset">a[b="/"] {\r\n\t<span class="keyword declaration">c: d;</span>\r\n}</span>', html );
		Assert.equals( 'a[b="/"] {\r\n\tc: d;\r\n}', string );
	}
	
}