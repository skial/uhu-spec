package uhx.lexer.markdown;

import byte.ByteData;
import haxe.Resource;
import uhx.sys.HtmlEntities;
import uhx.sys.HtmlEntity;
import unifill.InternalEncoding;
import utest.Assert;
import uhx.lexer.Markdown;
import uhx.lexer.Markdown.Inline;
import uhx.lexer.Markdown.AInline;

using uhx.lexer.markdown.InlineSpec;

/**
 * ...
 * @author Skial Bainn
 */
class InlineSpec {

	public function new() {
		
	}
	
	public static function match(token:Inline, pattern:{type:AInline, tokens:Array<String>}):Bool {
		return switch (token) {
			case { type:a, tokens:b } :
				var	tokens = b.length == pattern.tokens.length;
				if( tokens ) for (i in 0...b.length) {
					if (b[i] != pattern.tokens[i]) {
						tokens = false;
						break;
					}
				}
				if (!(pattern.type == a && tokens)) trace( token );
				pattern.type == a && tokens;
				
			case _:
				false;
				
		}
	}
	
	public static function load(file:String) {
		return Resource.getString( file );
	}
	
	public function tokenize(value:String):Array<Inline> {
		var results = [];
		var markdown = new Markdown( ByteData.ofString( value ), 'commonmark-inline-spec' );
		
		try while (true) {
			results.push( markdown.token( Markdown.inlineBlocks ) );
			
		} catch (e:Dynamic) {
			
		}
		
		return results;
	}
	
	public function testNamedEntities() {
		var md = load( '286.md' );
		var tokens = tokenize( md );
		
		Assert.equals( 19, tokens.length );
		Assert.isTrue( tokens[0].match( { type:AInline.Entity, tokens:[
			InternalEncoding.fromCodePoints(HtmlEntities.entityMap.get( nbsp ))
		] } ) );
		
		Assert.isTrue( tokens[1].match( { type:AInline.Text, tokens:[ ' ' ] } ) );
		Assert.isTrue( tokens[2].match( { type:AInline.Text, tokens:[ amp.encode(true) ] } ) );
		
		Assert.isTrue( tokens[4].match( { type:AInline.Entity, tokens:[
			InternalEncoding.fromCodePoints(HtmlEntities.entityMap.get( copy ))
		] } ) );
		
		Assert.isTrue( tokens[16].match( { type:AInline.Entity, tokens:[
			InternalEncoding.fromCodePoints(HtmlEntities.entityMap.get( ClockwiseContourIntegral ))
		] } ) );
		
	}
	
	public function testDecimalEntities() {
		var md = load( '287.md' );
		var tokens = tokenize( md );
		
		Assert.equals( 9, tokens.length );
		Assert.isTrue( tokens[0].match( { type:AInline.Entity, tokens:[
			InternalEncoding.fromCodePoint( 35 )
		] } ) );
		
		Assert.isTrue( tokens[1].match( { type:AInline.Text, tokens:[ ' ' ] } ) );
		
		Assert.isTrue( tokens[2].match( { type:AInline.Entity, tokens:[
			InternalEncoding.fromCodePoint( 1234 )
		] } ) );
		
		Assert.isTrue( tokens[8].match( { type:AInline.Entity, tokens:[
			InternalEncoding.fromCodePoint( 65533 )
		] } ) );
	}
	
	public function testHexadecimalEntities() {
		var md = load( '288.md' );
		var tokens = tokenize( md );
		
		Assert.equals( 5, tokens.length );
		
		Assert.isTrue( tokens[1].match( { type:AInline.Text, tokens:[ ' ' ] } ) );
		
		Assert.isTrue( tokens[2].match( { type:AInline.Entity, tokens:[
			InternalEncoding.fromCodePoint( 3334 )
		] } ) );
		
		Assert.isTrue( tokens[3].match( { type:AInline.Text, tokens:[ ' ' ] } ) );
		
		Assert.isTrue( tokens[4].match( { type:AInline.Entity, tokens:[
			InternalEncoding.fromCodePoint( 3243 )
		] } ) );
	}
	
	public function testNonEntities() {
		var md = load( '289.md' );
		var tokens = tokenize( md );
		
		trace( tokens );
		Assert.equals( 17, tokens.length );
		
		Assert.isTrue( tokens[0].match( { type:AInline.Text, tokens:[ amp.encode(true) ] } ) );
		Assert.isTrue( tokens[1].match( { type:AInline.Text, tokens:[ nbsp ] } ) );
		
		Assert.isTrue( tokens[15].match( { type:AInline.Text, tokens:[ amp.encode(true) ] } ) );
		Assert.isTrue( tokens[16].match( { type:AInline.Text, tokens:[ 'hi?;' ] } ) );
	}
	
}