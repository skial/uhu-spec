package uhx.ne;

import utest.Assert;
import byte.ByteData;
import uhx.parser.Html;
import uhx.ne.Node as NeNode;

#if js
import js.Browser;
import js.html.Node as JsNode;
#end

using StringTools;

/**
 * ...
 * @author Skial Bainn
 */
class NeSpec {

	private var parser:Html;
	
	public function new() {
		parser = new Html();
	}
	
	public function parse(html:String) {
		return parser.toTokens( ByteData.ofString( html ), 'ne-spec' );
	}
	
	public function testElement_basic() {
		var html =  '<a>Hey</a>';
		var n:NeNode = parse( html )[0];
		
		Assert.equals( 'a', n.nodeName );
		Assert.equals( 'Hey', n.textContent );
		Assert.equals( NeNode.ELEMENT_NODE, n.nodeType );
		
		#if js
		var dummy = Browser.document.createElement( 'html' );
		dummy.innerHTML = html ;
		var j = dummy.getElementsByTagName( 'a' )[0];
		
		// HTML documents return node names in upper case.
		Assert.equals( 'A', j.nodeName );
		Assert.equals( 'Hey', j.textContent );
		Assert.equals( JsNode.ELEMENT_NODE, j.nodeType );
		
		Assert.equals( n.nodeName.toLowerCase(), j.nodeName.toLowerCase() );
		Assert.equals( n.textContent, j.textContent );
		Assert.equals( n.nodeType, j.nodeType );
		#end
	}
	
	public function testInstruction_basic1() {
		var n:NeNode = parse( '<!-- hey from ne! -->' )[0];
		
		Assert.equals( '#comment', n.nodeName );
		Assert.equals( NeNode.COMMENT_NODE, n.nodeType );
		Assert.equals( 'hey from ne!', n.nodeValue );
		Assert.equals( 0, n.childNodes.length );
	}
	
	public function testInstruction_basic2() {
		var n:NeNode = parse( '<! hey from ne! >' )[0];
		
		Assert.equals( 'hey', n.nodeName );
		Assert.equals( NeNode.PROCESSING_INSTRUCTION_NODE, n.nodeType );
		Assert.equals( 'hey from ne!', n.nodeValue );
		Assert.equals( 0, n.childNodes.length );
	}
	
}