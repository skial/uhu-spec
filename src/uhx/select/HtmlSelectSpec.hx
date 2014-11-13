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
			case Keyword(Tag( { name:'d', parent:p } )): 
				Assert.isTrue( p().match( Keyword(Tag( { name:'c' } )) ) );
				
				switch (p()) {
					case Keyword(Tag( { name:'c', parent:p } )):
						Assert.isTrue( p().match( Keyword(Tag( { name:'b' } )) ) );
						
						switch (p()) {
							case Keyword(Tag( { name:'b', parent:p } )):
								Assert.isTrue( p().match( Keyword(Tag( { name:'a' } )) ) );
								
								// Here I am checking that `<a></a>` parent is itself, which it should be.
								switch (p()) {
									case Keyword(Tag( { name:'a', parent:p } )):
										//Assert.isTrue( p().match( Keyword(Tag( { name:'a' } )) ) );
										Assert.isNull( p() );
										
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
		Assert.isTrue( mo[0].match( Keyword(Tag( { name:'div' } )) ) );
	}
	
	public function testMultiID() {
		var mo = HtmlSelector.find( parse( '<html><div id="A"></div><span id="A"></span></html>' ), '#A' );
		
		//untyped console.log( mo );
		
		Assert.equals( 2, mo.length );
		Assert.isTrue( mo[0].match( Keyword(Tag( { name:'div' } )) ) );
		Assert.isTrue( mo[1].match( Keyword(Tag( { name:'span' } )) ) );
	}
	
	public function testSingleID_deep() {
		var mo = HtmlSelector.find( parse( '<a><b><c><d><div></div><div id="A">Some Text</div><div></div></d></c></b></a>' ), '#A' );
		
		Assert.equals( 1, mo.length );
		Assert.isTrue( mo[0].match( Keyword(Tag( { name:'div', tokens:[Keyword(HtmlKeywords.Text( { tokens:'Some Text' } ))] } )) ) );
	}
	
	public function testSingleClass() {
		var mo = HtmlSelector.find( parse( '<html><div class="A"></div><span class="A"></span><pre class="A"></pre></html>' ), '.A' );
		
		//untyped console.log( mo );
		
		Assert.equals( 3, mo.length );
		Assert.isTrue( mo[0].match( Keyword(Tag( { name:'div' } )) ) );
		Assert.isTrue( mo[1].match( Keyword(Tag( { name:'span' } )) ) );
		Assert.isTrue( mo[2].match( Keyword(Tag( { name:'pre' } )) ) );
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
		Assert.isTrue( mo[0].match( Keyword(Tag( { name:'div' } )) ) );
		Assert.isTrue( mo[1].match( Keyword(Tag( { name:'span' } )) ) );
	}
	
	public function testUniversal() {
		var mo = HtmlSelector.find( parse( '<html><div class="A"></div><span id="B"></span></html>' ), '*' );
		
		//untyped console.log( mo );
		
		Assert.equals( 3, mo.length );
		Assert.isTrue( mo[0].match( Keyword(Tag( { name:'html' } )) ) );
		Assert.isTrue( mo[1].match( Keyword(Tag( { name:'div' } )) ) );
		Assert.isTrue( mo[2].match( Keyword(Tag( { name:'span' } )) ) );
	}
	
	public function testPseudo_firstChild() {
		var mo = HtmlSelector.find( parse( '<html><code>abc</code><span>def</span></html>' ), 'html :first-child' );
		
		//untyped console.log( mo );
		
		Assert.equals( 1, mo.length );
		Assert.isTrue( mo[0].match( Keyword(Tag( { name:'code', tokens:[Keyword(HtmlKeywords.Text( { tokens:'abc' } ))] } )) ) );
	}
	
	public function testPseudo_lastChild() {
		var mo = HtmlSelector.find( parse( '<html><code>abc</code><span>def</span></html>' ), 'html :last-child' );
		
		//untyped console.log( mo );
		
		Assert.equals( 1, mo.length );
		Assert.isTrue( mo[0].match( Keyword(Tag( { name:'span', tokens:[Keyword(HtmlKeywords.Text( { tokens:'def' } ))] } )) ) );
	}
	
	public function testPseudo_NthChild1() {
		// `:nth-child(odd)` selects every odd element.
		var mo = HtmlSelector.find( parse( '<html><code>abc</code><span>def</span></html>' ), 'html :nth-child(odd)' );
		
		//untyped console.log( mo );
		
		Assert.equals( 1, mo.length );
		Assert.isTrue( mo[0].match( Keyword(Tag( { name:'code', tokens:[Keyword(HtmlKeywords.Text( { tokens:'abc' } ))] } )) ) );
	}
	
	public function testPseudo_NthChild2() {
		// `:nth-child(-n+2)` selects the first two elements.
		var mo = HtmlSelector.find( parse( '<html><code>abc</code><span>def</span></html>' ), 'html :nth-child(-n+2)' );
		
		//untyped console.log( mo );
		
		Assert.equals( 2, mo.length );
		Assert.isTrue( mo[0].match( Keyword(Tag( { name:'code', tokens:[Keyword(HtmlKeywords.Text( { tokens:'abc' } ))] } )) ) );
		Assert.isTrue( mo[1].match( Keyword(Tag( { name:'span', tokens:[Keyword(HtmlKeywords.Text( { tokens:'def' } ))] } )) ) );
	}
	
	public function testCombinator_General() {
		var mo = HtmlSelector.find( parse( '<html><code>abc</code><span>def</span></html>' ), 'code ~ span' );
		
		//untyped console.log( mo );
		
		Assert.equals( 1, mo.length );
		Assert.isTrue( mo[0].match( Keyword(Tag( { name:'span', tokens:[Keyword(HtmlKeywords.Text( { tokens:'def' } ))] } )) ) );
	}
	
	public function testCombinator_Adjacent() {
		var mo = HtmlSelector.find( parse( '<html><code>a</code><span>b</span><pre>c</pre></html>' ), 'span + pre' );
		
		//untyped console.log( mo );
		
		Assert.equals( 1, mo.length );
		Assert.isTrue( mo[0].match( Keyword(Tag( { name:'pre', tokens:[Keyword(HtmlKeywords.Text( { tokens:'c' } ))] } )) ) );
	}
	
	public function testCombinator_Descendant() {
		var mo = HtmlSelector.find( parse( '<html><code>a</code><span>b</span><pre><pre>c</pre></pre></html>' ), 'pre pre' );
		
		//untyped console.log( mo );
		
		Assert.equals( 1, mo.length );
		Assert.isTrue( mo[0].match( Keyword(Tag( { name:'pre', tokens:[Keyword(HtmlKeywords.Text( { tokens:'c' } ))] } )) ) );
	}
	
	public function testCombinator_Child() {
		var mo = HtmlSelector.find( parse( '<html><code>a</code><span>b</span><pre><pre>c</pre></pre></html>' ), 'html > pre' );
		
		//untyped console.log( mo );
		
		Assert.equals( 1, mo.length );
		Assert.isTrue( mo[0].match( Keyword(Tag( { name:'pre', tokens:[Keyword(Tag( { name:'pre', tokens:[Keyword(HtmlKeywords.Text( { tokens:'c' } ))] } ))] } )) ) );
	}
	
	public function testAttributes_Name() {
		var mo = HtmlSelector.find( parse( '<html><div>a</div><div a>b</div><div>c</div></html>' ), 'div[a]' );
		
		Assert.equals( 1, mo.length );
		
		switch (mo[0]) {
			case Keyword(Tag( { name:'div', attributes:a, tokens:[Keyword(HtmlKeywords.Text( { tokens:'b' } ))] } )):
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
			case Keyword(Tag( { name:'div', attributes:a, tokens:[Keyword(HtmlKeywords.Text( { tokens:'b' } ))] } )):
				Assert.isTrue( a.exists('a') );
				Assert.equals( 'b', a.get('a') );
				
			case _:
				Assert.fail();
		}
	}
	
	public function testAttributes_ExactQuoted() {
		var mo = HtmlSelector.find( parse( '<html><div>a</div><div a="b">b</div><div>c</div></html>' ), 'div[a="b"]' );
		
		Assert.equals( 1, mo.length );
		
		switch (mo[0]) {
			case Keyword(Tag( { name:'div', attributes:a, tokens:[Keyword(HtmlKeywords.Text( { tokens:'b' } ))] } )):
				Assert.isTrue( a.exists('a') );
				Assert.equals( 'b', a.get('a') );
				
			case _:
				Assert.fail();
		}
	}
	
	public function testAttributes_Contains() {
		var mo = HtmlSelector.find( parse( '<html><div>a</div><div a="xxxaaasssdddbxxxcccvvvyeyq">b</div><div>c</div></html>' ), 'div[a*="b"]' );
		
		Assert.equals( 1, mo.length );
		
		switch (mo[0]) {
			case Keyword(Tag( { name:'div', attributes:a, tokens:[Keyword(HtmlKeywords.Text( { tokens:'b' } ))] } )):
				Assert.isTrue( a.exists('a') );
				Assert.equals( 'xxxaaasssdddbxxxcccvvvyeyq', a.get('a') );
				
			case _:
				Assert.fail();
		}
	}
	
	public function testAttributes_Prefix() {
		var mo = HtmlSelector.find( parse( '<html><div>a</div><div a="xxxaaasssdddbxxxcccvvvyeyq">b</div><div>c</div></html>' ), 'div[a^="xxx"]' );
		
		Assert.equals( 1, mo.length );
		
		switch (mo[0]) {
			case Keyword(Tag( { name:'div', attributes:a, tokens:[Keyword(HtmlKeywords.Text( { tokens:'b' } ))] } )):
				Assert.isTrue( a.exists('a') );
				Assert.equals( 'xxxaaasssdddbxxxcccvvvyeyq', a.get('a') );
				
			case _:
				Assert.fail();
		}
	}
	
	public function testAttributes_Suffix() {
		var mo = HtmlSelector.find( parse ( '<html><div>a</div><div a="xxxaaasssdddbxxxcccvvvyeyq">b</div><div>c</div></html>' ), 'div[a$="eyq"]' );
		
		Assert.equals( 1, mo.length );
		
		switch (mo[0]) {
			case Keyword(Tag( { name:'div', attributes:a, tokens:[Keyword(HtmlKeywords.Text( { tokens:'b' } ))] } )):
				Assert.isTrue( a.exists('a') );
				Assert.equals( 'xxxaaasssdddbxxxcccvvvyeyq', a.get('a') );
				
			case _:
				Assert.fail();
		}
	}
	
	public function testAttributes_List() {
		var mo = HtmlSelector.find( parse( '<html><div>a</div><div a="a1 a2 a3 a4 a5 a6">b</div><div>c</div></html>' ), 'div[a~="a3"]' );
		
		Assert.equals( 1, mo.length );
		
		switch (mo[0]) {
			case Keyword(Tag( { name:'div', attributes:a, tokens:[Keyword(HtmlKeywords.Text( { tokens:'b' } ))] } )):
				Assert.isTrue( a.exists('a') );
				Assert.equals( 'a1 a2 a3 a4 a5 a6', a.get('a') );
				
			case _:
				Assert.fail();
		}
	}
	
	public function testAttributes_DashedList() {
		var mo = HtmlSelector.find( parse( '<html><div>a</div><div a="a1-a2-a3-a4-a5-a6">b</div><div>c</div></html>' ), 'div[a|="a4"]' );
		
		Assert.equals( 1, mo.length );
		
		switch (mo[0]) {
			case Keyword(Tag( { name:'div', attributes:a, tokens:[Keyword(HtmlKeywords.Text( { tokens:'b' } ))] } )):
				Assert.isTrue( a.exists('a') );
				Assert.equals( 'a1-a2-a3-a4-a5-a6', a.get('a') );
				
			case _:
				Assert.fail();
		}
	}
	
	public function testAttributes_Multiple() {
		var mo = HtmlSelector.find( parse( '<html><div>a</div><div a="a1-a2-a3-a4-a5-a6" b="123abc456">b</div><div>c</div></html>' ), 'div[a|="a4"][b*="abc"]' );
		
		Assert.equals( 1, mo.length );
		
		switch (mo[0]) {
			case Keyword(Tag( { name:'div', attributes:a, tokens:[Keyword(HtmlKeywords.Text( { tokens:'b' } ))] } )):
				Assert.isTrue( a.exists('a') );
				Assert.isTrue( a.exists('b') );
				Assert.equals( 'a1-a2-a3-a4-a5-a6', a.get('a') );
				Assert.equals( '123abc456', a.get('b') );
				
			case _:
				Assert.fail();
		}
	}
	
	public function testFirstofType() {
		var mo = HtmlSelector.find( 
			parse( '<html><a>wrong</a><a>wrong</a><ABC>CORRECT</ABC><a>wrong</a><ABC>WRONG</ABC><a>wrong</a></html>' ), 
			'ABC:first-of-type' 
		);
		
		Assert.equals( 1, mo.length );
		
		switch (mo[0]) {
			case Keyword(Tag( { name:n, tokens:[Keyword(HtmlKeywords.Text( { tokens:'CORRECT' } ))] } )):
				Assert.equals( 'ABC', n );
				
			case _:
				Assert.fail();
		}
	}
	
	public function testLastofType() {
		
	}
	
}