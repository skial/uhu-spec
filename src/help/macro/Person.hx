package help.macro;

/**
 * An undefined Person
 */
@:cmd
@:keep
@:usage('person [options]')
class Person {
	
	/**
	 * This person is female/
	 */
	@alias('f')
	public var female:Bool = false;
	
	/**
	 * This person is male/
	 */
	@alias('m')
	public var male:Bool = false;
	
	/**
	 * The persons age.
	 */
	@alias('a')
	public var age:Int;
	
	/**
	 * The persons full name.
	 */
	@alias('n')
	public var name:String;
	
	/**
	 * How many limbs the person has.
	 */
	@alias('l')
	public function numLimbs(v:Int) {
		limbs = v;
	}
	
	public var limbs:Int;
	
	/**
	 * Does nothing.
	 */
	public function r(a:String, b:String, c:Int) {
		// nothing
	}
	
	public function new(args:Array<String>) {
		
	}
	
}