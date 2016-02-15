package uhx.sys;

import haxe.ds.StringMap;
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
	
	public function testBool() {
		var peep = new Person( ['-m'] );
		
		Assert.isTrue( peep.male );
		Assert.isFalse( peep.female );
	}
	
	public function testBool_firstArg() {
		var peep = new Person( ['-f', '-a', '25'] );
		
		Assert.isFalse( peep.male );
		Assert.isTrue( peep.female );
		Assert.equals(25, peep.age);
	}
	
	public function testBool_lastArg() {
		var peep = new Person( ['-a', '25', '-f'] );
		
		Assert.isFalse( peep.male );
		Assert.isTrue( peep.female );
		Assert.equals(25, peep.age);
	}
	
	public function testSubcommands_sub1() {
		var boss = new SubTest( ['sub1', '-n', 'skial'] );
		
		Assert.equals( 'skial', boss.sub1.name );
		Assert.isNull( boss.sub2 );
	}
	
	public function testSubcommands_sub1Alias() {
		var boss = new SubTest( ['a', '-n', 'skial'] );
		
		Assert.equals( 'skial', boss.sub1.name );
		Assert.isNull( boss.sub2 );
	}
	
	@:access(uhx.sys.Sub3) public function testSubcommands_sub3() {
		var boss = new SubTest( ['c', '-n', 'skial'] );
		
		Assert.equals( 'skial', boss.sub3.name );
		Assert.equals( 'a', boss.sub3.a );
		Assert.equals( 'MACRO BOOM!', boss.sub3.b );
		Assert.isNull( boss.sub2 );
	}
	
}

@:cmd
class SubTest {
	
	@alias('a')
	public var sub1:Sub1;
	
	@alias('b')
	public var sub2:Sub2;
	
	@alias('c')
	public var sub3:Sub3 = Sub3.new.bind(_, 'a', var1);
	
	public function new(args:Array<String>) {
		trace( args );
		var var1 = 'MACRO BOOM!';
		@:cmd _;
	}
	
}

@:cmd
class Sub1 {
	
	@alias('n')
	public var name:String;
	
	public function new(args:StringMap<Array<Dynamic>>) {
		trace( args );
		@:cmd _;
		
	}
	
}

@:cmd
class Sub2 {
	
	@alias('n')
	public var name:String;
	
	public function new(args:StringMap<Array<Dynamic>>) {
		trace( args );
		@:cmd _;
		
	}
	
}

@:cmd
class Sub3 {
	
	@alias('n')
	public var name:String;
	
	private var a:String;
	private var b:String;
	
	public function new(args:StringMap<Array<Dynamic>>, a1:String, a2:String) {
		trace( args, a1, a2 );
		@:cmd _;
		a = a1;
		b = a2;
		
	}
	
}