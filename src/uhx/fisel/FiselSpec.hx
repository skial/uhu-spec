package uhx.fisel;

using Detox;

/**
 * ...
 * @author Skial Bainn
 */
class FiselSpec {
	
	public function new() {
		
	}
	
	private function parse(html:String) {
		return new Fisel( html );
	}
	
	private function testThing() {
		var f = parse( 
'<html>
	<head>
		<base href="../templates/html" />
		<link id="customID" rel="import" href="escaped.html" />
		<link rel="import" href="methods.html" />
		<link rel="import" href="script.js" />
		<title>Hello World from <content select="h1:first-child" /></title>
	</head>
	<body>
		<h1>Fisel</h1>
		<content select="#customID" />
	</body>
</html>' 
		);
		
		f.build();
		trace( f.document.html() );
	}
	
}