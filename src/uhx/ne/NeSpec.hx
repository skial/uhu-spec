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
		
		Assert.equals( j.nodeName.toLowerCase(), n.nodeName.toLowerCase() );
		Assert.equals( j.textContent, n.textContent );
		Assert.equals( j.nodeType, n.nodeType );
		#end
	}
	
	public function testElement_children() {
		var html = '<a><b>hello</b><c>world</c></a>';
		var n:NeNode = parse( html )[0];
		
		Assert.equals( 2, n.childNodes.length );
		Assert.isTrue( n.hasChildNodes() );
		Assert.equals( 'b', n.childNodes[0].nodeName );
		Assert.equals( 'c', n.childNodes[1].nodeName );
		Assert.equals( '#text', n.childNodes[0].childNodes[0].nodeName );
		Assert.equals( '#text', n.childNodes[1].childNodes[0].nodeName );
		
		#if js
		var j = DOM( html );
		
		Assert.equals( 2, j.childNodes.length );
		Assert.isTrue( j.hasChildNodes() );
		Assert.equals( 'B', j.childNodes[0].nodeName );
		Assert.equals( 'C', j.childNodes[1].nodeName );
		Assert.equals( '#text', j.childNodes[0].childNodes[0].nodeName );
		Assert.equals( '#text', j.childNodes[1].childNodes[0].nodeName );
		
		Assert.equals( j.childNodes.length, n.childNodes.length );
		Assert.equals( j.hasChildNodes(), n.hasChildNodes() );
		Assert.equals( j.childNodes[0].nodeName.toLowerCase(), n.childNodes[0].nodeName.toLowerCase() );
		Assert.equals( j.childNodes[1].nodeName.toLowerCase(), n.childNodes[1].nodeName.toLowerCase() );
		Assert.equals( j.childNodes[0].childNodes[0].nodeName, n.childNodes[0].childNodes[0].nodeName );
		Assert.equals( j.childNodes[1].childNodes[0].nodeName, n.childNodes[1].childNodes[0].nodeName );
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
		
		Assert.equals( j.nodeName, n.nodeName );
		Assert.equals( j.nodeType, n.nodeType );
		Assert.equals( j.nodeValue, n.nodeValue );
		Assert.equals( j.childNodes.length, n.childNodes.length );
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
		
		Assert.equals( j.nodeName, n.nodeName );
		Assert.equals( j.nodeType, n.nodeType );
		Assert.equals( j.nodeValue, n.nodeValue );
		Assert.equals( j.childNodes.length, n.childNodes.length );
		#end
	}
	
	public function testText_basic() {
		var html = 'short story';
		var n:NeNode = parse( html )[0];
		
		Assert.equals( '#text', n.nodeName );
		Assert.equals( NeNode.TEXT_NODE, n.nodeType );
		Assert.equals( html, n.textContent );
		Assert.equals( html, n.nodeValue );
		
		#if js
		var j = DOM( html );
		
		Assert.equals( '#text', j.nodeName );
		Assert.equals( JsNode.TEXT_NODE, j.nodeType );
		Assert.equals( html, j.textContent );
		Assert.equals( html, j.nodeValue );
		
		Assert.equals( j.nodeName, n.nodeName );
		Assert.equals( j.nodeType, n.nodeType );
		Assert.equals( j.textContent, n.textContent );
		Assert.equals( j.nodeValue, n.nodeValue );
		#end
	}
	
	public function testBrowser() {
		var doc = uhx.ne.Browser.document;
		trace( doc );
	}
	
}