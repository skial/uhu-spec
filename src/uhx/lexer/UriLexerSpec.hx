package uhx.lexer;

import uhx.mo.Token;
import utest.Assert;
import byte.ByteData;
import uhx.lexer.Uri.UriKeywords;
import uhx.parser.Uri as UriParser;

/**
 * ...
 * @author Skial Bainn
 */
class UriLexerSpec {

	public function new() {
		
	}
	
	public function parse(v:String):Array<Token<UriKeywords>> {
		return new UriParser().toTokens( ByteData.ofString( v ), 'urilexer-spec' );
	}
	
	public function filter(a:Array<Token<UriKeywords>>) {
		var r = [];
		for (t in a) switch t {
			case Keyword(Path(ts)):
				r = r.concat( filter( ts ) );
			case _:
				r.push( t );
		}
		return r;
	}
	
	public var v:Array<Token<UriKeywords>>;
	public var e:String;
	
	/**
	 * Tests based on jsuri
	 * @link http://code.google.com/p/jsuri/
	 */
	
	public function testURL_empty() {
		e = '';
		v = parse( e );
		Assert.equals(0, v.length);
	}
	
	public function testURL_slash() {
		e = '/';
		v = parse( e );
		Assert.equals( 0, v.length );
	}
	
	public function testURL_trailing_slash() {
		e = 'tutorial1/';
		v = parse( e );
		Assert.isTrue( v[0].match( Keyword(Directory('tutorial1')) ) );
	}
	
	public function testURL_rel_path() {
		e = '/experts/';
		v = parse( e );
		Assert.isTrue( v[0].match( Keyword(Directory('experts')) ) );
	}
	
	public function testURL_rel_file_leading_slash() {
		e = '/index.html';
		v = parse( e );
		trace( v );
		Assert.isTrue( v[0].match( Keyword(File('index')) ) );
		Assert.isTrue( v[1].match( Keyword(Extension('html')) ) );
	}
	
	public function testURL_rel_dir_file() {
		e = 'tutorial2/index.html';
		v = parse( e );
		trace( v );
		Assert.isTrue( v[0].match( Keyword(Directory('tutorial2')) ) );
		Assert.isTrue( v[1].match( Keyword(File('index')) ) );
		Assert.isTrue( v[2].match( Keyword(Extension('html')) ) );
	}
	
	public function testURL_rel_parent_dir() {
		e = '../';
		v = parse( e );
		trace( v );
		Assert.isTrue( v[0].match( Keyword(Directory('../')) ) );
	}
	
	public function testURL_rel_grandparents_dir() {
		e = '../../../';
		v = parse( e );
		trace( v );
		Assert.isTrue( v[0].match( Keyword(Directory('../')) ) );
		Assert.isTrue( v[1].match( Keyword(Directory('../')) ) );
		Assert.isTrue( v[2].match( Keyword(Directory('../')) ) );
	}
	
	public function testURL_rel_current_dir() {
		e = './';
		v = parse( e );
		trace( v );
		Assert.equals( 0, v.length );
	}
	
	public function testURL_rel_current_dir_doc() {
		e = './index.html';
		v = parse( e );
		trace( v );
		Assert.isTrue( v[0].match( Keyword(File('index')) ) );
		Assert.isTrue( v[1].match( Keyword(Extension('html')) ) );
	}
	
	public function testURL_3_level_domain() {
		e = 'www.example.com';
		v = parse( e );
		trace( v );
		Assert.isTrue( v[0].match( Keyword(Host('www.example.com')) ) );
	}
	
	public function testURL_absolute_url() {
		e = 'http://www.example.com/index.html';
		v = parse( e );
		trace( v );
		Assert.equals( 4, v.length );
		Assert.isTrue( v[0].match( Keyword(Scheme('http')) ) );
		Assert.isTrue( v[1].match( Keyword(Host('www.example.com')) ) );
		Assert.isTrue( v[2].match( Keyword(File('index')) ) );
		Assert.isTrue( v[3].match( Keyword(Extension('html')) ) );
	}
	
	public function testURL_absolute_url_secure() {
		e = 'https://www.example.com/index.html';
		v = parse( e );
		trace( v );
		Assert.isTrue( v[0].match( Keyword(Scheme('https')) ) );
		Assert.isTrue( v[1].match( Keyword(Host('www.example.com')) ) );
		Assert.isTrue( v[2].match( Keyword(File('index')) ) );
		Assert.isTrue( v[3].match( Keyword(Extension('html')) ) );
	}
	
	public function testURL_absolute_url_port() {
		e = 'http://www.example.com:8080/index.html';
		v = parse( e );
		trace( v );
		Assert.isTrue( v[0].match( Keyword(Scheme('http')) ) );
		Assert.isTrue( v[1].match( Keyword(Host('www.example.com')) ) );
		Assert.isTrue( v[2].match( Keyword(Port('8080')) ) );
		Assert.isTrue( v[3].match( Keyword(File('index')) ) );
		Assert.isTrue( v[4].match( Keyword(Extension('html')) ) );
	}
	
	public function testURL_absolute_url_secure_port() {
		e = 'https://www.example.com:4433/index.html';
		v = parse( e );
		trace( v );
		Assert.isTrue( v[2].match( Keyword(Port('4433')) ) );
		Assert.isTrue( v[3].match( Keyword(File('index')) ) );
		Assert.isTrue( v[4].match( Keyword(Extension('html')) ) );
	}
	
	public function testURL_rel_path_hash() {
		e = '/index.html#about';
		v = parse( e );
		trace( v );
		Assert.isTrue( v[0].match( Keyword(File('index')) ) );
		Assert.isTrue( v[1].match( Keyword(Extension('html')) ) );
		Assert.isTrue( v[2].match( Keyword(Fragment('about')) ) );
	}
	
	public function testURL_absolute_path_hash() {
		e = 'http://www.example.com/index.html#about';
		v = parse( e );
		trace( v );
		Assert.isTrue( v[4].match( Keyword(Fragment('about')) ) );
	}
	
	public function testURL_rel_path_query() {
		e = '/index.html?aa=11&bb=22';
		v = parse( e );
		trace( v );
		Assert.isTrue( v[2].match( Keyword(Query('aa', '11')) ) );
		Assert.isTrue( v[3].match( Keyword(Query('bb', '22')) ) );
	}
	
	public function testURL_absolute_path_query() {
		e = 'http://www.test.com/index.html?a=1&b=2';
		v = parse( e );
		trace( v );
		Assert.isTrue( v[4].match( Keyword(Query('a', '1')) ) );
		Assert.isTrue( v[5].match( Keyword(Query('b', '2')) ) );
	}
	
	public function testURL_absolute_path_query_hash() {
		e = 'http://www.test.com/index.html?a=1&b=2#a';
		v = parse( e );
		trace( v );
		Assert.isTrue( v[4].match( Keyword(Query('a', '1')) ) );
		Assert.isTrue( v[5].match( Keyword(Query('b', '2')) ) );
		Assert.isTrue( v[6].match( Keyword(Fragment('a')) ) );
	}
	
	public function testURL_multi_synonymous_query() {
		e = 'http://www.test.com/index.html?arr=1&arr=2&arr=3&arr=3&b=2';
		v = parse( e );
		trace( v );
		Assert.isTrue( v[4].match( Keyword(Query('arr', '1')) ) );
		Assert.isTrue( v[5].match( Keyword(Query('arr', '2')) ) );
		Assert.isTrue( v[6].match( Keyword(Query('arr', '3')) ) );
		Assert.isTrue( v[7].match( Keyword(Query('arr', '3')) ) );
		Assert.isTrue( v[8].match( Keyword(Query('b', '2')) ) );
	}
	
	public function testURL_blank_query() {
		e = 'http://www.test.com/index.html?arr=1&arr=2';
		v = parse( 'http://www.test.com/index.html?arr=1&arr=&arr=2' );
		trace( v );
		Assert.isTrue( v[4].match( Keyword(Query('arr', '1')) ) );
		Assert.isTrue( v[5].match( Keyword(Query('arr', '')) ) );
		Assert.isTrue( v[6].match( Keyword(Query('arr', '2')) ) );
	}
	
	public function testURL_missing_scheme() {
		e = '//www.test.com/';
		v = parse( e );
		trace( v );
		Assert.equals( 1, v.length );
		Assert.isTrue( v[0].match( Keyword(Host( 'www.test.com' )) ) );
	}
	
	public function testURL_path_query() {
		e = '/contacts?name=m';
		v = parse( e );
		trace( v );
		Assert.isTrue( v[0].match( Keyword(Directory('contacts')) ) );
		Assert.isTrue( v[1].match( Keyword(Query('name', 'm')) ) );
	}
	
	public function testURL_scheme_auth_host_port() {
		e = 'http://me:here@test.com:81/this/is/a/path';
		v = parse( e );
		trace( v );
		Assert.equals( 8, v.length );
		Assert.isTrue( v[1].match( Keyword(Auth('me', 'here')) ) );
		Assert.isTrue( v[2].match( Keyword(Host('test.com')) ) );
		Assert.isTrue( v[3].match( Keyword(Port('81')) ) );
		Assert.isTrue( v[7].match( Keyword(Directory('path')) ) );
	}
	
	/*public function testURL_replace_scheme() {
		e = 'https://test.com';
		v = new Uri( 'http://test.com' );
		v.scheme = 'https';
		Assert.equals(e, v.toString());
	}
	
	public function testURL_replace_scheme_colon() {
		e = 'https://test.com';
		v = new Uri( 'http://test.com' );
		v.scheme = 'https:';
		Assert.equals(e, v.toString());
	}
	
	public function testURL_scheme_removed() {
		e = '//test.com';
		v = new Uri( 'http://test.com' );
		v.scheme = '';
		Assert.equals(e, v.toString());
	}
	
	public function testURL_add_username_password() {
		e = 'http://username:pass@test.com';
		v = new Uri( 'http://test.com' );
		v.username = 'username';
		v.password = 'pass';
		Assert.equals(e, v.toString());
	}
	
	public function testURL_add_hostname_rel_path() {
		e = 'wherever.com/index.html';
		v = new Uri( '/index.html' );
		v.hostname = 'wherever.com';
		Assert.equals(e, v.toString());
	}
	
	public function testURL_change_hostname() {
		e = 'http://wherever.com';
		v = new Uri( 'http://test.com' );
		v.hostname = 'wherever.com';
		Assert.equals(e, v.toString());
	}
	
	public function testURL_try_add_port() {
		e = '/index.html';
		v = new Uri( '/index.html' );
		v.port = '8080';
		Assert.equals(e, v.toString());
	}
	
	public function testURL_add_port() {
		e = 'http://test.com:8080';
		v = new Uri( 'http://test.com' );
		v.port = '8080';
		Assert.equals(e, v.toString());
	}
	
	public function testURL_add_path() {
		e = 'test.com/some/article.html';
		v = new Uri( 'test.com' );
		v.path = '/some/article.html';
		Assert.equals(e, v.toString());
	}
	
	public function testURL_delete_path() {
		e = 'http://test.com';
		v = new Uri( 'http://test.com/index.html' );
		v.path = '';
		Assert.equals(e, v.toString());
	}
	
	public function testURL_add_query_to_nothing() {
		e = '?this=that&something=else';
		v = new Uri( '' );
		v.query.set('this', ['that']);
		v.query.set('something', ['else']);
		Assert.equals(e, v.toString());
	}
	
	public function testURL_add_query_to_rel_path() {
		e = '/some/file.html?this=that&something=else';
		v = new Uri( '/some/file.html' );
		v.query.set('this', ['that']);
		v.query.set('something', ['else']);
		Assert.equals(e, v.toString());
	}
	
	public function testURL_add_query_to_domain() {
		e = 'test.com/?this=that&something=else';
		v = new Uri( 'test.com' );
		v.query.set('this', ['that']);
		v.query.set('something', ['else']);
		Assert.equals(e, v.toString());
	}
	
	public function testURL_swap_query() {
		e = 'www.test.com/?this=that&something=else';
		v = new Uri( 'www.test.com?this=that&a=1&b=2;c=3' );
		v.query.remove('a');
		v.query.remove('b');
		v.query.set('something', ['else']);
		Assert.equals(e, v.toString());
	}
	
	public function testURL_delete_query() {
		e = 'www.test.com';
		v = new Uri( 'www.test.com?this=that&a=1&b=2;c=3' );
		v.query.remove('a');
		v.query.remove('b');
		v.query.remove('this');
		
		Assert.equals(e, v.toString());
	}
	
	public function testURL_add_fragment() {
		e = 'test.com/#content';
		v = new Uri( 'test.com' );
		v.fragment = 'content';
		Assert.equals(e, v.toString());
	}
	
	public function testURL_add_fragment_with_prefix() {
		e = 'test.com/#content';
		v = new Uri( 'test.com' );
		v.fragment = '#content';
		Assert.equals(e, v.toString());
	}
	
	public function testURL_add_fragment_to_path() {
		e = 'a/b/c/123.html#content';
		v = new Uri( 'a/b/c/123.html' );
		v.fragment = 'content';
		Assert.equals(e, v.toString());
	}
	
	public function testURL_change_fragment() {
		e = 'a/b/c/123.html#about';
		v = new Uri( 'a/b/c/123.html#content' );
		v.fragment = 'about';
		Assert.equals(e, v.toString());
	}
	
	public function testURL_delete_fragment() {
		e = 'a/b/c/123.html';
		v = new Uri( 'a/b/c/123.html#content' );
		v.fragment = '';
		Assert.equals(e, v.toString());
	}
	
	public function testURL_query_missing_value() {
		e = 'test.com/';
		v = new Uri( 'test.com/?11=' );
		Assert.equals(e, v.toString());
	}
	
	public function testURL_query_no_equal_in_original() {
		e = 'test.com/';
		v = new Uri( 'test.com/?11' );
		Assert.equals(e, v.toString());
	}*/
	
}