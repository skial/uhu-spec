package uhx.fisel;

/**
 * ...
 * @author Skial Bainn
 */
class FiselSpec {
	
	public function new() {
		
	}
	
	private function parse(html:String) {
		var fisel = new Fisel( html );
	}
	
	private function testThing() {
		parse( 
'<html>
	<head>
		<base href="../templates/html" />
		<link id="customID" rel="import" href="escaped.html" />
		<link rel="import" href="methods.html" />
		<link rel="import" href="script.js" />
		<title>Hello World from <content select="1" /></title>
	</head>
	<body>
		<content select="2" />
	</body>
</html>' 
		);
	}
	
}