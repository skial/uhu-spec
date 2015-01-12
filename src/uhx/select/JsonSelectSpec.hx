package uhx.select;

import utest.Assert;

using uhx.select.Json;

/**
 * ...
 * @author Skial Bainn
 */
class JsonSelectSpec {

	public var level1:Dynamic;
	public var level2:Dynamic;
	public var level3:Dynamic;
	
	public function new() {
		level1 = haxe.Json.parse( haxe.Resource.getString('l1basic.json') );
		level2 = haxe.Json.parse( haxe.Resource.getString('l2sibling.json') );
		level3 = haxe.Json.parse( haxe.Resource.getString('l3basic.json') );
	}
	
	public function testLevel1_id() {
		var m = level1.find('.favoriteColor');
		
		Assert.equals( 1, m.length );
		Assert.equals( 'yellow', m[0] );
	}
	
	private function testLevel1_multipleId() {
		var m = level1.find('.language');
		
		Assert.equals( 3, m.length );
		Assert.equals( 'Bulgarian', m[0] );
		Assert.equals( 'English', m[1] );
		Assert.equals( 'Spanish', m[2] );
	}
	
	private function testLevel1_typeWithId() {
		var m = level1.find('string.favoriteColor');
		
		Assert.equals( 1, m.length );
		Assert.equals( 'yellow', m[0] );
	}
	
	public function testLevel1_grouping() {
		var m = level1.find('string.level,number');
		
		Assert.equals( 4, m.length );
		Assert.equals( 'advanced', m[0] );
		Assert.equals( 172, m[3] );
	}
	
	public function testLevel1_typeString() {
		var m = level1.find('string');
		
		Assert.equals( 14, m.length );
		Assert.equals( 'Lloyd', m[0] );
		Assert.equals( 'English', m[5] );
		Assert.equals( 'window', m[9] );
		Assert.equals( 'wine', m[13] );
	}
	
	public function testLevel1_typeNumber() {
		var m = level1.find('number');
		
		Assert.equals( 1, m.length );
		Assert.equals( 172, m[0] );
	}
	
	public function testLevel1_typeObject() {
		var m = level1.find('object');
		
		Assert.equals( 5, m.length );
		Assert.equals( 
			haxe.Json.stringify( { first:'Lloyd', last:'Hilaiel' } ),
			haxe.Json.stringify( m[0] )
		);
		Assert.equals( 
			haxe.Json.stringify( { language:'Spanish', level:'beginner' } ),
			haxe.Json.stringify( m[3] )
		);
	}
	
	public function testLevel1_universal() {
		var m = level1.find('*');
		
		Assert.equals( 23, m.length );
		Assert.equals( 'Lloyd', m[0] );
		Assert.equals( 
			haxe.Json.stringify( { first:'Lloyd', last:'Hilaiel' } ),
			haxe.Json.stringify( m[2] )
		);
		Assert.equals( 'advanced', m[5] );
		Assert.equals( 'native', m[8] );
		Assert.equals( 'beginner', m[11] );
		Assert.equals( 3, m[13].length );
		Assert.equals( 2, m[16].length );
		Assert.equals( 3, m[20].length );
		Assert.equals( 172, m[21] );
		Assert.equals( haxe.Json.stringify(level1), haxe.Json.stringify(m[22]) );
	}
	
	public function testLevel1_pseudoRoot() {
		var m = level1.find(':root');
		
		Assert.equals( 1, m.length );
		Assert.equals( haxe.Json.stringify(level1), haxe.Json.stringify(m[0]) );
	}
	
	public function testLevel1_pseudoFirstChild() {
		var m = level1.find('string:first-child');
		
		Assert.equals( 2, m.length );
		Assert.equals( 'window', m[0] );
		Assert.equals( 'beer', m[1] );
	}
	
	public function testLevel1_pseudoLastChild() {
		var m = level1.find('string:last-child');
		
		Assert.equals( 2, m.length );
		Assert.equals( 'aisle', m[0] );
		Assert.equals( 'wine', m[1] );
	}
	
	public function testLevel1_pseudoNthChild1() {
		var m = level1.find('string:nth-child(odd)');
		
		Assert.equals( 3, m.length );
		Assert.equals( 'window', m[0] );
		Assert.equals( 'beer', m[1] );
		Assert.equals( 'wine', m[2] );
	}
	
	public function testLevel1_pseudoNthChild2() {
		var m = level1.find('string:nth-child(-n+2)');
		
		Assert.equals( 4, m.length );
		Assert.equals( 'window', m[0] );
		Assert.equals( 'aisle', m[1] );
		Assert.equals( 'beer', m[2] );
		Assert.equals( 'whiskey', m[3] );
	}
	
	public function testLevel2_unrooted() {
		var m = level2.find('.a ~ .b');
		
		Assert.equals( 3, m.length );
		Assert.equals( 2, m[0] );
		Assert.equals( 4, m[1] );
		Assert.equals( 6, m[2] );
	}
	
	public function testLevel2_descendantOf() {
		var m = level2.find(':root .a ~ .b');
		
		Assert.equals( 3, m.length );
		Assert.equals( 2, m[0] );
		Assert.equals( 4, m[1] );
		Assert.equals( 6, m[2] );
	}
	
	public function testLevel2_childOf() {
		var m = level2.find(':root > .a ~ .b');
		
		Assert.equals( 1, m.length );
		Assert.equals( 2, m[0] );
	}
	
	public function testLevel3_has() {
		var m = level3.find('.languagesSpoken object:has(.language)');
		
		Assert.equals( 3, m.length );
		Assert.equals( 'Bulgarian', m[0].language );
		Assert.equals( 'English', m[1].language );
		Assert.equals( 'Spanish', m[2].language );
	}
	
	public function testLevel3_hasWhitespace() {
		var m = level3.find('.languagesSpoken object:has       (       .language       ) ');
		
		Assert.equals( 3, m.length );
		Assert.equals( 'Bulgarian', m[0].language );
		Assert.equals( 'English', m[1].language );
		Assert.equals( 'Spanish', m[2].language );
	}
	
	public function testLevel3_hasRootInExpr() {
		var m = level3.find(':has(:root > .first)');
		
		Assert.equals( 1, m.length );
		Assert.equals( 'Lloyd', m[0].first );
		Assert.equals( 'Hilaiel', m[0].last );
	}
	
	/*public function testLevel3_hasComma() {
		var m = level3.find(':has(:root > .language, :root > .last)');
		//untyped console.log( m );
	}*/
	
}