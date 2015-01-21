package uhx.fisel;

import utest.Assert;

#if sys
import sys.io.File;
#end

using Detox;

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
	
	public function new() {
		path = '../templates/fisel/';
		
		fisel = new Fisel( 
			#if sys
				File.getContent( '$path/index.html'.fullPath() ).parse(), path.fullPath()
			#else
				''.parse()
			#end
		);
		
		fisel.load();
	}
	
	public function testBuild_Before() {
		var imports = fisel.document.find( 'link[rel="import"]' );
		var content = fisel.document.find( 'content[select]' );
		
		Assert.equals( 2, imports.length );
		Assert.equals( 3, content.length );
	}
	
	public function testBuild_After() {
		fisel.build();
		
		var imports = fisel.document.find( 'link[rel="import"]' );
		var content = fisel.document.find( 'content[select]' );
		
		Assert.equals( 0, imports.length );
		Assert.equals( 0, content.length );
	}
	
}