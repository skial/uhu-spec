package uhx.lexer;

import haxe.io.Eof;
import utest.Assert;
import uhx.mo.Token;
import byte.ByteData;
import uhx.lexer.Hxml;

/**
 * ...
 * @author Skial Bainn
 */
class HxmlLexerSpec {

	public var lexer:Hxml;
	
	public function new() {
		
	}
	
	public function parse(value:String):Array<Section> {
		lexer = new Hxml( ByteData.ofString( value ), 'hxml-spec' );
		
		try while (true) {
			lexer.token( Hxml.root );
			
		} catch (e:Eof) { } catch (e:Dynamic) {
			trace( e );
		}
		
		return lexer.sections;
	}
	
	public function testSimple() {
		var sections = parse( '-cp src\n-main Main\n-neko bin/main.n' );
		
		Assert.equals( 1, sections.length );
		
		var section = sections[0];
		
		Assert.isTrue( section.keys.exists( SourcePath ) );
		Assert.isTrue( section.keys.exists( Main ) );
		Assert.isTrue( section.keys.exists( Neko ) );
		Assert.isFalse( section.keys.exists( DeadCode ) );
		
		Assert.contains( 'src', section.knowns.get( SourcePath ) );
		Assert.contains( 'Main', section.knowns.get( Main ) );
		Assert.contains( 'bin/main.n', section.knowns.get( Neko ) );
		
	}
	
	public function testNext() {
		var sections = parse( '-cp src\n-main Main\n-neko bin/main.n\n--next\n-cp src\n-main Main\n-cs bin/cs' );
		
		Assert.equals( 2, sections.length );
		
		for (i in 0...sections.length) {
			var section = sections[i];
			Assert.isTrue( section.keys.exists( SourcePath ) );
			Assert.isTrue( section.keys.exists( Main ) );
			Assert.isTrue( section.keys.exists( i==0?Neko:Cs ) );
			
			Assert.contains( 'src', section.knowns.get( SourcePath ) );
			Assert.contains( 'Main', section.knowns.get( Main ) );
			Assert.contains( i == 0?'bin/main.n': 'bin/cs', section.knowns.get( i==0?Neko:Cs ) );
			
		}
	}
	
	public function testEach() {
		var sections = parse( '-D name=skial\n-D NET_35\n--each\n-cp src\n-main Main\n-neko bin/main.n\n--next\n-cp src\n-main Main\n-cs bin/cs' );
		
		Assert.equals( 3, sections.length );
		
		for (i in 0...sections.length) {
			var section = sections[i];
			Assert.equals( i + 1, section.index );
			Assert.equals( i == 0 ? -1 : 1, section.inherit );
			
			if (i == 0) {
				Assert.isTrue( section.keys.exists( Define ) );
				Assert.equals( 2, section.knowns.get( Define ).length );
				Assert.equals( 'name=skial', section.knowns.get( Define )[0] );
				Assert.equals( 'NET_35', section.knowns.get( Define )[1] );
				
			} else {
				Assert.isTrue( section.keys.exists( SourcePath ) );
				Assert.isTrue( section.keys.exists( Main ) );
				Assert.isTrue( section.keys.exists( i==1?Neko:Cs ) );
				
				Assert.contains( 'src', section.knowns.get( SourcePath ) );
				Assert.contains( 'Main', section.knowns.get( Main ) );
				Assert.contains( i == 1?'bin/main.n': 'bin/cs', section.knowns.get( i==1?Neko:Cs ) );
				
			}
			
		}
	}
	
	public function testComments() {
		var sections = parse( '# A define that holds my name!\n-D name=skial\n# Pointless comment' );
		
		Assert.equals( 1, sections.length );
		
		Assert.isTrue( sections[0].keys.exists( Define ) );
		Assert.equals( 'name=skial', sections[0].knowns.get( Define )[0] );
		Assert.equals( '' + Comment(' A define that holds my name!'), '' + sections[0].unknowns[0] );
		Assert.equals( '' + Comment(' Pointless comment'), '' + sections[0].unknowns[1] );
	}
	
}