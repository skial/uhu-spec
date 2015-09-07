package uhx.types;

import utest.Assert;
import uhx.types.Uri;

/**
 * ...
 * @author Skial Bainn
 */
class UriSpec {

	public function new() {
		
	}
	
	public function testURL() {
		var uri:Uri = 'http://google.com';
		
		Assert.equals( 'http', uri.scheme );
		Assert.equals( 'google.com', uri.domain );
	}
	
	public function testPath() {
		var uri:Uri = 'path/to/a/mystical/directory!';
		
		Assert.equals( 5, uri.directories.length );
		Assert.equals( '' + ['path', 'to', 'a', 'mystical', 'directory!'], '' + uri.directories );
		Assert.equals( 'path/to/a/mystical/directory!', uri.directory );
		Assert.equals( 'path/to/a/mystical/directory!', uri.toString() );
		Assert.equals( uri.toString(), uri.directory );
	}
	
	public function testScheme_set() {
		var uri:Uri = 'http://google.com/';
		
		Assert.equals( 'http', uri.scheme );
		
		uri.scheme = 'https';
		
		Assert.equals( 'https', uri.scheme );
	}

	public function testUsername_set() {
		var uri:Uri = 'http://user:pass@security.com';
		
		Assert.equals( 'user', uri.username );
		
		uri.username = 'secure_user';
		
		Assert.equals( 'secure_user', uri.username );
	}
	
	public function testPassword_set() {
		var uri:Uri = 'http://user:pass@security.com';
		
		Assert.equals( 'pass', uri.password );
		
		uri.password = '123pass';
		
		Assert.equals( '123pass', uri.password );
	}
	
	public function testDomain_set() {
		var uri:Uri = 'http://haxe.org';
		
		Assert.equals( 'haxe.org', uri.domain );
		
		uri.domain = 'haxe.io';
		
		Assert.equals( 'haxe.io', uri.domain );
	}
	
	public function testPort() {
		var uri:Uri = 'http://google.com';
		
		Assert.equals( 80, uri.port );
		
		uri = 'http://google.com:8080';
		
		Assert.equals( 8080, uri.port );
	}
	
	public function testPort_set() {
		var uri:Uri = 'http://haxe.io';
		
		Assert.equals( 80, uri.port );
		
		uri.port = 1400;
		
		Assert.equals( 1400, uri.port );
	}
	
	public function testDirectory_set() {
		var uri:Uri = '/path/to/some/directory';
		
		Assert.equals( 4, uri.directories.length );
		Assert.equals( 'path/to/some/directory', uri.directory );
		
		uri.directory = 'path/to/a/different/directory';
		
		Assert.equals( 5, uri.directories.length );
		Assert.equals( 'path/to/a/different/directory', uri.directory );
	}
	
	public function testFilename_set() {
		var uri:Uri = '../path/file.txt';
		
		Assert.equals( 'file', uri.filename );
		
		uri.filename = 'errors';
		
		Assert.equals( 'errors', uri.filename );
	}
	
	public function testExtension_set() {
		var uri:Uri = '../path/file.txt';
		
		Assert.equals( 'txt', uri.extension );
		
		uri.extension = 'pdf';
		
		Assert.equals( 'pdf', uri.extension );
	}
	
	public function testFragment_set() {
		var uri:Uri = '../path/#frag';
		
		Assert.equals( 'frag', uri.fragment );
		
		uri.fragment = 'fragment';
		
		Assert.equals( 'fragment', uri.fragment );
	}
	
}