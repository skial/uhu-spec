package uhx.mt;

import MediaType;
import utest.Assert;

/**
 * ...
 * @author Skial Bainn
 */
class MediaTypeSpec {

	public function new() {
		
	}
	
	public function testFromString() {
		var mt:MediaType = 'text/plain';
		
		Assert.equals( 'text', mt.toplevel );
		Assert.equals( 'plain', mt.subtype );
		Assert.isTrue( mt.isText() );
		Assert.isNull( mt.suffix );
		Assert.isNull( mt.parameters );
		Assert.equals( 'text/plain', '$mt' );
	}
	
	public function testSuffix() {
		var mt:MediaType = 'text/plain+xml';
		
		Assert.equals( 'xml', mt.suffix );
		Assert.isTrue( mt.isXml() );
		Assert.isFalse( mt.isJson() );
	}
	
	public function testParameter() {
		var mt:MediaType = 'text/plain; charset=UTF-8';
		var params = mt.parameters;
		
		Assert.isTrue( params != null );
		Assert.isTrue( params.exists( 'charset' ) );
		Assert.equals( 'UTF-8', params.get( 'charset' ) );
	}
	
	public function testMultParameters() {
		var mt:MediaType = 'text/plain; charset=UTF-8; name=value; hello=world';
		var params = mt.parameters;
		
		Assert.isTrue( params != null );
		Assert.isTrue( params.exists( 'charset' ) );
		Assert.isTrue( params.exists( 'name' ) );
		Assert.isTrue( params.exists( 'hello' ) );
		Assert.equals( 'UTF-8', params.get( 'charset' ) );
		Assert.equals( 'value', params.get( 'name' ) );
		Assert.equals( 'world', params.get( 'hello' ) );
	}
	
	public function testTree() {
		var mt:MediaType = 'text/vnd.a.b.1.2';
		
		Assert.isTrue( mt.isVendor() );
		Assert.isFalse( mt.isPersonal() );
		Assert.isFalse( mt.isVanity() );
		Assert.isFalse( mt.isStandard() );
		Assert.isFalse( mt.isUnregistered() );
		Assert.equals( 'vnd.a.b.1.2', mt.tree );
	}
	
}