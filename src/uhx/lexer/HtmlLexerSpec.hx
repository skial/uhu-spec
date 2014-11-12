package uhx.lexer;

import dtx.DOMType;
import dtx.Tools;
import haxe.io.Eof;
import hxparse.UnexpectedChar;
import uhx.mo.Token;
import utest.Assert;
import byte.ByteData;
import uhx.lexer.HtmlLexer;
import dtx.mo.DOMNode;

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
		
		try while ( true ) {
			tokens.push( lexer.token( HtmlLexer.root ) );
		} catch (_e:Eof) { } catch (_e:Dynamic) {
			
		}
		
		return tokens;
	}
	
	private function whitespace(t:Token<HtmlKeywords>) {
		return switch (t) {
			case Keyword(HtmlKeywords.Text(_)): false;
			case _: true;
		}
	}
	
	public function testInstruction() {
		var t = parse( '<!doctype html>' );
		
		Assert.equals( 1, t.length );
		
		switch (t[0]) {
			case Keyword( Instruction( { tokens:attributes } ) ):
				Assert.isTrue( attributes.indexOf( 'doctype' ) > -1 );
				Assert.isTrue( attributes.indexOf( 'html' ) > -1 );
				
			case _:
				
		}
	}
	
	public function testInstruction_IE() {
		var t = parse( '<!--[if IE]>' );
		
		Assert.equals( 1, t.length );
		
		switch (t[0]) {
			case Keyword( Instruction( { tokens:attributes } ) ):
				Assert.isTrue( attributes.indexOf( '[if IE]' ) > -1 );
				
			case _:
				
		}
	}
	
	public function testInstructions_unnamed() {
		var t = parse( '<![abc 123]>' );
		
		Assert.equals( 1, t.length );
		
		switch (t[0]) {
			case Keyword( Instruction( { tokens:attributes } ) ):
				Assert.isTrue( attributes.indexOf( '[abc 123]' ) > -1 );
				
			case _:
				Assert.fail();
		}
	}
	
	public function testInstructions_newline_carriage_tab() {
		var t = parse( '<!\n\r\t\n>' );
		
		Assert.equals( 1, t.length );
	}
	
	public function testInstructions_commented_css() {
		var t = parse( '<!--\n\r\tBODY { font-family: arial,verdana,helvetica,sans-serif; font-size: 13px; background-color: #FFFFFF; color: #000000; margin-top: 0px; } -->' );
		
		Assert.equals( 1, t.length );
		
		switch (t[0]) {
			case Keyword(Instruction( { tokens:attr } )):
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
		var f = t.filter( function(a) return a.match( Keyword(Instruction(_)) ) );
		
		Assert.equals( 3, t.length );
		Assert.equals( 1, f.length );
		
		switch (f[0]) {
			case Keyword(Instruction( { tokens:attrs } )):
				attrs = attrs.filter( function(s) return StringTools.trim(s) != '' );
				Assert.equals( '--', attrs[0] );
				Assert.equals( '<commented/>', attrs[1] );
				Assert.equals( '<html>', attrs[2] );
				Assert.equals( 'with', attrs[3] );
				Assert.equals( 'some', attrs[4] );
				Assert.equals( 'text', attrs[5] );
				Assert.equals( '</html>', attrs[6] );
				Assert.equals( '--', attrs[7] );
				
			case _:
				
		}
	}
	
	public function testInstructions_comment_breaking() {
		// This does not parse as you would expect :/.
		var t = parse( '<!-- <a> >> -->' );
		
		Assert.equals( 4, t.length );
		Assert.isTrue( t[0].match( Keyword(Instruction( { tokens:['--', ' ', '<a>',  ' '] } )) ) );
		Assert.isTrue( t[1].match( GreaterThan ) );
		Assert.isTrue( t[2].match( Keyword(HtmlKeywords.Text( { tokens:' --' } )) ) );
		Assert.isTrue( t[3].match( GreaterThan ) );
	}
	
	public function testInstructions_comment_spaceless() {
		var t = parse( '<!--comment-->' );
		
		Assert.equals( 1, t.length );
		Assert.isTrue( t[0].match( Keyword(Instruction( { tokens:['--', 'comment', '--'] } )) ) );
	}
	
	public function testSelfClosingTag() {
		var t = parse( '<link a="1" b="2" />' );
		
		Assert.equals( 1, t.length );
		
		switch (t[0]) {
			case Keyword(Tag({ name:'link', attributes:m, categories:[0] })):
				Assert.equals( 2, Lambda.count(m) );
				
			case _:
				
				
		}
	}
	
	public function testParagraphs() {
		var t = parse( paragraphs ).filter( whitespace );
		
		Assert.equals( 2, t.length );
		
		switch (t[1]) {
			case Keyword(Tag({ name:'p', categories:[1], tokens:t })):
				t = t.filter( whitespace );
				
				Assert.equals( 7, t.length );
				Assert.isTrue( t[0].match( Keyword(Tag({ name:'em', categories:[1, 4] })) ));
				Assert.isTrue( t[1].match( Keyword(Tag({ name:'em', categories:[1, 4] })) ));
				Assert.isTrue( t[2].match( Keyword(Tag({ name:'code', categories:[1, 4] })) ));
				Assert.isTrue( t[3].match( Keyword(Tag({ name:'code', categories:[1, 4] })) ));
				Assert.isTrue( t[4].match( Keyword(Tag({ name:'code', categories:[1, 4] })) ));
				Assert.isTrue( t[5].match( Keyword(Tag({ name:'code', categories:[1, 4] })) ));
				Assert.isTrue( t[6].match( Keyword(Tag({ name:'code', categories:[1, 4] })) ));
				
			case _:
		}
	}
	
	public function testTags_unending() {
		var t = parse( '<a><b><c><d><e><f>' );
		
		Assert.equals( 1, t.length );
		Assert.isTrue( t[0].match( Keyword( Tag( _ ) ) ) );
	}
	
	public function testTags_mismatch() {
		var t = parse( '<a><a></a></b></c></a>' );
		
		Assert.equals( 1, t.length );
		
		switch (t[0]) {
			case Keyword( Tag( { name:'a', categories:[1,4,6], tokens:t } ) ):
				Assert.equals( 3, t.length );
				Assert.isTrue( t[0].match(
					Keyword( Tag( { name:'a', categories:[1,4,6] } ) )
				) );
				Assert.isTrue( t[1].match( Keyword( End( 'b' ) ) ) );
				Assert.isTrue( t[2].match( Keyword( End( 'c' ) ) ) );
				
			case _:
				
		}
	}
	
	public function testTags_unfinished() {
		var t = parse( '<a><b><c' );
		
		Assert.equals( 1, t.length );
		
		while (true) switch (t[0]) {
			case Keyword( Tag( { name:name, categories:c, tokens:tokens } ) ):
				t = tokens;
				
				if (name == 'b') {
					Assert.equals( 1, tokens.length );
					Assert.isTrue( tokens[0].match( Keyword(Tag( { name:'c', complete:false, tokens:[] } )) ) );
					
					break;
					
				}
				
			case _:
				break;
				
		}
	}
	
	public function testTags_misnested() {
		var t = parse( '<b><i></b></i>' );
		
		Assert.equals( 1, t.length );
		
		switch (t[0]) {
			case Keyword( Tag( { name:name, categories:c, tokens:tokens } ) ):
				Assert.equals( 'b', name );
				Assert.equals( 1, tokens.length );
				
				switch (tokens[0]) {
					case Keyword( Tag( { name:name, categories:c, tokens:tokens } ) ):
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
		
		Assert.equals( 7, t.length );
		
		for (token in t) switch (token) {
			case Keyword( Tag( { name:name } ) ):
				Assert.isTrue( ['a', 'b', 'c', 'd'].indexOf( name ) > -1 );
				
			case Keyword(HtmlKeywords.Text( { tokens:' ' } )):
				Assert.isTrue( true );
				
			case _:
				Assert.fail();
				
		}
	}
	
	public function testAttributes() {
		var t = parse( '<a z="aaa \'bbb\' ccc" x="1" y=2 onclick="alert(\'<a></a>\')"></a>' );
		
		Assert.isTrue( t.length == 1 );
		
		switch (t[0]) {
			case Keyword( Tag( { name:name, attributes:attributes, categories:categories, tokens:tokens } ) ):
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
		
		Assert.equals( 1, t.length );
		
		switch (t[0]) {
			case Keyword( Tag( { name:'a', attributes:attributes, categories:categories, tokens:[] } ) ):
				Assert.isFalse( attributes.exists( 'b  =  ' ) );
				Assert.equals( '  aaa bbb ccc  ', attributes.get('b') );
				
			case _:
				
		}
	}
	
	public function testEmpty() {
		var t = parse( '' );
		
		Assert.equals( 0, t.length );
	}
	
	public function testWhitespace() {
		var t = parse( '<a></a> \r\n\t <a> \r\n\t <b></b> \r\n\t </a>' );
		
		Assert.equals( 3, t.length );
		Assert.isTrue( t[0].match( Keyword(Tag( { name:'a' } )) ) );
		Assert.isTrue( t[1].match( Keyword(Text( { tokens:' \r\n\t ' } )) ) );
		Assert.isTrue( t[2].match( Keyword(Tag( { name:'a' } )) ) );
		
		var collection:dtx.DOMCollection = new dtx.DOMCollection( cast t );
		var a:DOMNode = cast collection.getNode(2);
		
		Assert.equals( 3, a.childNodes.length );
		Assert.isTrue( a.childNodes[0].token().match( Keyword(Text( { tokens:' \r\n\t ' } )) ) );
		Assert.isTrue( a.childNodes[1].token().match( Keyword(Tag( { name:'b' } )) ) );
		Assert.isTrue( a.childNodes[2].token().match( Keyword(Text( { tokens:' \r\n\t ' } )) ) );
	}
	
	public function testHtmlCategories() {
		var t = parse( '<link /><style></style><div></div><nav></nav><h1></h1><script></script><em></em><svg></svg><details /><a></a><img /><skial />' );
		
		for (i in t) switch (i) {
			case Keyword( Tag( { name:n, categories:c } ) ):
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
		
		Assert.equals( 1, t.length );
		
		switch (t[0]) {
			case Keyword(Tag( { name:'script', categories:[0, 1, 4, 8], tokens:tokens } )):
				Assert.isTrue( 
					tokens[0].match( 
						Keyword(HtmlKeywords.Text( { tokens:'console.log( 1 <= 10 && 10 => 1 );' } ))
					)
				);
				
			case _:
				
		}
	}
	
	public function testTemplate_content() {
		// From http://www.html5rocks.com/en/tutorials/webcomponents/template/
		var t = parse( '<template id="mytemplate">\r\n<img src="" alt="great image">\r\n <div class="comment"></div>\r\n</template>' );
		
		Assert.equals( 1, t.length );
		
		switch (t[0]) {
			case Keyword(Tag( { name:'template', categories:[0, 1, 4, 8], tokens:tokens } )):
				Assert.isTrue( 
					tokens[0].match( 
						Keyword(HtmlKeywords.Text( { tokens:'\r\n<img src="" alt="great image">\r\n <div class="comment"></div>\r\n' } ))
					)
				);
				
			case _:
				
		}
	}
	
	public function testTemplateNested_content() {
		var t = parse( '<div><template><a/><b/></template></div>' );
		
		Assert.equals( 1, t.length );
		
		var template:Array<Token<HtmlKeywords>> = switch (t[0]) {
			case Keyword(Tag( { name:'div', tokens:tokens } )): tokens;
			case _: [];
		}
		
		switch (template[0]) {
			case Keyword(Tag( { name:'template', categories:[0, 1, 4, 8], tokens:tokens } )):
				Assert.isTrue( 
					tokens[0].match( 
						Keyword(HtmlKeywords.Text( { tokens:'<a/><b/>' } ))
					)
				);
				
			case _:
				
		}
	}
	
	public function testTag_namespace() {
		var t = parse( '<a:namespace>Hello Namespaced World</a:namespace>' );
		
		Assert.equals( 1, t.length );
		
		switch (t[0]) {
			case Keyword(Tag( { name:'a:namespace', categories:[ -1], tokens:tokens } )):
				Assert.equals( 1, tokens.length );
				Assert.isTrue( tokens[0].match( Keyword(HtmlKeywords.Text( { tokens:'Hello Namespaced World' } )) ) );
				
			case _:
				
		}
	}
	
	public function testInstruction_quotes() {
		var t = parse( '<!DOCTYPE html "TEXT IN QUOTES!" "SEPARATED BY THE GREAT DIVIDE!?!">' );
		
		Assert.equals( 1, t.length );
		
		switch (t[0]) {
			case Keyword(Instruction( { tokens:attrs } )):
				attrs = attrs.filter( function(s) return StringTools.trim(s) != '' );
				Assert.equals( 'DOCTYPE', attrs[0] );
				Assert.equals( 'html', attrs[1] );
				Assert.equals( 'TEXT IN QUOTES!', attrs[2] );
				Assert.equals( 'SEPARATED BY THE GREAT DIVIDE!?!', attrs[3] );
				
			case _:
				
		}
	}
	
	public function testInput_fromYar3333_haxeHtmlparser() {
		var t = parse( haxe.Resource.getString('input.html') );
		
		Assert.equals( 7, t.length );
		
		var filtered = t.filter( function(t) return switch(t) {
			case Keyword(HtmlKeywords.Text(_)): false;
			case _: true;
		} );
		
		Assert.equals( 4, filtered.length );
		
		switch (filtered[0]) {
			case Keyword(Instruction( { tokens:attr } )):
				attr = attr.filter( function(s) return StringTools.trim(s) != '' );
				Assert.equals( 'DOCTYPE', attr[0] );
				Assert.equals( 'html', attr[1] );
				Assert.equals( 'PUBLIC', attr[2] );
				Assert.equals( '-//W3C//DTD XHTML 1.0 Transitional//EN', attr[3] );
				Assert.equals( 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd', attr[4] );
				
			case _:
				
		}
	}
	
	public function testType() {
		var t = parse( '<a>Hello\r\n\t <p>Empty</p> \r\n\tWorld</a>' );
		
		Assert.equals( 1, t.length );
		
		var dom:DOMNode = t[0];
		
		Assert.equals( 3, dom.childNodes.length );
		Assert.equals( uhx.lexer.HtmlLexer.NodeType.Text, dom.childNodes[0].nodeType );
		Assert.equals( uhx.lexer.HtmlLexer.NodeType.Element, dom.childNodes[1].nodeType );
		Assert.equals( uhx.lexer.HtmlLexer.NodeType.Text, dom.childNodes[2].nodeType );
	}
	
	public function testTextAndSameTags() {
		var t = parse( '<a>123<a>456<a>Blah</a>def</a>abc</a>' );
		
		Assert.equals( 1, t.length );
		
		var dom:DOMNode = t[0];
		
		Assert.equals( 3, dom.childNodes.length );
	}
	
	public function testText_parent() {
		var t = parse( '<a><b><c><div class="parent">Some Text</div><c/></b></a>' );
		
		Assert.equals( 1, t.length );
		
		var text:Token<HtmlKeywords> = null;
		
		while (true) switch (t[0]) {
			case Keyword(Tag( { name:'div', attributes:attr, tokens:token } )) if (attr.exists('class') && attr.get('class') == 'parent'):
				text = token[0];
				break;
				
			case Keyword(Tag( { tokens:tokens } )):
				t = tokens;
				
			case _:
				
		}
		
		Assert.isFalse( text == null );
		Assert.isTrue( text.match( Keyword(Text( { tokens:'Some Text' } )) ) );
		
		var dom:dtx.mo.DOMNode = text;
		
		Assert.equals( 'div', dom.parentNode.nodeName );
		#if !js
		Assert.isTrue( dom.parentNode.childNodes[0].token().equals( text ) );
		#end
	}
	
	public function testDOMNode_clone() {
		var t = parse( '<a><b><c>Hello</c></b></a>' );
		
		Assert.equals( 1, t.length );
		
		var expected = ['a', 'b', 'c'];
		var original:DOMNode = null;
		var clone:DOMNode = null;
		
		while (true) switch (t[0]) {
			case Keyword(Tag( { name:n, tokens:tokens } )):
				Assert.equals( expected.shift(), n );
				t = tokens;
				
			case Keyword(Text( { tokens:token } )):
				Assert.equals( 'Hello', token );
				original = (t[0]:DOMNode);
				clone = (t[0]:DOMNode).cloneNode( true );
				break;
				
			case _:
				Assert.fail( 'Wrong! ' + (t[0]:DOMNode).toString() );
				
		}
		
		Assert.equals( 0, expected.length );
		Assert.equals( original.textContent, clone.textContent );
		
		clone.textContent = 'Goodbye';
		
		Assert.isFalse( original.textContent == clone.textContent );
		Assert.equals( 'Hello', original.textContent );
		Assert.equals( 'Goodbye', clone.textContent );
		
		// Test clone of an Processing Instruction Node (comment)
		var t = parse( '<!-- Hello -->' );
		
		Assert.equals( 1, t.length );
		Assert.isTrue( t[0].match( Keyword(Instruction( { tokens:['--', ' ', 'Hello', ' ', '--'] } )) ) );
		
		original = t[0];
		clone = original.cloneNode( true );
		
		Assert.equals( original.nodeValue, clone.nodeValue );
		
		clone.nodeValue = 'World';
		
		Assert.isFalse( original.nodeValue == clone.nodeValue );
		
		// Test clone of an element and all its children
		var t = parse( '<a><b><c><div>Hello</div><p>World</p></c></b></a>' );
		
		Assert.equals( 1, t.length );
		
		original = t[0];
		clone = original.cloneNode( true );
		
		var origDiv1 = original.childNodes[0].childNodes[0].childNodes[0];
		var origDiv2 = original.childNodes[0].childNodes[0].childNodes[1];
		var cloneDiv1 = clone.childNodes[0].childNodes[0].childNodes[0];
		var cloneDiv2 = clone.childNodes[0].childNodes[0].childNodes[1];
		
		Assert.equals( origDiv1.textContent, cloneDiv1.textContent );
		
		cloneDiv1.textContent = 'Goodbye';
		
		Assert.isFalse( origDiv1.textContent == cloneDiv1.textContent );
	}
	
	public function testDOMNode_removeChild() {
		var t = parse( '<a><b>Hello</b></a>' );
		
		Assert.equals( 1, t.length );
		
		var node:DOMNode = t[0];
		var old = node.removeChild( node.childNodes[0] );
		
		Assert.equals( 0, node.childNodes.length );
		Assert.equals( 1, old.childNodes.length );
	}
	
	public function testDOMNode_insertBefore() {
		var t = parse( '<a><c>World</c></a>' );
		var c = parse( '<b>Hello</b>' );
		
		Assert.equals( 1, t.length );
		Assert.equals( 1, c.length );
		
		var parent:DOMNode = t[0];
		var newNode:DOMNode = c[0];
		
		Assert.equals( 1, parent.childNodes.length );
		Assert.isTrue( parent.childNodes[0].token().match( Keyword(Tag( { name:'c', tokens:[Keyword(HtmlKeywords.Text( { tokens:'World' } ))] } )) ) );
		
		parent.insertBefore( newNode, parent.childNodes[0] );
		
		Assert.equals( 2, parent.childNodes.length );
		Assert.isTrue( parent.childNodes[0].token().match( Keyword(Tag( { name:'b', tokens:[Keyword(HtmlKeywords.Text( { tokens:'Hello' } ))] } )) ) );
		Assert.isTrue( parent.childNodes[1].token().match( Keyword(Tag( { name:'c', tokens:[Keyword(HtmlKeywords.Text( { tokens:'World' } ))] } )) ) );
	}
	
	public function testDOMNode_insertChild() {
		var t = parse( '<a><b></b><d></d></a>' );
		var c = parse( '<c></c>' );
		
		Assert.equals( 1, t.length );
		Assert.equals( 1, c.length );
		
		var parent:DOMNode = t[0];
		var newNode:DOMNode = c[0];
		
		Assert.equals( 2, parent.childNodes.length );
		Assert.isTrue( parent.childNodes[0].token().match( Keyword(Tag( { name:'b', tokens:[] } )) ) );
		Assert.isTrue( parent.childNodes[1].token().match( Keyword(Tag( { name:'d', tokens:[] } )) ) );
		
		parent.insertChild( newNode, 1 );
		
		Assert.equals( 3, parent.childNodes.length );
		Assert.isTrue( parent.childNodes[0].token().match( Keyword(Tag( { name:'b', tokens:[] } )) ) );
		Assert.isTrue( parent.childNodes[1].token().match( Keyword(Tag( { name:'c', tokens:[] } )) ) );
		Assert.isTrue( parent.childNodes[2].token().match( Keyword(Tag( { name:'d', tokens:[] } )) ) );
	}
	
	public function testDOMNode_appendChild() {
		var t = parse( '<a><b>Hello</b></a>' );
		var c = parse( '<c>World</c>' );
		
		Assert.equals( 1, t.length );
		Assert.equals( 1, c.length );
		
		var parent:DOMNode = t[0];
		var newNode:DOMNode = c[0];
		
		Assert.equals( 1, parent.childNodes.length );
		Assert.isTrue( parent.childNodes[0].token().match( Keyword(Tag( { name:'b', tokens:[Keyword(HtmlKeywords.Text( { tokens:'Hello' } ))] } )) ) );
		
		parent.appendChild( newNode );
		
		Assert.equals( 2, parent.childNodes.length );
		Assert.isTrue( parent.childNodes[0].token().match( Keyword(Tag( { name:'b', tokens:[Keyword(HtmlKeywords.Text( { tokens:'Hello' } ))] } )) ) );
		Assert.isTrue( parent.childNodes[1].token().match( Keyword(Tag( { name:'c', tokens:[Keyword(HtmlKeywords.Text( { tokens:'World' } ))] } )) ) );
	}
	
	public function testDOMNode_getAttribute() {
		var t = parse( '<a b="1" data-c="bob"></a>' );
		
		Assert.equals( 1, t.length );
		
		var dom:DOMNode = t[0];
		
		Assert.equals( '1', dom.getAttribute('b') );
		Assert.equals( 'bob', dom.getAttribute('data-c') );
	}
	
	public function testDOMNode_getAttribute_Unquoted() {
		var t = parse( '<a b="1" data-c=bob></a>' );
		
		Assert.equals( 1, t.length );
		
		var dom:DOMNode = t[0];
		
		Assert.equals( '1', dom.getAttribute('b') );
		Assert.equals( 'bob', dom.getAttribute('data-c') );
	}
	
	public function testDOMNode_setAttribute() {
		var t = parse( '<a></a>' );
		
		Assert.equals( 1, t.length );
		
		var dom:DOMNode = t[0];
		dom.setAttribute('data-a', 'hello');
		dom.setAttribute('b', 'world');
		
		var attributes = [for (a in dom.attributes.array()) a.name => a.value];
		Assert.isTrue( attributes.exists('data-a') );
		Assert.isTrue( attributes.exists('b') );
		Assert.equals( 'hello', attributes.get( 'data-a' ) );
		Assert.equals( 'world', attributes.get( 'b' ) );
		Assert.equals( 'hello', dom.getAttribute('data-a') );
		Assert.equals( 'world', dom.getAttribute('b') );
	}
	
	public function testInstruction_content() {
		var t = parse( '<!-- hello world -->' );
		var values = [];
		
		Assert.equals( 1, t.length );
		Assert.isTrue( switch (t[0]) {
			case Keyword(Instruction( { tokens:tokens } )):
				values = tokens.filter( function(s) return StringTools.trim(s) != '' );
				tokens.length == 7;
				
			case _:
				false;
				
		} );
		
		Assert.equals( '--', values[0] );
		Assert.equals( 'hello', values[1] );
		Assert.equals( 'world', values[2] );
		Assert.equals( '--', values[3] );
		
		var dom:DOMNode = t[0];
		Assert.equals( ' hello world ', dom.nodeValue );
		
		dom.nodeValue = 'goodbye world';
		
		Assert.equals( 'goodbye world', dom.nodeValue );
		
		Assert.isTrue( switch (dom.token()) {
			case Keyword(Instruction( { tokens:tokens } )):
				values = tokens;
				tokens.length == 5;
				
			case _:
				false;
				
		} );
		
		Assert.equals( '--', values[0] );
		Assert.equals( 'goodbye', values[1] );
		Assert.equals( ' ', values[2] );
		Assert.equals( 'world', values[3] );
		Assert.equals( '--', values[4] );
	}
	
	public function testDOMNode_nextSibling() {
		var t = parse( '<a><b></b><c></c><d></d></a>' );
		
		Assert.equals( 1, t.length );
		
		var a:DOMNode = t[0];
		var children = a.childNodes;
		var b = children[0];
		var bt = b.token();
		
		var c = children[1];
		var ct = c.token();
		
		var d = children[2];
		var dt = d.token();
		
		Assert.isTrue( bt.match( Keyword(Tag( { name:'b', tokens:[] } )) ) );
		Assert.isTrue( ct.match( Keyword(Tag( { name:'c', tokens:[] } )) ) );
		Assert.isTrue( dt.match( Keyword(Tag( { name:'d', tokens:[] } )) ) );
		
		Assert.isTrue( a == b.parentNode );
		Assert.isTrue( a == c.parentNode );
		Assert.isTrue( a == d.parentNode );
		
		Assert.isTrue( b.nextSibling == c );
		Assert.isTrue( c.nextSibling == d );
		Assert.isNull( d.nextSibling );
	}
	
	public function testDOMNode_nextSibling_whitespace() {
		var t = parse( '<a>
			<b></b>
			<c></c>
			<d></d>
		</a>' );
		
		Assert.equals( 1, t.length );
		
		var a:DOMNode = t[0];
		var children = a.childNodes;
		var b = children[1];
		var bt = b.token();
		
		var c = children[3];
		var ct = c.token();
		
		var d = children[5];
		var dt = d.token();
		
		Assert.isTrue( bt.match( Keyword(Tag( { name:'b', tokens:[] } )) ) );
		Assert.isTrue( ct.match( Keyword(Tag( { name:'c', tokens:[] } )) ) );
		Assert.isTrue( dt.match( Keyword(Tag( { name:'d', tokens:[] } )) ) );
		
		Assert.isTrue( a == b.parentNode );
		Assert.isTrue( a == c.parentNode );
		Assert.isTrue( a == d.parentNode );
		
		Assert.isTrue( b.nextSibling.nextSibling == c );
		Assert.isTrue( c.nextSibling.nextSibling == d );
		Assert.isNull( d.nextSibling.nextSibling );
	}
	
	public function testDOMNode_previousSibling() {
		var t = parse( '<a><b></b><c></c><d></d></a>' );
		
		Assert.equals( 1, t.length );
		
		var a:DOMNode = t[0];
		var children = a.childNodes;
		var b = children[0];
		var bt = b.token();
		
		var c = children[1];
		var ct = c.token();
		
		var d = children[2];
		var dt = d.token();
		
		Assert.isTrue( bt.match( Keyword(Tag( { name:'b', tokens:[] } )) ) );
		Assert.isTrue( ct.match( Keyword(Tag( { name:'c', tokens:[] } )) ) );
		Assert.isTrue( dt.match( Keyword(Tag( { name:'d', tokens:[] } )) ) );
		
		Assert.isTrue( a == b.parentNode );
		Assert.isTrue( a == c.parentNode );
		Assert.isTrue( a == d.parentNode );
		
		Assert.isTrue( d.previousSibling == c );
		Assert.isTrue( c.previousSibling == b );
		Assert.isNull( b.previousSibling );
	}
	
	public function testDOMNode_navigation() {
		var t = parse( "<myxml>
			<h1>Title</h1>
			<ul id='a'>
				<li id='a1'>1</li>
				<li id='a2' class='pickme'>2</li>
				<li id='a3'>3</li>
				<li id='a4'>4</li>
			</ul>
			<ul id='b'>
				<li id='b1'>1</li>
				<li id='b2' class='pickme'>2</li>
				<li id='b3'>3</li>
				<li id='b4'>4</li>
			</ul>
			<div id='empty1' class='empty'></div>
			<div id='empty2' class='empty'></div>
			<div id='nonElements'>Before<!--Comment-->After</div>
			<div id='recursive' class='level1'>
				<div class='level2'>
					<div class='level3'>
						<div class='level4'>
						</div>
					</div>
				</div>
			</div>
		</myxml>" );
		
		Assert.equals( 1, t.length );
		
		var result = '';
		var func:DOMNode->String->Void = null;
		func = function(dom:DOMNode, tab:String) {
			result += tab + dom.nodeName + ':';
			result += [for (a in dom.attributes) a.name + '=>' + a.value].join('!');
			for (child in dom.childNodes) {
				result += '\n';
				func( child, '$tab\t' );
			}
		}
		
		var dom:DOMNode = t[0];
		
		// This includes the whitespace between elements.
		Assert.equals( 15, dom.childNodes.length );
		
		var elementsOnly = dom.childNodes.filter( function(c) return c.nodeType != NodeType.Text );
		
		Assert.equals( 7, elementsOnly.length );
		
		Assert.equals( 1, elementsOnly[0].parentNode.childNodes.indexOf( elementsOnly[0] ) );
		Assert.equals( 3, elementsOnly[1].parentNode.childNodes.indexOf( elementsOnly[1] ) );
		Assert.equals( 3, elementsOnly[1].parentNode.childNodes.lastIndexOf( elementsOnly[1] ) );
		
		Assert.equals( 'ul', elementsOnly[1].nodeName );
		Assert.equals( 'id', elementsOnly[1].attributes.array()[0].name );
		Assert.equals( 'a', elementsOnly[1].attributes.array()[0].value );
		
		Assert.isTrue( elementsOnly[1].nextSibling.token().match( Keyword(HtmlKeywords.Text( { tokens:'
			' } )) ) );
		Assert.equals( 4, dom.childNodes.indexOf( elementsOnly[1].nextSibling ) );
		
		Assert.equals( 'li', elementsOnly[1].childNodes[1].nodeName );
		Assert.equals( 'id', elementsOnly[1].childNodes[1].attributes.array()[0].name );
		Assert.equals( 'a1', elementsOnly[1].childNodes[1].attributes.array()[0].value );
		
		Assert.isTrue( elementsOnly[1].childNodes[1].lastChild.token().match( Keyword(HtmlKeywords.Text( { tokens:'1' } )) ) );
		
		Assert.equals( 'li', elementsOnly[1].childNodes[1].lastChild.parentNode.nodeName );
		Assert.equals( 'id', elementsOnly[1].childNodes[1].lastChild.parentNode.attributes.array()[0].name );
		Assert.equals( 'a1', elementsOnly[1].childNodes[1].lastChild.parentNode.attributes.array()[0].value );
		
		Assert.equals( 'ul', elementsOnly[1].childNodes[1].lastChild.parentNode.parentNode.nodeName );
		Assert.equals( 'id', elementsOnly[1].childNodes[1].lastChild.parentNode.parentNode.attributes.array()[0].name );
		Assert.equals( 'a', elementsOnly[1].childNodes[1].lastChild.parentNode.parentNode.attributes.array()[0].value );
		
		Assert.isTrue( elementsOnly[1].childNodes[1].lastChild.parentNode.parentNode.nextSibling.token().match( Keyword(HtmlKeywords.Text( { tokens:'
			' } )) ) );
		Assert.isTrue( elementsOnly[1] == elementsOnly[1].childNodes[1].lastChild.parentNode.parentNode );
		Assert.equals( 4, elementsOnly[1].parentNode.childNodes.indexOf( elementsOnly[1].childNodes[1].lastChild.parentNode.parentNode.nextSibling ) );
		Assert.equals( 4, dom.childNodes.indexOf( elementsOnly[1].childNodes[1].lastChild.parentNode.parentNode.nextSibling ) );
	}
	
	public function testElementCount() {
		var t = parse( "<myxml>
			<div id='recursive' class='level1'>
				<div class='level2'>
					<div class='level3'>
						<div class='level4'>
						</div>
					</div>
				</div>
			</div>
		</myxml>" );
		
		Assert.equals( 1, t.length );
		
		var dom:DOMNode = t[0];
		
		Assert.equals( 3, dom.childNodes.length );
		Assert.isTrue( dom.childNodes[0].token().match( Keyword(Text( { tokens:'
			' } )) ) );
		// div.class=level1#id=recursive
		Assert.isTrue( dom.childNodes[1].token().match( Keyword(Tag( { name:'div' } )) ) );
		Assert.isTrue( dom.childNodes[2].token().match( Keyword(Text( { tokens:'
		' } )) ) );
		
		Assert.equals( 3, dom.childNodes[1].childNodes.length );
		// div.class=level2
		Assert.equals( 3, dom.childNodes[1].childNodes[1].childNodes.length );
		
		switch (dom.childNodes[1].childNodes[1].token()) {
			case Keyword(Tag( { name:'div', tokens:t, attributes:a } )):
				Assert.isTrue( a.exists('class') );
				Assert.equals( 'level2', a.get('class') );
				Assert.equals( 3, t.length );
				
			case _:
				Assert.fail();
		}
		
		// div.class=level3
		Assert.equals( 3, dom.childNodes[1].childNodes[1].childNodes[1].childNodes.length );
		Assert.equals( 'level4', dom.childNodes[1].childNodes[1].childNodes[1].childNodes[1].getAttribute('class') );
		Assert.equals( 1, dom.childNodes[1].childNodes[1].childNodes[1].childNodes[1].childNodes.length );
	}
	
	public function testMacro_parse() {
		Assert.equals('<ul>OneTwo</ul>', macroValue());
	}
	
	private static macro function macroValue() {
		HtmlLexer.openTags = [];
		var bytes = ByteData.ofString( "<doc><ul><li>One</li><li class='special'>Two</li></ul></doc>" );
		var lexer = new HtmlLexer( bytes, 'macro-html' );
		var tokens:Array<DOMNode> = [];
		
		try while ( true ) {
			var token = lexer.token( HtmlLexer.root );
			tokens.push( token );
		} catch (_e:Eof) { } catch (_e:Dynamic) {
			haxe.macro.Context.fatalError( '$_e', haxe.macro.Context.currentPos() );
		}
		
		var value = [for (t in tokens) t.toString()].join(' ');
		return macro $v{ value };
	}
	
	/*public function testAmazon_03_09_2014() {
		var t = parse( haxe.Resource.getString('amazon.html') );
		
		//untyped console.log( t );
	}*/	
	
}