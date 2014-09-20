package uhx.lexer;

import haxe.io.Eof;
import hxparse.UnexpectedChar;
import uhx.mo.Token;
import utest.Assert;
import byte.ByteData;
import uhx.lexer.HtmlLexer;

using Lambda;

/**
 * ...
 * @author Skial Bainn
 */
class HtmlLexerSpec {
	
	var paragraphs:String;

	public function new() {
		paragraphs = haxe.Resource.getString('be_paragraph.html');
	}
	
	private function parse(html:String):Array<Token<HtmlKeywords>> {
		HtmlLexer.openTags = [];
		var lexer = new HtmlLexer( ByteData.ofString( html ), 'html' );
		var tokens = [];
		
		//untyped console.log( html );
		
		try while ( true ) {
			tokens.push( lexer.token( HtmlLexer.root ) );
		} catch (_e:Eof) { } catch (_e:Dynamic) {
			//untyped console.log(_e);
		}
		
		//untyped console.log( tokens );
		
		return tokens;
	}
	
	private function whitespace(t:Token<HtmlKeywords>) {
		return switch (t.token) {
			case Const(_): false;
			case _: true;
		}
	}
	
	public function testInstruction() {
		var t = parse( '<!doctype html>' );
		
		//untyped console.log( t );
		
		Assert.equals( 1, t.length );
		
		switch (t[0].token) {
			case Keyword( Instruction('doctype', attributes) ):
				Assert.isTrue( attributes.indexOf( 'html' ) > -1 );
				
			case _:
				
		}
	}
	
	public function testInstruction_IE() {
		var t = parse( '<!--[if IE]>' );
		
		//untyped console.log( t );
		
		Assert.equals( 1, t.length );
		
		switch (t[0].token) {
			case Keyword( Instruction('--', attributes) ):
				Assert.isTrue( attributes.indexOf( '[if IE]' ) > -1 );
				
			case _:
				
		}
	}
	
	public function testInstructions_unnamed() {
		var t = parse( '<![abc 123]>' );
		
		//untyped console.log( t );
		
		Assert.equals( 1, t.length );
		
		switch (t[0].token) {
			case Keyword( Instruction( '', attributes ) ):
				Assert.isTrue( attributes.indexOf( '[abc 123]' ) > -1 );
				
			case _:
				Assert.fail();
		}
	}
	
	public function testInstructions_newline_carriage_tab() {
		var t = parse( '<!\n\r\t\n>' );
		
		//untyped console.log( t );
		
		Assert.equals( 1, t.length );
	}
	
	public function testInstructions_commented_css() {
		var t = parse( '<!--\n\r\tBODY { font-family: arial,verdana,helvetica,sans-serif; font-size: 13px; background-color: #FFFFFF; color: #000000; margin-top: 0px; } -->' );
		
		//untyped console.log( t );
		
		Assert.equals( 1, t.length );
		
		switch (t[0].token) {
			case Keyword(Instruction(_, attr)):
				Assert.isTrue( attr.indexOf( 'BODY' ) > -1 );
				Assert.isTrue( attr.indexOf( 'font-family:' ) > -1 );
				Assert.isTrue( attr.indexOf( 'arial,verdana,helvetica,sans-serif;' ) > -1 );
				Assert.isTrue( attr.indexOf( 'font-size:' ) > -1 );
				Assert.isTrue( attr.indexOf( '13px;' ) > -1 );
				Assert.isTrue( attr.indexOf( 'background-color:' ) > -1 );
				Assert.isTrue( attr.indexOf( '#FFFFFF;' ) > -1 );
				Assert.isTrue( attr.indexOf( 'color:' ) > -1 );
				Assert.isTrue( attr.indexOf( '#000000;' ) > -1 );
				Assert.isTrue( attr.indexOf( 'margin-top:' ) > -1 );
				Assert.isTrue( attr.indexOf( '0px;' ) > -1 );
				Assert.isTrue( attr.indexOf( '{' ) > -1 );
				Assert.isTrue( attr.indexOf( '}' ) > -1 );
				Assert.isTrue( attr.indexOf( '--' ) > -1 );
				
			case _:
				
		}
	}
	
	public function testInstructions_commented_html() {
		var t = parse( '<a/><!-- <commented/><html>with some text</html>--><b/>' );
		var f = t.filter( function(a) return a.token.match( Keyword(Instruction(_, _)) ) );
		
		//untyped console.log( t );
		
		Assert.equals( 3, t.length );
		Assert.equals( 1, f.length );
		
		switch (f[0].token) {
			case Keyword(Instruction('--', attrs)):
				Assert.equals( '<commented/>', attrs[0] );
				Assert.equals( '<html>', attrs[1] );
				Assert.equals( 'with', attrs[2] );
				Assert.equals( 'some', attrs[3] );
				Assert.equals( 'text', attrs[4] );
				Assert.equals( '</html>', attrs[5] );
				Assert.equals( '--', attrs[6] );
				
			case _:
				
		}
	}
	
	public function testInstructions_comment_breaking() {
		// This does not parse as you would expect :/.
		var t = parse( '<!-- <a> >> -->' );
		
		//untyped console.log( t );
		
		Assert.equals( 4, t.length );
		Assert.isTrue( t[0].token.match( Keyword(Instruction('--', ['<a>'])) ) );
		Assert.isTrue( t[1].token.match( GreaterThan ) );
		Assert.isTrue( t[2].token.match( Const(CString(' --')) ) );
		Assert.isTrue( t[3].token.match( GreaterThan ) );
	}
	
	public function testSelfClosingTag() {
		var t = parse( '<link a="1" b="2" />' );
		
		//untyped console.log( t );
		
		Assert.equals( 1, t.length );
		
		switch (t[0].token) {
			case Keyword(Tag('link', m, [0], _, true, false)):
				Assert.equals( 2, Lambda.count(m) );
				
			case _:
				
				
		}
	}
	
	public function testParagraphs() {
		var t = parse( paragraphs ).filter( whitespace );
		
		//untyped console.log( t );
		
		Assert.equals( 2, t.length );
		
		switch (t[1].token) {
			case Keyword(Tag('p', _, [1], t, false, true)):
				t = t.filter( whitespace );
				
				Assert.equals( 7, t.length );
				Assert.isTrue( t[0].token.match( Keyword(Tag('em', _, [1, 4], _, false, true)) ));
				Assert.isTrue( t[1].token.match( Keyword(Tag('em', _, [1, 4], _, false, true)) ));
				Assert.isTrue( t[2].token.match( Keyword(Tag('code', _, [1, 4], _, false, true)) ));
				Assert.isTrue( t[3].token.match( Keyword(Tag('code', _, [1, 4], _, false, true)) ));
				Assert.isTrue( t[4].token.match( Keyword(Tag('code', _, [1, 4], _, false, true)) ));
				Assert.isTrue( t[5].token.match( Keyword(Tag('code', _, [1, 4], _, false, true)) ));
				Assert.isTrue( t[6].token.match( Keyword(Tag('code', _, [1, 4], _, false, true)) ));
				
			case _:
		}
	}
	
	public function testTags_unending() {
		var t = parse( '<a><b><c><d><e><f>' );
		
		//untyped console.log( t );
		
		Assert.equals( 1, t.length );
		Assert.isTrue( t[0].token.match( Keyword( Ref( _ ) ) ) );
	}
	
	public function testTags_mismatch() {
		var t = parse( '<a><a></a></b></c></a>' );
		
		Assert.equals( 1, t.length );
		
		switch (t[0].token) {
			case Keyword( Tag( 'a', _, [1,4,6], t, true, true ) ):
				Assert.equals( 3, t.length );
				Assert.isTrue( t[0].token.match(
					Keyword( Tag( 'a', _, [1,4,6], _, true, true ) )
				) );
				Assert.isTrue( t[1].token.match( Keyword( End( 'b' ) ) ) );
				Assert.isTrue( t[2].token.match( Keyword( End( 'c' ) ) ) );
				
			case _:
				
		}
	}
	
	public function testTags_unfinished() {
		var t = parse( '<a><b><c' );
		
		Assert.equals( 1, t.length );
		
		while (true) switch (t[0].token) {
			case Keyword( Tag( name, _, c, tokens, false, false ) ):
				t = tokens;
				
				if (name == 'b') {
					Assert.equals( 2, tokens.length );
					Assert.isTrue( tokens[0].token.match(
						Const( CString('<') )
					) );
					Assert.isTrue( tokens[1].token.match(
						Const( CString('c') )
					) );
					
					break;
					
				}
				
			case _:
				break;
				
		}
	}
	
	public function testTags_misnested() {
		var t = parse( '<b><i></b></i>' );
		
		Assert.equals( 1, t.length );
		
		//untyped console.log( t );
		
		switch (t[0].token) {
			case Keyword( Tag( name, _, c, tokens, false, true ) ):
				Assert.equals( 'b', name );
				Assert.equals( 1, tokens.length );
				
				switch (tokens[0].token) {
					case Keyword( Tag( name, _, c, tokens, false, true ) ):
						Assert.equals( 'i', name );
						Assert.equals( 0, tokens.length );
						
					case _:
						Assert.fail();
						
				}
				
			case _:
				Assert.fail();
				
		}
	}
	
	public function testTags_voidSpaced() {
		var t = parse( '<a/> <b/> <c/> <d/>' );
		
		//untyped console.log( t );
		
		Assert.equals( 7, t.length );
		
		for (token in t) switch (token.token) {
			case Keyword( Tag(name, _, _, _, true, true) ):
				Assert.isTrue( ['a', 'b', 'c', 'd'].indexOf( name ) > -1 );
				
			case Space(1):
				Assert.isTrue( true );
				
			case _:
				Assert.fail();
				
		}
	}
	
	public function testAttributes() {
		var t = parse( '<a z="aaa \'bbb\' ccc" x="1" y=2 onclick="alert(\'<a></a>\')"></a>' );
		
		//untyped console.log( t );
		
		Assert.isTrue( t.length == 1 );
		
		switch (t[0].token) {
			case Keyword( Tag(name, attributes, categories, tokens, false, true) ):
				Assert.isTrue( tokens.length == 0 );
				Assert.equals( 'a', name );
				
				Assert.isTrue( attributes.exists( 'z' ) );
				Assert.isTrue( attributes.exists( 'x' ) );
				Assert.isTrue( attributes.exists( 'y' ) );
				Assert.isTrue( attributes.exists( 'onclick' ) );
				
				Assert.equals( 'aaa \'bbb\' ccc', attributes.get( 'z' ) );
				Assert.equals( '1', attributes.get( 'x' ) );
				Assert.equals( '2', attributes.get( 'y' ) );
				Assert.equals( 'alert(\'<a></a>\')', attributes.get( 'onclick' ) );
				
			case _:
				Assert.fail();
		}
	}
	
	public function testAttributes_spaces() {
		var t = parse( '<a b  =  "  aaa bbb ccc  " / >' );
		
		//untyped console.log( t );
		
		Assert.equals( 1, t.length );
		
		switch (t[0].token) {
			case Keyword( Tag('a', attributes, categories, [], true, true) ):
				Assert.isFalse( attributes.exists( 'b  =  ' ) );
				Assert.equals( '  aaa bbb ccc  ', attributes.get('b') );
				
			case _:
				
		}
	}
	
	public function testEmpty() {
		var t = parse( '' );
		
		//untyped console.log( t );
		
		Assert.equals( 0, t.length );
	}
	
	public function testHtmlCategories() {
		var t = parse( '<link /><style></style><div></div><nav></nav><h1></h1><script></script><em></em><svg></svg><details /><a></a><img /><skial />' );
		
		for (i in t) switch (i.token) {
			case Keyword( Tag(n, _, c, _, _, _) ):
				switch ((n:HtmlTag)) {
					case Link: Assert.equals( ''+[0], ''+c );
					case Style: Assert.equals( ''+[0, 1], ''+c );
					case Div: Assert.equals( ''+[1, 7], ''+c );
					case Nav: Assert.equals( ''+[1, 2, 7], ''+c );
					case H1: Assert.equals( ''+[1, 3, 7], ''+c );
					case Script: Assert.equals( ''+[0, 1, 4, 8], ''+c );
					case Em: Assert.equals( ''+[1, 4, 7], ''+c );
					case Svg: Assert.equals( ''+[1, 4, 5, 7], ''+c );
					case Details: Assert.equals( ''+[1, 6, 7], ''+c );
					case A: Assert.equals( ''+[1, 4, 6, 7], ''+c );
					case Img: Assert.equals( ''+[1, 4, 5, 6, 7], ''+c );
					case _:
						Assert.equals( 'skial', n );
						Assert.equals( ''+[ -1], ''+c );
				}
				
			case _:
				
		}
	}
	
	public function testScript_content() {
		var t = parse( '<script>console.log( 1 <= 10 && 10 => 1 );</script>' );
		
		//untyped console.log( t );
		
		Assert.equals( 1, t.length );
		
		switch (t[0].token) {
			case Keyword(Tag('script', _, [0, 1, 4, 8], tokens, false, true)):
				Assert.isTrue( 
					tokens[0].token.match( 
						Const(CString( 'console.log( 1 <= 10 && 10 => 1 );' ))
					)
				);
				
			case _:
				
		}
	}
	
	public function testTemplate_content() {
		// From http://www.html5rocks.com/en/tutorials/webcomponents/template/
		var t = parse( '<template id="mytemplate">\r\n<img src="" alt="great image">\r\n <div class="comment"></div>\r\n</template>' );
		
		//untyped console.log( t );
		
		Assert.equals( 1, t.length );
		
		switch (t[0].token) {
			case Keyword(Tag('template', _, [0, 1, 4, 8], tokens, false, true)):
				Assert.isTrue( 
					tokens[0].token.match( 
						Const(CString( '\r\n<img src="" alt="great image">\r\n <div class="comment"></div>\r\n' ))
					)
				);
				
			case _:
				
		}
	}
	
	public function testTemplateNested_content() {
		var t = parse( '<div><template><a/><b/></template></div>' );
		
		//untyped console.log( t );
		
		Assert.equals( 1, t.length );
		
		var template:Array<Token<HtmlKeywords>> = switch (t[0].token) {
			case Keyword(Tag('div', _, _, tokens, _, _)): tokens;
			case _: [];
		}
		
		//untyped console.log( template );
		
		switch (template[0].token) {
			case Keyword(Tag('template', _, [0, 1, 4, 8], tokens, false, true)):
				Assert.isTrue( 
					tokens[0].token.match( 
						Const(CString( '<a/><b/>' ))
					)
				);
				
			case _:
				
		}
	}
	
	/*public function testAmazon_03_09_2014() {
		var t = parse( haxe.Resource.getString('amazon.html') );
		untyped console.log( t );
	}*/
	
	
}