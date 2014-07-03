package uhx.sys;

import utest.Assert;
import help.macro.Person;

/**
 * ...
 * @author Skial Bainn
 */
class EdeSpec {

	public function new() {
		
	}
	
	public function testNotEnoughArgs() {
		Assert.raises( function() {
			var peep = new Person( ['-r', 'a', 'b'] );
		} );
	}
	
	public function testFields() {
		var peep = new Person( ['-a', '25', '--name', 'Skial Bainn', '-l', '4'] );
		
		Assert.equals(25, peep.age);
		Assert.is(peep.age, Int);
		Assert.equals('Skial Bainn', peep.name);
		Assert.equals(4, peep.limbs);
	}
	
}