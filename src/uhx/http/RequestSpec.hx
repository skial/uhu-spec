package uhx.http;

import haxe.Json;
import haxe.Timer;
import utest.Assert;
//import uhx.http.impl.e.EStatus;
//import uhx.http.impl.e.EMethod;
import uhx.http.Status;
import uhx.http.Header;
import taurine.io.Uri;
import uhx.http.Message;

import uhx.http.impl.c.PreparedRequest;
import uhx.http.impl.c.PreparedResponse;

using Requests;

/**
 * ...
 * @author Skial Bainn
 */

class RequestSpec implements Klas {
	
	/**
	 * All url's have to accept cross origin requests, which is required
	 * by Javascript, so the tests have a chance to succeed. 
	 * \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \
	 * 		Start a local server you idiot.
	 * 			nekotools server -p 80
	 * 			----------or----------
	 * 			http-server -p 8080
	 * / / / / / / / / / / / / / / / / / / / / /
	 */
	
	public function new() {
		
	}
	
	public function testGET() {
		var url = 'http://httpbin.org/ip';
		
		@:wait Requests.get( url, Assert.createEvent( [response], 1000 ) );
		
		Assert.equals( 200, response.code );
		Assert.equals( EStatus.OK, response.status );
		
		// All header keys are forced to lower case
		Assert.isFalse( response.headers.exists('Content-Type') );
		Assert.isTrue( response.headers.exists('content-type') );
		Assert.equals( url, response.url.toString() );
	}
	
	public function testPOST_obj_inline() {
		var url = 'http://httpbin.org/post';
		
		@:wait Requests.post( url, Assert.createEvent( [response], 1000 ), data = { a:1, b:2 } );
		
		var json = Json.parse( response.text );
		
		Assert.equals( 1, json.form.a );
		Assert.equals( 2, json.form.b );
		Assert.equals( 200, response.code );
		Assert.equals( EStatus.OK, response.status );
		Assert.equals( url, response.url.toString() );
	}
	
	public function testPOST_obj_ref() {
		var url = 'http://httpbin.org/post';
		var data = { a:1, b:2 };
		
		@:wait Requests.post( url, Assert.createEvent( [response], 1000 ), data = data );
		
		var json = Json.parse( response.text );
		
		Assert.equals( 1, json.form.a );
		Assert.equals( 2, json.form.b );
		Assert.equals( 200, response.code );
	}
	
	public function testPOST_str_inline() {
		var url = 'http://httpbin.org/post';
		
		@:wait Requests.post( url, Assert.createEvent( [response], 1000 ), data = 'a=1&b=2' );
		
		var json = Json.parse( response.text );
		
		Assert.equals( 1, json.form.a );
		Assert.equals( 2, json.form.b );
		Assert.equals( 200, response.code );
	}
	
	public function testPOST_str_ref() {
		var url = 'http://httpbin.org/post';
		var data = 'a=1&b=2';
		@:wait Requests.post( url, Assert.createEvent( [response], 1000 ), data = data );
		
		var json = Json.parse( response.text );
		
		Assert.equals( 1, json.form.a );
		Assert.equals( 2, json.form.b );
		Assert.equals( 200, response.code );
	}
	
	public function testHeaders_read() {
		var url = 'http://httpbin.org/headers';
		
		@:wait Requests.get( url, Assert.createEvent( [response], 1000 ) );
		
		var json = Json.parse( response.text );
		
		Assert.equals( 200, response.code );
		Assert.equals( EStatus.OK, response.status );
		Assert.equals( 'httpbin.org', Reflect.field( json.headers, 'Host' ) );
		Assert.isTrue( response.headers.exists('content-type') );
		Assert.equals( 'application/json', response.headers.get('content-type') );
	}
	
	// I need to setup a local server using a host alias which can handle all these tests
	// instead of httpbin.org. Javascript can only access same origin cookies.
	#if sys
	public function testCookies_read() {
		//var url = 'http://httpbin.org/cookies/set?fname=skial&lname=bainn';
		var url = 'http://httpbin.org/cookies';
		
		@:wait Requests.get( url, Assert.createEvent( [response], 1000 ) , cookies = [ { fname:'skial' }, { lname:'bainn' } ] );
		
		Assert.equals( 200, response.code );
		Assert.isTrue( response.cookies.exists( 'fname' ) );
		Assert.isTrue( response.cookies.exists( 'lname' ) );
	}
	#end
	
}