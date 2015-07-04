package ;

#if uhu
	import uhx.io.UriSpec;
#end

#if (uhu && mo)
	#if html_select
		import uhx.select.HtmlSelectSpec;
	#end
	
	#if json_select
		import uhx.select.JsonSelectSpec;
	#end
#end

#if (sys && tuli)
	import uhx.tuli.plugins.AtomSpec;
#end

#if (detox)
	import dtx.*;
#end

#if cmd
	import uhx.sys.EdeSpec;
	import uhx.sys.LiySpec;
	import uhx.sys.LodSpec;
#end

#if (seri && !disable_seri)
	import uhx.seri.SeriSpec;
#end

#if (uhu && klas)
	//import uhx.macro.TraitSpec;
#end

#if mo
	#if haxe_lexer
		import uhx.lexer.HaxeParserSpec;
	#end
	
	#if css_lexer
		import uhx.lexer.CssParserSpec;
	#end
	
	#if html_lexer
		import uhx.lexer.HtmlLexerSpec;
	#end
	
	#if markdown_lexer
		import uhx.lexer.MarkdownParserSpec;
	#end
	
	#if mime_lexer
		import uhx.lexer.MimeLexerSpec;
		
		#if media_types
			import uhx.mt.MediaTypeSpec;
		#end
	#end
	
	#if uri_lexer
		import uhx.lexer.UriLexerSpec;
	#end
#end

#if (uhu && mo && detox && fisel)
	import uhx.fisel.FiselSpec;
#end

#if klas
	import uhx.macro.KlasSpec;
	
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
		
		#if uhu
			runner.addCase( new UriSpec() );
		#end
		
		// Lexer and Parser Tests
		#if mo
			#if haxe_lexer
				runner.addCase( new HaxeParserSpec() );
			#end
			
			#if markdown_lexer
				runner.addCase( new MarkdownParserSpec() );
			#end
			
			#if css_lexer
				runner.addCase( new CssParserSpec() );
			#end
			
			#if html_lexer
				runner.addCase( new HtmlLexerSpec() );
			#end
			
			#if mime_lexer
				runner.addCase( new MimeLexerSpec() );
				
				#if media_types
					runner.addCase( new MediaTypeSpec() );
				#end
			#end
			
			#if uri_lexer
				runner.addCase( new UriLexerSpec() );
			#end
		#end
		
		#if (uhu && mo)
			#if html_select
				runner.addCase( new HtmlSelectSpec() );
			#end
			
			#if json_select
				//runner.addCase( new JsonSelectSpec() );
			#end
		#end
		
		#if (mo && detox && !disable_detox)
			runner.addCase( new ElementManipulationSpec() );
			runner.addCase( new CollectionSpec() );
			runner.addCase( new CollectionElementManipulationSpec() );
			runner.addCase( new ToolsSpec() );
			runner.addCase( new TraversingSpec() );
			runner.addCase( new CollectionTraversingSpec() );
			runner.addCase( new DOMManipulationSpec() );
			runner.addCase( new CollectionDOMManipulationSpec() );
		#end
		
		#if (uhu && mo && detox && fisel)
			runner.addCase( new FiselSpec() );
		#end
		
		// Commandline Tests
		#if cmd
			runner.addCase( new LodSpec() );
			runner.addCase( new LiySpec() );
		#end
		
		// Experimental Build Macros
		#if klas
			runner.addCase( new KlasSpec() );
			#if trait
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
			
			#if cmd
				runner.addCase( new EdeSpec() );
			#end
		#end
		
		#if (seri && !disable_seri)
			runner.addCase( new SeriSpec() );
		#end
		
		#if (sys && tuli)
			// Tuli Plugin Tests
			runner.addCase( new AtomSpec() );
		#end
		
		Report.create( runner );
		
		runner.run();
		
	}
	
}