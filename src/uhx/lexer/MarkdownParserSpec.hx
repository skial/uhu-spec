package uhx.lexer;

#if macro
import haxe.Json;
import haxe.macro.Compiler;
import haxe.macro.ExprTools;
import haxe.Resource;
import sys.io.File;
import sys.FileSystem;
import haxe.macro.Expr;
import haxe.macro.Context;
#end

import uhx.mo.Token;
import utest.Assert;
import byte.ByteData;
import uhx.mo.TokenDef;
import hxparse.Position;
import uhx.lexer.MarkdownLexer;
import uhx.lexer.MarkdownParser;

using Lambda;
using StringTools;

typedef Payload = {
	var md:String;
	var html:String;
}

/**
 * ...
 * @author Skial Bainn
 */
class MarkdownParserSpec {
	
	/*public static macro function loadMarkdown(name:ExprOf<String>):ExprOf<Payload> {
		var path = 'C:/Users/Skial/Dropbox/dev/skialbainn/src/uhu-spec/resources/markdown/';
		var name = ExprTools.toString( name ).replace('"', '');
		return if (FileSystem.exists('$path$name.md')) {
			Context.addResource( '$name.md', File.getBytes( '$path$name.md' ) );
			Context.addResource( '$name.html', File.getBytes( '$path$name.html' ) );
			//var txt = File.getContent( '$path$name.md' );
			//var txt = haxe.Resource.getString( '$name.md' );
			//var html = File.getContent( '$path$name.html' );
			//var html = haxe.Resource.getString( '$name.html' );
			//macro { md:$v { txt }, html:$v { html } };
			macro { md:haxe.Resource.getString( $v{'$name.md'} ), html:haxe.Resource.getString( $v{'$name.html'} ) };
		} else {
			macro { md:'failed', html:'failed' };
		}
	}*/

	public function new() {
		
	}
	
	private function escape(v:String):String {
		return v.replace('\r', '\\r').replace('\n', '\\n').replace('\t', '\\t').replace(' ', '\\s');
	}
	/*
	private function toHTML(tokens:Array<Token<MarkdownKeywords>>):String {
		var result = new StringBuf();
		var parser = new MarkdownParser();
		
		var inParagraph = false;
		var crlf = 0;
		
		for (token in tokens) {
			switch (token.token) {
				case Carriage, Newline:
					crlf++;
					if (crlf == 4 && inParagraph) {
						result.add('</p>\r\n\r\n');
						inParagraph = false;
						crlf = 0;
					}
					
				case Keyword(Header(_, _, _)): 
					if (inParagraph) {
						result.add('</p>\r\n\r\n');
						inParagraph = false;
					}
					
				case Const(CString(_)):
					if (!inParagraph) {
						result.add('<p>');
						inParagraph = true;
					}
					
				case _:
			}
			
			result.add(parser.printHTML( token ));
		}
		
		if (inParagraph) {
			result.add('</p>');
			inParagraph = false;
		}
		
		return result.toString();
	}
	
	private function toMarkdown(tokens:Array<Token<MarkdownKeywords>>):String {
		var result = new StringBuf();
		var parser = new MarkdownParser();
		
		for (token in tokens) result.add(parser.printString( token ));
		
		return result.toString();
	}
	*/
	public function testBlockElements_paragraph() {
		//var payload = loadMarkdown( 'be_paragraph' );
		var payload = { md:haxe.Resource.getString('be_paragraph.md'), html:haxe.Resource.getString('be_paragraph.html') };
		var md = payload.md;
		var html = payload.html;
		
		var parser = new MarkdownParser();
		var tokens = parser.toTokens( ByteData.ofString( md ), 'md-be_paragraph' );
		
		//untyped console.log( tokens );
		
		Assert.equals( 2, tokens.length );
		
		switch(tokens[1].token) {
			case Keyword(Paragraph(toks)):
				var filtered = toks.filter( function(t) return switch(t.token) {
					case Const(_), Space(_), Tab(_), Dot, Hyphen(_), Carriage, Newline: false;
					case _: true;
				} );
				
				//untyped console.log( filtered );
				
				Assert.equals( 7, filtered.length );
				
			case _:
		}
	}
	
	public function testCode_indented() {
		//var payload = loadMarkdown( 'indent_code' );
		var payload = { md:haxe.Resource.getString('indent_code.md'), html:haxe.Resource.getString('indent_code.html') };
		var md = payload.md;
		var html = payload.html;
		
		var parser = new MarkdownParser();
		var tokens = parser.toTokens( ByteData.ofString( md ), 'md-indent_code' );
		
		//trace( tokens );
		
		Assert.equals( 7, tokens.length );
		
		var filtered = tokens.filter( function(t) return switch (t.token) {
			case Keyword(Code(_, _, _)): true;
			case _: false;
		} );
		
		//trace( filtered );
		
		Assert.equals( 4, filtered.length );
	}
	
	public function testBlockquote_lazy() {
		//var payload = loadMarkdown( 'lazy_blockquote' );
		var payload = { md:haxe.Resource.getString('lazy_blockquote.md'), html:haxe.Resource.getString('lazy_blockquote.html') };
		var md = payload.md;
		var html = payload.html;
		
		var parser = new MarkdownParser();
		var tokens = parser.toTokens( ByteData.ofString( md ), 'md-lazy_blockquote' );
		
		//trace( tokens );
		
		Assert.equals( 1, tokens.length );
		Assert.isTrue( switch(tokens[0].token) {
			case Keyword(Blockquote(toks)):
				Assert.equals( 1, toks.length );
				
				switch(toks[0].token) {
					case Keyword(Paragraph(toks)): 
						var filtered = toks.filter( function(t) return switch(t.token) {
							case Const(CString(_)): true;
							case _: false;
						} );
						
						//trace( filtered );
						
						Assert.equals( 3, filtered.length );
						
						true;
						
					case _: false;
				}
				
			case _: false;
		} );
	}
	
	public function testBlockquote_withCode() {
		//var payload = loadMarkdown( 'code_in_blockquote' );
		var payload = { md:haxe.Resource.getString('code_in_blockquote.md'), html:haxe.Resource.getString('code_in_blockquote.html') };
		var md = payload.md;
		var html = payload.html;
		
		var parser = new MarkdownParser();
		var tokens = parser.toTokens( ByteData.ofString( md ), 'md-code_in_blockquote' );
		
		//trace( tokens );
		
		switch (tokens[0].token) {
			case Keyword(Blockquote(toks)):
				Assert.equals( 4, toks.length );
				
				var filtered = toks.filter( function(t) return switch(t.token) {
					case Keyword(Code(_, _, _)): true;
					case _: false;
				} );
				
				//trace( filtered );
				
				Assert.equals( 2, filtered.length );
				
			case _:
		}
	}
	
	public function testBlockquote_nested() {
		//var payload = loadMarkdown( 'nested_blockquotes' );
		var payload = { md:haxe.Resource.getString('nested_blockquotes.md'), html:haxe.Resource.getString('nested_blockquotes.html') };
		var md = payload.md;
		var html = payload.html;
		
		var parser = new MarkdownParser();
		var tokens = parser.toTokens( ByteData.ofString( md ), 'md-nested_blockquotes' );
		
		//trace( escape( md ) );
		//trace( tokens );
		//untyped console.log(tokens);
		
		Assert.equals( 1, tokens.length );
		
		switch (tokens[0].token) {
			case Keyword(Blockquote(toks)):
				Assert.equals( 3, toks.length );
				
				switch (toks[1].token) {
					case Keyword(Blockquote([ { token:Keyword(Paragraph(toks)) } ])):
						var filtered = toks.filter( function(t) return switch(t.token) {
							case Const(CString(_)): true;
							case _: false;
						} );
						
						//trace( filtered );
						
						Assert.equals( 1, filtered.length );
						
					case _:
				}
				
			case _:
		}
	}
	
	public function testLists_unordered() {
		//var payload = loadMarkdown( 'unordered_lists' );
		var payload = { md:haxe.Resource.getString('unordered_lists.md'), html:haxe.Resource.getString('unordered_lists.html') };
		var md = payload.md;
		var html = payload.html;
		
		var parser = new MarkdownParser();
		var tokens = parser.toTokens( ByteData.ofString( md ), 'md-unordered_lists' );
		
		//trace( tokens );
		
		Assert.equals( 12, tokens.length );
		
		var filtered = tokens.filter( function(t) return switch (t.token) {
			case Keyword(Collection(_, _)): true;
			case _: false;
		} );
		
		Assert.equals( 6, filtered.length );
		
		for (token in filtered) switch (token.token) {
			case Keyword(Collection(ordered, tokens)):
				Assert.isFalse( ordered );
				
				var filtered = tokens.filter( function(t) return switch(t.token) {
					case Keyword(Item(_, _)): true;
					case _: false;
				} );
				
				//trace( filtered );
				
				Assert.equals( 3, filtered.length );
				
			case _:
		}
	}
	
	public function testLists_ordered() {
		//var payload = loadMarkdown( 'ordered_lists' );
		var payload = { md:haxe.Resource.getString('ordered_lists.md'), html:haxe.Resource.getString('ordered_lists.html') };
		var md = payload.md;
		var html = payload.html;
		
		var parser = new MarkdownParser();
		var tokens = parser.toTokens( ByteData.ofString( md ), 'md-ordered_lists' );
		
		//trace( tokens );
		//untyped console.log( tokens );
		
		Assert.equals( 8, tokens.length );
		
		var filtered = tokens.filter( function(t) return switch (t.token) {
			case Keyword(Collection(_, _)): true;
			case _: false;
		} );
		
		//untyped console.log( filtered );
		
		Assert.equals( 4, filtered.length );
		
		for (token in filtered) switch (token.token) {
			case Keyword(Collection(ordered, tokens)):
				Assert.isTrue( ordered );
				
				var filtered = tokens.filter( function(t) return switch(t.token) {
					case Keyword(Item(_, _)): true;
					case _: false;
				} );
				
				//trace( filtered );
				//untyped console.log( filtered );
				
				Assert.equals( 3, filtered.length );
				
			case _:
		}
	}
	
	public function testLists_multi_paragraphs() {
		//var payload = loadMarkdown( 'list_paragraphs' );
		var payload = { md:haxe.Resource.getString('list_paragraphs.md'), html:haxe.Resource.getString('list_paragraphs.html') };
		var md = payload.md;
		var html = payload.html;
		
		var parser = new MarkdownParser();
		var tokens = parser.toTokens( ByteData.ofString( md ), 'md-list_paragraphs' );
		
		//trace( tokens );
		//untyped console.log( tokens );
		
		Assert.equals( 2, tokens.length );
		
		var expected = [ { m:1, tl:45 }, { m:2, tl:7 }, { m:3, tl:3 } ];
		
		for (token in tokens) switch (token.token) {
			case Keyword(Collection(ordered, tokens)):
				Assert.isTrue( ordered );
				Assert.equals( 3, tokens.length );
				
				for (i in 0...tokens.length) switch( tokens[i].token ) {
					case Keyword(Item(mark, tokens)):
						//untyped console.log( expected[i] );
						//untyped console.log( tokens );
						
						Assert.equals( expected[i].m, mark );
						Assert.equals( expected[i].tl, tokens.length );
						
					case _:
				}
				
			case _:
		}
	}
	
	public function testHeaders() {
		//var payload = loadMarkdown( 'headers' );
		var payload = { md:haxe.Resource.getString('headers.md'), html:haxe.Resource.getString('headers.html') };
		var md = payload.md;
		var html = payload.html;
		
		var parser = new MarkdownParser();
		var tokens = parser.toTokens( ByteData.ofString( md ), 'md-headers' );
		
		//trace( tokens );
		//untyped console.log( tokens );
		
		var filtered = tokens.filter( function(t) return switch (t.token) {
			case Keyword(Header(_, _, _)): true;
			case _: false;
		} );
		
		//trace( filtered );
		
		Assert.equals( 14, filtered.length );
		
		var expected = [ 
			{a:false, l:1, t:'H1' },
			{a:false, l:2, t:'H2' },
			{a:false, l:3, t:'H3' },
			{a:false, l:4, t:'H4' },
			{a:false, l:5, t:'H5' },
			{a:false, l:6, t:'H6' },
			{a:false, l:1, t:'H1' },
			{a:false, l:2, t:'H2' },
			{a:false, l:3, t:'H3' },
			{a:false, l:1, t:'H1' },
			{a:false, l:2, t:'H2' },
			{a:false, l:3, t:'H3' },
			{a:true, l:1, t:'H1-alt' },
			{a:true, l:2, t:'H2-alt' },
		];
		
		for (i in 0...filtered.length) switch (filtered[i].token) {
			case Keyword(Header(alt, len, text)):
				Assert.equals( expected[i].a, alt );
				Assert.equals( expected[i].l, len );
				Assert.equals( expected[i].t, text );
				
			case _:
				
		}
	}
	
	public function testHorizontalRules() {
		//var payload = loadMarkdown( 'horizontal_rules' );
		var payload = { md:haxe.Resource.getString('horizontal_rules.md'), html:haxe.Resource.getString('horizontal_rules.html') };
		var md = payload.md;
		var html = payload.html;
		
		var parser = new MarkdownParser();
		var tokens = parser.toTokens( ByteData.ofString( md ), 'md-horizontal_rules' );
		
		//trace( tokens );
		//untyped console.log( tokens );
		
		var filtered = tokens.filter( function(t) return switch (t.token) {
			case Keyword(Horizontal(_)): true;
			case _: false;
		} );
		
		Assert.equals( 5, filtered.length );
		
		var expected = ['* ', '*', '*', '- ', '-'];
		
		for (i in 0...filtered.length) switch (filtered[i].token) {
			case Keyword(Horizontal(character)):
				Assert.equals( expected[i], character );
				
			case _:
				
		}
	}
	
	public function testLinks_inline() {
		//var payload = loadMarkdown( 'inline_links' );
		var payload = { md:haxe.Resource.getString('inline_links.md'), html:haxe.Resource.getString('inline_links.html') };
		var md = payload.md;
		var html = payload.html;
		
		var parser = new MarkdownParser();
		var tokens = parser.toTokens( ByteData.ofString( md ), 'md-inline_links' );
		
		//trace( tokens );
		//untyped console.log( tokens );
		
		var expected = [
			{ text:'URL', url:'/url/', title:'' },
			{ text:'URL and title1', url:'/url/', title:'title' },
			{ text:'URL and title2', url:'/url/', title:'title preceded by two spaces' },
			{ text:'URL and title3', url:'/url/', title:'title preceded by a tab' },
			{ text:'URL and title4', url:'/url/', title:'title has spaces afterward' },
			{ text:'URL and title5', url:'/url/has space', title:'' },
			{ text:'URL and title6', url:'/url/has space/', title:'url has space and title' },
			{ text:'Empty', url:'', title:'' },
		];
		
		for (i in 0...tokens.length) switch (tokens[i].token) {
			case Keyword(Paragraph(tokens)):
				//trace( tokens );
				
				var filtered = tokens.filter( function(t) return switch(t.token) {
					case Keyword(Link(_, _, _, _)): true;
					case _: false;
				} );
				
				Assert.equals( 1, filtered.length );
				
				for (token in filtered) switch (token.token) {
					case Keyword(Link(ref, text, url, title)):
						Assert.isFalse( ref );
						Assert.equals( expected[i].text, text );
						Assert.equals( expected[i].url, url );
						Assert.equals( expected[i].title, title );
						
					case _:
				}
				
			case _:
		}
	}
	
	public function testReferenceLinks() {
		var payload = { md:haxe.Resource.getString('reference_links.md'), html:haxe.Resource.getString('reference_links.html') };
		var md = payload.md;
		var html = payload.html;
		
		var parser = new MarkdownParser();
		var tokens = parser.toTokens( ByteData.ofString( md ), 'md-reference_links' );
		
		//trace( tokens );
		//untyped console.log( tokens );
		
		var filtered = tokens.filter( function(t) return switch (t.token) {
			case Keyword(Paragraph(_)), Keyword(Code(_, _, _)): true;
			case _: false;
		} );
		
		//untyped console.log( filtered );
		
		var expected = [
			{ ref:true, text:'bar', url:'1', title:'' },
			{ ref:true, text:'bar', url:'1', title:'' },
			{ ref:true, text:'bar', url:'1', title:'' },
			{ ref:false, text:'1', url:'/url/', title:'Title' },
			// See https://github.com/skial/mo/issues/2
			//{ ref:true, text:'brackets', url:'brackets', title:'' },
			{ ref:true, text:'embedded [brackets]', url:'b', title:'' },
			{ ref:true, text:'once', url:'once', title:'' },
			{ ref:true, text:'twice', url:'twice', title:'' },
			{ ref:true, text:'thrice', url:'thrice', title:'' },
			{ ref:true, text:'four', url:'four', title:'' },
			{ ref:false, text:'once', url:'/url', title:'' },
			{ ref:false, text:'twice', url:'/url', title:'' },
			{ ref:false, text:'thrice', url:'/url', title:'' },
			{ ref:false, text:'four', url:'/url', title:'' },
			{ ref:false, text:'b', url:'/url/', title:'' },
			{ ref:true, text:'this 1', url:'this', title:'' },
			{ ref:true, text:'this 2', url:'this', title:'' },
			{ ref:true, text:'this 3', url:'this 3', title:'' },
			{ ref:true, text:'this 4', url:'this 4', title:'' },
			{ ref:true, text:'this 5', url:'this 5', title:'' },
			{ ref:true, text:'that 1', url:'that 1', title:'' },
			{ ref:true, text:'that 2', url:'that 2', title:'' },
			{ ref:true, text:'that 3', url:'that 3', title:'' },
			// See https://github.com/skial/mo/issues/2
			{ ref:true, text:'Something in brackets like [this 6][] should work', url:'Something in brackets like [this 6][] should work', title:'' },
			//{ ref:true, text:'this 6', url:'this 6', title:'' },
			//{ ref:true, text:'this 7', url:'this 7', title:'' },
			{ ref:true, text:'Same with [this 7].', url:'Same with [this 7].', title:'' },
			{ ref:false, text:'this 8', url:'/somethingelse/', title:'' },
			{ ref:false, text:'this', url:'foo', title:'' },
			{ ref:true, text:'link breaks', url:'link breaks', title:'' },
			{ ref:true, text:'link breaks', url:'link breaks', title:'' },
			{ ref:false, text:'link breaks', url:'/url/', title:'' },
			{ ref:false, text:'id', url:'http://example.com/', title:'Optional Title Here' },
		];
		
		for (i in 0...filtered.length) switch(filtered[i].token) {
			case Keyword(Paragraph(tokens)):
				
				//untyped console.log( tokens );
				
				var filtered = tokens.filter( function(t) return switch(t.token) {
					case Keyword(Link(_, _, _, _)), Keyword(Resource(_, _, _)): true;
					case _: false;
				} );
				
				var e = expected[i];
				
				//untyped console.log( filtered );
				
				switch (filtered[0].token) {
					case Keyword(Link(ref, text, url, title)):
						Assert.equals( e.ref, ref );
						Assert.equals( e.text, text );
						Assert.equals( e.url, url );
						Assert.equals( e.title, title );
						
					case Keyword(Resource(text, url, title)):
						Assert.equals( e.text, text );
						Assert.equals( e.url, url );
						Assert.equals( e.title, title );
						
					case _:
						
				}
				
			case _:
				
		}
	}
	
	public function testIssue1() {
		var payload = { md:haxe.Resource.getString('issue1.md'), html:haxe.Resource.getString('issue1.html') };
		var md = payload.md;
		var html = payload.html;
		
		var parser = new MarkdownParser();
		var tokens = parser.toTokens( ByteData.ofString( md ), 'md-issue1' );
		
		//trace( tokens );
		//untyped console.log( tokens );
		//untyped console.log( tokens.map( function(t) return new MarkdownParser().printHTML( t, ['' => { url:'', title:'' } ] ) ).join('') );
		Assert.equals( 2, tokens.length );
		
		var expected = [ { a:108, b:2 }, { a:2, b:2 } ];
		
		for (i in 0...tokens.length) switch (tokens[i].token) {
			case Keyword(Paragraph(toks)):
				//untyped console.log( expected[i] );
				
				Assert.equals( expected[i].a, toks.length );
				
				var filtered = toks.filter( function(t) return switch (t.token) {
					case Keyword(Link(_, _, _, _)), Keyword(Resource(_, _, _)): true;
					case _: false;
				} );
				
				//untyped console.log( filtered );
				
				Assert.equals( expected[i].b, filtered.length );
				
			case _:
				
		}
	}
	
	public function testIssue3() {
		var payload = { md:haxe.Resource.getString('issue3.md'), html:haxe.Resource.getString('issue3.html') };
		var md = payload.md;
		var html = payload.html;
		
		var parser = new MarkdownParser();
		var tokens = parser.toTokens( ByteData.ofString( md ), 'md-issue3' );
		
		//trace( tokens );
		//untyped console.log( tokens );
		
		var filtered = tokens.filter( function(t) return switch(t.token) {
			case Keyword(Header(_, _, _)): true;
			case _: false;
		} );
		
		Assert.equals( 6, filtered.length );
	}
	
	public function testIssue6() {
		var payload = { md:haxe.Resource.getString('issue6.md'), html:haxe.Resource.getString('issue6.html') };
		var md = payload.md;
		var html = payload.html;
		
		var parser = new MarkdownParser();
		var tokens = parser.toTokens( ByteData.ofString( md ), 'md-issue6' );
		
		//trace( tokens );
		//untyped console.log( tokens );
		
		Assert.equals( 2, tokens.length );
	}
	
	public function testIssue7() {
		var payload = { md:haxe.Resource.getString('issue7.md'), html:haxe.Resource.getString('issue7.html') };
		var md = payload.md;
		var html = payload.html;
		
		var parser = new MarkdownParser();
		var tokens = parser.toTokens( ByteData.ofString( md ), 'md-issue7' );
		
		//trace( tokens );
		//untyped console.log( tokens );
		//untyped console.log( tokens.map( function(t) return new MarkdownParser().printHTML( t, ['' => { url:'', title:'' } ] ) ).join('') );
		
		Assert.equals( 1, tokens.length );
		
		switch (tokens[0].token) {
			case Keyword(Paragraph(tokens)):
				var filtered = tokens.filter( function(t) return switch (t.token) {
					case Const(_), Tilde: true;
					case _: false;
				} );
				
				Assert.equals( 32, filtered.length );
				
				filtered = tokens.filter( function(t) return switch (t.token) {
					case Tilde: true;
					case _: false;
				} );
				
				Assert.equals( 1, filtered.length );
				
			case _:
		}
	}
	
}