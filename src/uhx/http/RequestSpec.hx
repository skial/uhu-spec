package uhx.http;

import haxe.Json;
import haxe.Timer;
import utest.Assert;
import uhx.http.impl.e.EStatus;
import uhx.http.impl.e.EMethod;
import taurine.io.Uri;
import uhx.http.Message;

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
	 * / / / / / / / / / / / / / / / / / / / / /
	 */
	
	public var request:Request;
	//public var response:Response;
	
	public function new() {
		
	}
	
	public function testGET() {
		var url = 'http://httpbin.org/ip';
		
		@:wait Requests.get( url, Assert.createEvent( [response], 1000 ) );
		
		Assert.equals( 200, response.status_code );
		Assert.equals( EStatus.OK, response.status );
		Assert.isTrue( response.headers.exists('Content-Type') );
		Assert.isTrue( response.headers.exists('content-type') );
		Assert.equals( url, response.url.toString() );
	}
	
	public function testPOST() {
		var url = 'http://posttestserver.com/post.php';
		
		@:wait Requests.post( url, Assert.createEvent( [response], 1000 ) );
		
		Assert.equals( 200, response.status_code );
		Assert.equals( EStatus.OK, response.status );
		Assert.equals( url, response.url.toString() );
	}
	
	public function testHeaders() {
		var url = 'http://httpbin.org/headers';
		request = new Request( new Uri( url ), GET );
		//request.headers.set( 'x-content-type', 'application/json' );
		
		@:wait request.send( Assert.createEvent( [response], 1000 ) );
		
		var json = Json.parse( response.text );
		
		Assert.equals( 200, response.status_code );
		Assert.equals( EStatus.OK, response.status );
		Assert.equals( 'httpbin.org', Reflect.field( json.headers, 'Host' ) );
	}
	
}