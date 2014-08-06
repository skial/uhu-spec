package uhx.lexer;

import haxe.io.Eof;
import utest.Assert;
import uhx.mo.Token;
import byte.ByteData;
import uhx.lexer.CssLexer;

using StringTools;

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
			//untyped console.log( lexer.input.readString( lexer.curPos().pmin, lexer.curPos().pmax ) );
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
		
		Assert.equals( 'div {\r\n\tdisplay: block;\r\n}', parser.printString( t[0] ) );
		Assert.equals( 'div{display:block;}', parser.printString( t[0], true ) );
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
		
		Assert.equals( 'div,\r\nimg {\r\n\tdisplay: block;\r\n}', parser.printString( t[0] ) );
		Assert.equals( 'div,img{display:block;}', parser.printString( t[0], true ) );
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
		
		Assert.equals( 'div,\r\nimg {\r\n\tdisplay: block;\r\n}', parser.printString( t[0] ) );
		Assert.equals( 'div,img{display:block;}', parser.printString( t[0], true ) );
	}
	
	public function testIdDeclaration() {
		var t = parse( '#a { b: c; }' );
		//untyped console.log ( t );
		Assert.equals( 1, t.length );
		
		switch ( t[0].token ) {
			case Keyword(RuleSet(s, t)):
				Assert.isTrue( s.match( ID( 'a' ) ) );
				Assert.equals( 1, t.length );
				
				switch (t[0].token) {
					case Keyword(Declaration(n, v)):
						Assert.equals( 'b', n );
						Assert.equals( 'c', v );
						
					case _:
						
				}
				
			case _:
				
		}
	}
	
	public function testIdDeclaration_multi() {
		var t = parse( '#a, #b, #c { d: e; }' );
		//untyped console.log( t );
		Assert.equals( 1, t.length );
		
		switch ( t[0].token ) {
			case Keyword(RuleSet(s, t)):
				Assert.isTrue( s.match( Group( [ID('a'), ID('b'), ID('c')] ) ) );
				Assert.equals( 1, t.length );
				
				switch (t[0].token) {
					case Keyword(Declaration(n, v)):
						Assert.equals( 'd', n );
						Assert.equals( 'e', v );
						
					case _:
						
				}
				
			case _:
				
		}
	}
	
	public function testIdDeclaration_child() {
		var t = parse( '#a > #b { c: d; }' );
		//untyped console.log( t );
		Assert.equals( 1, t.length );
		
		switch (t[0].token) {
			case Keyword(RuleSet(s, t)):
				Assert.isTrue( s.match( Combinator( ID( 'a' ), ID( 'b' ), Child ) ) );
				Assert.equals( 1, t.length );
				
				switch (t[0].token) {
					case Keyword(Declaration(n, v)):
						Assert.equals( 'c', n );
						Assert.equals( 'd', v );
						
					case _:
						
				}
				
			case _:
				
		}
	}
	
	public function testClassDeclaration() {
		var t = parse( '.class { display: block; }' );
		//untyped console.log( t );
		Assert.equals( 1, t.length );
		
		switch ( t[0].token ) {
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
		
		Assert.equals( '.class {\r\n\tdisplay: block;\r\n}', parser.printString( t[0] ) );
		Assert.equals( '.class{display:block;}', parser.printString( t[0], true ) );
	}
	
	public function testClassDeclaration_Newline() {
		var t = parse( '.class1\n.class2 { display: block; }' );
		//untyped console.log( t );
		Assert.equals( 1, t.length );
		
		switch( t[0].token ) {
			case Keyword(RuleSet(s, t)):
				Assert.isTrue(
					//s.match( Group( [CssSelectors.Class( ['class1'] ), CssSelectors.Class( ['class2'] )] ) )
					s.match( CssSelectors.Class( ['class1', 'class2'] ) )
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
		
		Assert.equals( '.class1.class2 {\r\n\tdisplay: block;\r\n}', parser.printString( t[0] ) );
		Assert.equals( '.class1.class2{display:block;}', parser.printString( t[0], true ) );
	}
	
	public function testClassDeclaration_NewlineCarriageTab() {
		var t = parse( '.class1\r\n\t.class2 { display: block; }' );
		//untyped console.log( t );
		Assert.equals( 1, t.length );
		
		switch( t[0].token ) {
			case Keyword(RuleSet(s, t)):
				Assert.isTrue(
					//s.match( Group( [CssSelectors.Class( ['class1'] ), CssSelectors.Class( ['class2'] )] ) )
					s.match( CssSelectors.Class( ['class1', 'class2'] ) )
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
		
		//Assert.equals( '<span class="comment"><wbr>&shy;/*comment1*/</span>\r\n<span class="keyword ruleset">img,\r\n.class {\r\n\t<span class="keyword declaration">display: block;</span>\r\n}</span>\r\n<span class="comment"><wbr>&shy;/*comment2*/</span>', html );
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
		
		//Assert.equals( '<span class="keyword ruleset">a[b="/"] {\r\n\t<span class="keyword declaration">c: d;</span>\r\n}</span>', html );
		//Assert.equals( 'a[b="/"] {\r\n\tc: d;\r\n}', string );
	}
	
	public function testDeclarationComment() {
		var t = parse( 'a { /*c1*/b: 1;/*c:2;*/ }' );
		//untyped console.log( t );
		
		Assert.equals( 1, t.length );
		
		switch (t[0].token) {
			case Keyword(RuleSet(s, t)):
				Assert.equals( 3, t.length );
				
				for (i in 0...t.length) switch (t[0].token) {
					case Comment(v) if (i == 0 || i == 2):
						Assert.contains( v, ['c1', 'c:2;']);
						
					case Keyword(Declaration(n, v)) if (i == 1):
						Assert.equals( 'b', n );
						Assert.equals( '1', v );
						
					case _:
						
				}
				
			case _:
				
		}
	}
	
	public function testUniversalSelector() {
		var t = parse( '* { a:b; }' );
		//untyped console.log( t );
		
		Assert.equals( 1, t.length );
		
		switch (t[0].token) {
			case Keyword(RuleSet(s, t)):
				Assert.isTrue( s.match( Universal ) );
				Assert.equals( 1, t.length );
				
			case _:
				
		}
	}
	
	public function testNotPseduo() {
		var t = parse( '*:not([type]) { a:b; }' );
		
		//untyped console.log( t );
		
		Assert.equals( 1, t.length );
		
		switch (t[0].token) {
			case Keyword(RuleSet(s, t)):
				Assert.isTrue( s.match( Group( [Universal, Pseudo( 'not', '[type]' )] ) ) );
				Assert.equals( 1, t.length );
				
			case _:
				
		}
	}
	
	public function testHaxeIoCss() {
		var t = parser.toTokens( ByteData.ofString( haxe.Resource.getString('haxe.io.css') ), 'haxe.io.css' );
		var comments = t.filter( function (t) return t.token.match( Comment(_) ) );
		var media = t.filter( function(t) return t.token.match( Keyword( AtRule(_, _, _) ) ) );
		var rules = t.filter( function(t) return t.token.match( Keyword( RuleSet(_, _) ) ) );
		var remainder = t.filter( function(t) return switch (t.token) {
			case Comment(_), Keyword( AtRule(_, _, _) ), Keyword( RuleSet(_, _) ): false;
			case _: true;
		} );
		
		//untyped console.log( remainder );
		
		Assert.equals( 0, remainder.length );
		Assert.equals( 10, comments.length );
		Assert.equals( 5, media.length );
		Assert.equals( 48, rules.length );
		Assert.equals( t.length, comments.length + media.length + rules.length );
	}
	
	public function testNormalizeCss() {
		var t = parser.toTokens( ByteData.ofString( haxe.Resource.getString('normalize.css') ), 'normalize.css' );
		var comments = t.filter( function (t) return t.token.match( Comment(_) ) );
		var media = t.filter( function(t) return t.token.match( Keyword( AtRule(_, _, _) ) ) );
		var rules = t.filter( function(t) return t.token.match( Keyword( RuleSet(_, _) ) ) );
		var remainder = t.filter( function(t) return switch (t.token) {
			case Comment(_), Keyword( AtRule(_, _, _) ), Keyword( RuleSet(_, _) ): false;
			case _: true;
		} );
		
		//untyped console.log( t );
		//untyped console.log( remainder );
		
		Assert.equals( 0, remainder.length );
		Assert.equals( 46, comments.length );
		Assert.equals( 0, media.length );
		Assert.equals( 40, rules.length );
		Assert.equals( t.length, comments.length + media.length + rules.length );
	}
	
	public function testCssVariables() {
		var t = parse( '.class { --my-colour: red;\r\ncolor: var(--my-colour); }' );
		
		//untyped console.log( t );
		
		switch (t[0].token) {
			case Keyword(RuleSet(s, t)):
				Assert.isTrue( s.match( CssSelectors.Class( ['class'] ) ) );
				Assert.equals( 2, t.length );
				Assert.isTrue( t[0].token.match( Keyword( Declaration( '--my-colour', 'red' ) ) ) );
				Assert.isTrue( t[1].token.match( Keyword( Declaration( 'color', 'var(--my-colour)' ) ) ) );
				
			case _:
				
		}
	}
	
	public function testCommentInSelector() {
		var t = parse( 'a, /* 1 */ b { c:d; }' );
		
		//untyped console.log( t );
		
		Assert.equals( 1, t.length );
		
		switch (t[0].token) {
			case Keyword( RuleSet(s, t) ):
				Assert.isTrue( s.match( Group( [Type('a'), Type('b')] ) ) );
				
			case _:
				
		}
	}
	
	public function testCalc() {
		var t = parse( 'a { height: calc(100px - 2em); }' );
		
		//untyped console.log( t );
		
		Assert.equals( 1, t.length );
		
		switch (t[0].token) {
			case Keyword( RuleSet(s, t) ):
				Assert.isTrue( s.match( Type('a') ) );
				Assert.isTrue( t[0].token.match( Keyword( Declaration('height', 'calc(100px - 2em)') ) ) );
				
			case _:
				
		}
	}
	
	public function testAtRule() {
		var t = parse( '@media all and (min-width: 1156px) { a { b:c; } }' );
		
		//untyped console.log( t );
		
		switch (t[0].token) {
			case Keyword( AtRule(n, q, t) ):
				Assert.equals( 'media', n );
				Assert.equals( 
					'' + [Feature('all'), Feature('and'), CssMedia.Expr('min-width', '1156px')],
					'' + q
				);
				Assert.equals( 1, t.length );
				
			case _:
				
		}
		
		Assert.equals( '@media all and (min-width: 1156px) {\r\n\ta {\r\n\t\tb: c;\r\n\t}\r\n}', parser.printString( t[0] ) );
		Assert.equals( '@media all and (min-width:1156px) {a{b:c;}}', parser.printString( t[0], true ) );
	}
	
	public function testAtRule_MultiExpr() {
		var t = parse( '@media all and (max-width: 699px) and (min-width: 520px), (min-width: 1151px) {a {b:c;} }' );
		
		//untyped console.log( t );
		
		switch (t[0].token) {
			case Keyword( AtRule(n, q, t) ):
				Assert.equals( 'media', n );
				Assert.equals( 
					'' + [CssMedia.Group([ 
						[Feature('all'), Feature('and'), CssMedia.Expr('max-width', '699px'),
						Feature('and'), CssMedia.Expr('min-width', '520px')],
						[CssMedia.Expr('min-width', '1151px')]
					])],
					'' + q
				);
				Assert.equals( 1, t.length );
				
			case _:
				
		}
		
		Assert.equals( '@media all and (max-width: 699px) and (min-width: 520px), (min-width: 1151px) {\r\n\ta {\r\n\t\tb: c;\r\n\t}\r\n}', parser.printString( t[0] ) );
		Assert.equals( '@media all and (max-width:699px) and (min-width:520px),(min-width:1151px) {a{b:c;}}', parser.printString( t[0], true ) );
	}
	
	public function testRuleSet_Multi() {
		var t = parse( 'a {b:c;} d {e:f;}' );
		
		//untyped console.log( t );
		
		Assert.equals( 2, t.length );
		
		for (i in 0...t.length) switch (t[i].token) {
			case Keyword(RuleSet(s, t)) if (i == 0):
				Assert.isTrue( s.match( Type('a') ) );
				Assert.equals( 1, t.length );
				
			case Keyword(RuleSet(s, t)) if (i == 1):
				Assert.isTrue( s.match( Type('d') ) );
				Assert.equals( 1, t.length );
				
			case _:
				
		}
		
		Assert.equals( 'a {\r\n\tb: c;\r\n}\r\nd {\r\n\te: f;\r\n}', [for (i in t) parser.printString( i )].join('\r\n') );
		Assert.equals( 'a{b:c;}d{e:f;}', [for (i in t) parser.printString( i, true )].join('') );
	}
	
}