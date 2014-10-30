package ;

// Target specific imports first
//#if js
//import uhx.tem.TemSpec;
//#end

#if (uhu && mo)
	import uhx.select.HtmlSelectSpec;
#end

#if (sys && tuli)
	import uhx.tuli.plugins.AtomSpec;
#end

#if detox
	import dtx.*;
#end

#if cmd
	import uhx.sys.EdeSpec;
	import uhx.sys.LiySpec;
	import uhx.sys.LodSpec;
#end

#if (uhu && klas)
	import uhx.macro.TraitSpec;
#end

#if mo
	//import uhx.lexer.HaxeParserSpec;
	import uhx.lexer.CssParserSpec;
	import uhx.lexer.HtmlLexerSpec;
	/*import uhx.select.Json;
	import uhx.select.JsonSelectSpec;
	*/
	import uhx.lexer.MarkdownParserSpec;
#end

#if klas
	#if wait
		import uhx.macro.WaitSpec;
	#end
	#if yield
		import uhx.macro.YieldSpec;
	#end
	#if named
		import uhx.macro.NamedArgsSpec;
	#end
	#if requests
		import uhx.http.RequestSpec;
	#end
#end
/*import uhx.mo.MoSpec;

//import haxe.Utf8Spec;
//import uhx.web.URISpec;
//import uhx.fmt.ASCIISpec;
//import uhx.oauth.GithubSpec;

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
		//runner.addCase( new TuliSpec() );
		//runner.addCase( new TemSpec() );
		#end
		
		#if (uhu && mo)
			runner.addCase( new HtmlSelectSpec() );
		#end
		
		// Lexer and Parser Tests
		#if mo
			//runner.addCase( new MoSpec() );
			//runner.addCase( new HaxeParserSpec() );
			runner.addCase( new MarkdownParserSpec() );
			runner.addCase( new CssParserSpec() );
			runner.addCase( new HtmlLexerSpec() );
			//runner.addCase( new JsonSelectSpec() );
		#end
		
		// Commandline Tests
		#if cmd
			runner.addCase( new LodSpec() );
			runner.addCase( new LiySpec() );
			runner.addCase( new EdeSpec() );
		#end
		
		// Experimental Build Macros
		#if klas
			#if uhu
				runner.addCase( new TraitSpec() );
			#end
			
			#if wait
				runner.addCase( new WaitSpec() );
			#end
			
			#if yield
				runner.addCase( new YieldSpec() );
			#end
			
			#if named
				runner.addCase( new NamedArgsSpec() );
			#end
			
			#if requests
				runner.addCase( new RequestSpec() );
			#end
		#end
		
		#if (sys && tuli)
			// Tuli Plugin Tests
			runner.addCase( new AtomSpec() );
		#end
		
		#if detox
			runner.addCase( new ElementManipulationSpec() );
			runner.addCase( new CollectionSpec() );
			/*runner.addCase( new TraversingSpec() );
			runner.addCase( new DOMManipulationSpec() );
			runner.addCase( new CollectionElementManipulationSpec() );
			runner.addCase( new CollectionTraversingSpec() );
			runner.addCase( new ToolsSpec() );
			runner.addCase( new CollectionDOMManipulationSpec() );*/
		#end
		
		Report.create( runner );
		
		runner.run();
		
	}
	
}