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
	
	#if js
	public function DOM(html:String) {
		var dummy = Browser.document.createElement( 'div' );
		dummy.innerHTML = html;
		return dummy.childNodes[0];
	}
	#end
	
	public function testElement_basic() {
		var html =  '<a>Hey</a>';
		var n:NeNode = parse( html )[0];
		
		Assert.equals( 'a', n.nodeName );
		Assert.equals( 'Hey', n.textContent );
		Assert.equals( NeNode.ELEMENT_NODE, n.nodeType );
		
		#if js
		var j = DOM( html );
		
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
		var html = '<!-- hey from ne! -->';
		var n:NeNode = parse( html )[0];
		
		Assert.equals( '#comment', n.nodeName );
		Assert.equals( NeNode.COMMENT_NODE, n.nodeType );
		Assert.equals( ' hey from ne! ', n.nodeValue );
		Assert.equals( 0, n.childNodes.length );
		
		#if js
		var j = DOM( html );
		
		Assert.equals( '#comment', j.nodeName );
		Assert.equals( JsNode.COMMENT_NODE, j.nodeType );
		Assert.equals( ' hey from ne! ', j.nodeValue );
		Assert.equals( 0, j.childNodes.length );
		
		Assert.equals( n.nodeName, j.nodeName );
		Assert.equals( n.nodeType, j.nodeType );
		Assert.equals( n.nodeValue, j.nodeValue );
		Assert.equals( n.childNodes.length, j.childNodes.length );
		#end
	}
	
	public function testInstruction_basic2() {
		var html = '<?hey from ne! ?>';
		var n:NeNode = parse( html )[0];
		
		Assert.equals( '#comment', n.nodeName );
		Assert.equals( NeNode.COMMENT_NODE, n.nodeType );
		Assert.equals( '?hey from ne! ?', n.nodeValue );
		Assert.equals( 0, n.childNodes.length );
		
		#if js
		var j = DOM( html );
		
		Assert.equals( '#comment', j.nodeName );
		Assert.equals( JsNode.COMMENT_NODE, j.nodeType );
		Assert.equals( '?hey from ne! ?', j.nodeValue );
		Assert.equals( 0, j.childNodes.length );
		#end
	}
	
}