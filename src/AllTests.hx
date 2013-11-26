package ;

// Target specific imports first
#if js
//import uhx.tem.TemSpec;
#end

//import uhx.sys.EdeSpec;	// TODO Need to setup new project with hooks Ede into Klas.
//import uhx.sys.LiySpec;
//import uhx.sys.LodSpec;

//import uhx.macro.WaitSpec;
import uhx.macro.YieldSpec;
//import uhx.macro.NamedArgsSpec;

//import haxe.Utf8Spec;
//import uhx.web.URISpec;
//import uhx.fmt.ASCIISpec;
//import uhx.oauth.GithubSpec;
//import uhx.http.RequestSpec;

/*#if sys
import uhx.oauth.OAuth10aSpec;
#end

import uhx.crypto.Base64Spec;
import uhx.crypto.HMACSpec;
import uhx.crypto.MD5Spec;*/

import utest.Runner;
import utest.ui.Report;
import utest.TestHandler;

/**
 * ...
 * @author Skial Bainn
 */

#if !disable_macro_tests
//@:build( MacroTests.run() )
#end
class AllTests {
	
	public static function main() {	
		
		var runner = new Runner();
		
		//runner.addCase( new ASCIISpec() );
		
		/*#if !js
		runner.addCase( new Utf8Spec() );
		#end
		
		runner.addCase( new Base64Spec() );
		runner.addCase( new MD5Spec() );
		runner.addCase( new HMACSpec() );
		
		runner.addCase( new URISpec() );
		
		#if sys
		
		//runner.addCase( new OAuth10aSpec() );
		
		#end*/
		
		// Github OAuth Tests
		//runner.addCase( new GithubSpec() );
		
		#if js
		//runner.addCase( new TemSpec() );
		#end
		
		//runner.addCase( new WaitSpec() );
		runner.addCase( new YieldSpec() );
		//runner.addCase( new NamedArgsSpec() );	// TODO Move underlying macro to its own repo.
		
		//runner.addCase( new RequestSpec() );
		//runner.addCase( new LodSpec() );
		//runner.addCase( new LiySpec() );
		//runner.addCase( new EdeSpec() );	// TODO Need to setup new project with hooks Ede into Klas.
		
		Report.create( runner );
		
		#if !macro
		Console.start();
		#end
		
		runner.run();
		
	}
	
}