package example.macroExprFails;

/**
 * ...
 * @author Skial Bainn
 */
@:build( example.macroExprFails.Build.build() )
class Main {

	public static function main() {
		@:meta1 Foo.bar( 'Hello World', blah = halb );
	}
	
}