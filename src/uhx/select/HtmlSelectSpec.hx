package uhx.select;

import haxe.io.Eof;
import utest.Assert;
import uhx.mo.Token;
import byte.ByteData;
import dtx.mo.DOMNode;
import uhx.lexer.CssLexer;
import uhx.lexer.HtmlLexer;
import uhx.lexer.SelectorParser;

import uhx.select.Html in HtmlSelector;

/**
 * ...
 * @author Skial Bainn
 */
class HtmlSelectSpec {

	public function new() {
		
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
	
	public function cssParse(value:String) {
		return new SelectorParser().toTokens( ByteData.ofString( value ), 'html-css-selector' );
	}
	
	// Even thought this is testing the html token structure,
	// it is easier with a css processor.
	public function testAncestorChain() {
		var mo = HtmlSelector.find( parse( '<a><b><c><d></d></c></b></a>' ), 'd' );
		
		//untyped console.log( mo );
		
		Assert.equals( 1, mo.length );
		
		switch (mo[0]) {
			case Keyword(Tag('d', _, _, _, p)): 
				Assert.isTrue( p().match( Keyword(Tag('c', _, _, _, _)) ) );
				
				switch (p()) {
					case Keyword(Tag('c', _, _, _, p)):
						Assert.isTrue( p().match( Keyword(Tag('b', _, _, _, _)) ) );
						
						switch (p()) {
							case Keyword(Tag('b', _, _, _, p)):
								Assert.isTrue( p().match( Keyword(Tag('a', _, _, _, _)) ) );
								
								// Here I am checking that `<a></a>` parent is itself, which it should be.
								switch (p()) {
									case Keyword(Tag('a', _, _, _, p)):
										Assert.isTrue( p().match( Keyword(Tag('a', _, _, _, _)) ) );
										
									case _:
								}
								
							case _:
						}
						
					case _:
				}
				
			case _:
		}
	}
	
	public function testSingleID() {
		var mo = HtmlSelector.find( parse( '<html><div id="A"></div></html>' ), '#A' );
		
		//untyped console.log( mo );
		
		Assert.equals( 1, mo.length );
		Assert.isTrue( mo[0].match( Keyword(Tag('div', _, _, [], _)) ) );
	}
	
	public function testMultiID() {
		var mo = HtmlSelector.find( parse( '<html><div id="A"></div><span id="A"></span></html>' ), '#A' );
		
		//untyped console.log( mo );
		
		Assert.equals( 2, mo.length );
		Assert.isTrue( mo[0].match( Keyword(Tag('div', _, _, [], _)) ) );
		Assert.isTrue( mo[1].match( Keyword(Tag('span', _, _, [], _)) ) );
	}
	
	public function testSingleClass() {
		var mo = HtmlSelector.find( parse( '<html><div class="A"></div><span class="A"></span><pre class="A"></pre></html>' ), '.A' );
		
		//untyped console.log( mo );
		
		Assert.equals( 3, mo.length );
		Assert.isTrue( mo[0].match( Keyword(Tag('div', _, _, [], _)) ) );
		Assert.isTrue( mo[1].match( Keyword(Tag('span', _, _, [], _)) ) );
		Assert.isTrue( mo[2].match( Keyword(Tag('pre', _, _, [], _)) ) );
	}
	
	// Css Parser problem
	/*public function testMultiClass() {
		untyped console.log( cssParse( '.A.B.C' ) ); // Find an element that has all these class name
		untyped console.log( cssParse( '.A .B .C' ) ); // Find an ele w/ `C` class name inside an ele w/ class `B` inside ele w/ class name `A`
	}*/
	
	public function testGrouping() {
		var mo = HtmlSelector.find( parse( '<html><div class="A"></div><span id="B"></span></html>' ), '.A, #B' );
		
		//untyped console.log( mo );
		
		Assert.equals( 2, mo.length );
		Assert.isTrue( mo[0].match( Keyword(Tag('div', _, _, [], _)) ) );
		Assert.isTrue( mo[1].match( Keyword(Tag('span', _, _, [], _)) ) );
	}
	
	public function testUniversal() {
		var mo = HtmlSelector.find( parse( '<html><div class="A"></div><span id="B"></span></html>' ), '*' );
		
		//untyped console.log( mo );
		
		Assert.equals( 3, mo.length );
		Assert.isTrue( mo[0].match( Keyword(Tag('html', _, _, _, _)) ) );
		Assert.isTrue( mo[1].match( Keyword(Tag('div', _, _, [], _)) ) );
		Assert.isTrue( mo[2].match( Keyword(Tag('span', _, _, [], _)) ) );
	}
	
	public function testPseudo_firstChild() {
		var mo = HtmlSelector.find( parse( '<html><code>abc</code><span>def</span></html>' ), 'html :first-child' );
		
		//untyped console.log( mo );
		
		Assert.equals( 1, mo.length );
		Assert.isTrue( mo[0].match( Keyword(Tag('code', _, _, [Const(CString('abc'))], _)) ) );
	}
	
	public function testPseudo_lastChild() {
		var mo = HtmlSelector.find( parse( '<html><code>abc</code><span>def</span></html>' ), 'html :last-child' );
		
		//untyped console.log( mo );
		
		Assert.equals( 1, mo.length );
		Assert.isTrue( mo[0].match( Keyword(Tag('span', _, _, [Const(CString('def'))], _)) ) );
	}
	
	public function testPseudo_NthChild1() {
		// `:nth-child(odd)` selects every odd element.
		var mo = HtmlSelector.find( parse( '<html><code>abc</code><span>def</span></html>' ), 'html :nth-child(odd)' );
		
		//untyped console.log( mo );
		
		Assert.equals( 1, mo.length );
		Assert.isTrue( mo[0].match( Keyword(Tag('code', _, _, [Const(CString('abc'))], _)) ) );
	}
	
	public function testPseudo_NthChild2() {
		// `:nth-child(-n+2)` selects the first two elements.
		var mo = HtmlSelector.find( parse( '<html><code>abc</code><span>def</span></html>' ), 'html :nth-child(-n+2)' );
		
		//untyped console.log( mo );
		
		Assert.equals( 2, mo.length );
		Assert.isTrue( mo[0].match( Keyword(Tag('code', _, _, [Const(CString('abc'))], _)) ) );
		Assert.isTrue( mo[1].match( Keyword(Tag('span', _, _, [Const(CString('def'))], _)) ) );
	}
	
	public function testCombinator_General() {
		var mo = HtmlSelector.find( parse( '<html><code>abc</code><span>def</span></html>' ), 'code ~ span' );
		
		//untyped console.log( mo );
		
		Assert.equals( 1, mo.length );
		Assert.isTrue( mo[0].match( Keyword(Tag('span', _, _, [Const(CString('def'))], _)) ) );
	}
	
	public function testCombinator_Adjacent() {
		var mo = HtmlSelector.find( parse( '<html><code>a</code><span>b</span><pre>c</pre></html>' ), 'span + pre' );
		
		//untyped console.log( mo );
		
		Assert.equals( 1, mo.length );
		Assert.isTrue( mo[0].match( Keyword(Tag('pre', _, _, [Const(CString('c'))], _)) ) );
	}
	
	public function testCombinator_Descendant() {
		var mo = HtmlSelector.find( parse( '<html><code>a</code><span>b</span><pre><pre>c</pre></pre></html>' ), 'pre pre' );
		
		//untyped console.log( mo );
		
		Assert.equals( 1, mo.length );
		Assert.isTrue( mo[0].match( Keyword(Tag('pre', _, _, [Const(CString('c'))], _)) ) );
	}
	
	public function testCombinator_Child() {
		var mo = HtmlSelector.find( parse( '<html><code>a</code><span>b</span><pre><pre>c</pre></pre></html>' ), 'html > pre' );
		
		//untyped console.log( mo );
		
		Assert.equals( 1, mo.length );
		Assert.isTrue( mo[0].match( Keyword(Tag('pre', _, _, [Keyword(Tag('pre', _, _, [Const(CString('c'))], _))], _)) ) );
	}
	
	public function testAttributes_Name() {
		var mo = HtmlSelector.find( parse( '<html><div>a</div><div a>b</div><div>c</div></html>' ), 'div[a]' );
		
		//untyped console.log( mo );
		
		Assert.equals( 1, mo.length );
		
		switch (mo[0]) {
			case Keyword(Tag('div', a, _, [Const(CString('b'))], _)):
				Assert.isTrue( a.exists('a') );
				Assert.equals( '', a.get('a') );
				
			case _:
				Assert.fail();
		}
	}
	
	public function testAttributes_ExactUnQuoted() {
		var mo = HtmlSelector.find( parse( '<html><div>a</div><div a="b">b</div><div>c</div></html>' ), 'div[a=b]' );
		
		//untyped console.log( mo );
		
		Assert.equals( 1, mo.length );
		
		switch (mo[0]) {
			case Keyword(Tag('div', a, _, [Const(CString('b'))], _)):
				Assert.isTrue( a.exists('a') );
				Assert.equals( 'b', a.get('a') );
				
			case _:
		}
	}
	
	// currently failing
	public function testAttributes_ExactQuoted() {
		var mo = HtmlSelector.find( parse( '<html><div>a</div><div a="b">b</div><div>c</div></html>' ), 'div[a="b"]' );
		
		untyped console.log( mo );
		
		Assert.equals( 1, mo.length );
		
		switch (mo[0]) {
			case Keyword(Tag('div', a, _, [Const(CString('b'))], _)):
				Assert.isTrue( a.exists('a') );
				Assert.equals( 'b', a.get('a') );
				
			case _:
		}
	}
	
}