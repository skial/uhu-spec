package uhx.fisel;

import utest.Assert;
import haxe.ds.StringMap;
import uhx.lexer.HtmlLexer;

#if sys
import sys.io.File;
#end

using Detox;
using StringTools;
using haxe.io.Path;

#if sys
using sys.FileSystem;
#end

/**
 * ...
 * @author Skial Bainn
 */
class FiselSpec {
	
	public var path:String;
	public var fisel:Fisel;
	
	@:access(Fisel) public function new() {
		path = '/templates/fisel/';
		
		fisel = new Fisel();
		fisel.document = 
		#if sys
			File.getContent( path = '${Sys.getCwd()}/$path/index.html'.fullPath() ).parse()
		#else
			''.parse()
		#end;
		
		fisel.location = path.normalize();
		fisel.linkMap = new StringMap();
		fisel.linkMap.set( path, fisel );
		fisel.find();
		fisel.load();
	}
	
	public function testBuild_Before() {
		var imports = fisel.document.find( 'link[rel="import"]' );
		var content = fisel.document.find( 'content[select]' );
		
		Assert.equals( 2, imports.length );
		Assert.equals( 3, content.length );
		
		trace( print( fisel.document.collection.filter( noWhitespace ) ) );
	}
	
	@:access(Fisel) public function testBuild_After() {
		fisel.build();
		
		var imports = fisel.document.find( 'link[rel="import"]' );
		var content = fisel.document.find( 'content[select]' );
		
		Assert.equals( 0, imports.length );
		Assert.equals( 0, content.length );
		
		var body = fisel.document.find( 'body' );
		
		Assert.isTrue( body.length > 0 );
		Assert.equals( 'header', body.children().getNode( 0 ).nodeName );
		Assert.equals( 1, body.children().getNode( 0 ).children().length );	// <nav>
		Assert.equals( 1, body.children().getNode( 0 ).children().getNode().children().length );	// <ul>
		Assert.equals( 3, body.children().getNode( 0 ).children().getNode().children().getNode().children().length );	// <li>
		
		Assert.equals( 'article', body.children().getNode( 1 ).nodeName );
		
		Assert.equals( 'footer', body.children().getNode( 2 ).nodeName );
		Assert.equals( 1, body.children().getNode( 2 ).children().length );	// <ul>
		Assert.equals( 3, body.children().getNode( 2 ).children().getNode().children().length );	// <li>
		
		trace( print( fisel.document.collection.filter( noWhitespace ) ) );
	}
	
	// utility methods
	
	// From Fisel's LibRunner.hx file
	private function noWhitespace(node:DOMNode):Bool {
		var result = true;
		
		if (node.nodeType == NodeType.Text && node.nodeValue.trim() == '') {
			result = false;
			
		} else if ((node.nodeType == NodeType.Element || node.nodeType == NodeType.Document) && node.hasChildNodes()) {
			node.childNodes = node.childNodes.filter( noWhitespace );
			
		}
		
		return result;
	}
	
	// From Fisel's LibRunner.hx file.
	// Completely bypass Detox's built in printer, its wrong in places.
	private function print(c:Array<DOMNode>, tab:String = ''):String {
		var ref;
		var node;
		var result = '';
		
		for (i in 0...c.length) {
			node = c[i];
			
			if (node.nodeType != NodeType.Text && i == 0) result += '\n';
			
			switch (node.nodeType) {
				case NodeType.Element, NodeType.Document, NodeType.Unknown:
					// Grab the underlying structure instead of accessing via the `DOMNode` abstract class.
					ref = switch (node.token()) {
						case Keyword(Tag(r)): r;
						case _: null;
					}
					
					if (ref != null) {
						result += '$tab<${ref.name}';
						
						if (ref.attributes.iterator().hasNext()) {
							result += ' ' + [for (k in ref.attributes.keys()) '$k="${ref.attributes.get(k)}"'].join(' ');
							
						}
						
						if (ref.selfClosing) {
							result += ' />';
							
						} else {
							result += '>';
							if (ref.tokens.length > 0) result += print(ref.tokens, '$tab\t');
							result += ((result.charAt(result.length - 1) == '\n') ? tab : '') + '</${ref.name}>';
							
						}
						
					}
					
				case NodeType.Text:
					result += node.nodeValue;
				
				case NodeType.Comment:
					result += '<!--${node.nodeValue}-->';
					
			}
			
			if (node.nodeType != NodeType.Text) result += '\n';
		}
		
		return result;
	}
	
}