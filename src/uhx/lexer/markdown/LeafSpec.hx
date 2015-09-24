package uhx.lexer.markdown;

import byte.ByteData;
import utest.Assert;
import uhx.lexer.Markdown;

typedef Resource = {
	var md:String;
	var html:String;
}

/**
 * ...
 * @author Skial Bainn
 * Tests the processing of Leaf blocks
 */
class LeafSpec {

	public function new() {
		
	}
	
	private function load(name:String):Resource {
		return { md: haxe.Resource.getString( '$name.md' ), html: haxe.Resource.getString( '$name.html' ) };
	}
	
	/*public function testIssue19() {
		var payload = load( 'issue19' );
		var lexer = new Markdown( ByteData.ofString( payload.md ), 'issue19' );
		
	}*/
	
}