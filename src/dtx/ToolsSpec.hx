package dtx;

import utest.Assert;

import Detox;
import dtx.DOMCollection;
import dtx.DOMNode;
using Detox;

class ToolsSpec {
	
	public function new() 
	{
	}
	
	@Before
	public function setup():Void
	{
		var sampleDocument = "<myxml>
			<h1>Title</h1>
			<p>One</p>
			<p>Two</p>
			<div></div>
		</myxml>".parse();
		Detox.setDocument(sampleDocument.getNode());
	}
	
	@After
	public function tearDown():Void
	{
		// trace ("Tear Down");
	}

	//
	// These are just a basic wrapper on some DOMCollection functions (new, create, parse)
	// There are unit tests there, so just test that they work from a string.
	// 

	public function testFind()
	{
		Assert.equals(1, "h1".find().length);
		Assert.equals(2, "p".find().length);
	}

	public function testCreate_via_using()
	{
		Assert.equals(#if js "DIV" #else "div" #end, "div".create().nodeName);
		Assert.equals(#if js "P" #else "p" #end, "p".create().nodeName);
		Assert.isNull("non element".create());
		Assert.isNull("".create());
	}

	public function testParse_via_using()
	{
		Assert.equals(2, "<p>One</p><div>Two</div>".parse().length);
		Assert.equals(1, "my text node".parse().length);
		Assert.equals(0, "".parse().length);
	}

	public function testCreate() 
	{
		var div:DOMNode = Detox.create("div");
		Assert.equals("div", div.tagName());
		Assert.equals("", div.innerHTML());
	}

	public function testCreateBadInput() 
	{
		var elm:DOMNode = Detox.create("actual_element");
		Assert.equals("actual_element", elm.tagName());
		Assert.equals("", elm.innerHTML());

		var bad = Detox.create("non existent element");
		Assert.isNull(bad);
	}

	public function testCreateNullInput() 
	{
		var bad = Detox.create(null);
		Assert.isNull(bad);
	}

	public function testCreateEmptyString() 
	{
		var bad = Detox.create("");
		Assert.isNull(bad);
	}

	public function testParse() 
	{
		var q = Detox.parse("<div id='test'>Hello</div>");

		Assert.equals(1, q.length);
		Assert.equals('div', q.tagName());
		Assert.equals('test', q.attr('id'));
		Assert.equals('Hello', q.innerHTML());
	}

	public function testParseMultiple() 
	{
		var q = Detox.parse("<div id='test1'>Hello</div><p id='test2'>World</p><!--comment-->");

		Assert.equals(3, q.length);
		Assert.equals("div", q.eq(0).tagName());
		Assert.equals("p", q.eq(1).tagName());
		Assert.equals("comment", q.eq(2).val());
	}

	public function testParseTextOnly() 
	{
		var q3 = Detox.parse("text only");

		Assert.equals(dtx.DOMType.TEXT_NODE, q3.getNode().nodeType);
		Assert.equals("text only", q3.getNode().nodeValue);
		Assert.equals(1, q3.length);
	}

	public function testParseComment() 
	{
		var q1 = Detox.parse("<!-- Just 1 comment -->");

		Assert.isTrue(q1.getNode().isComment());
		//#if !sys
		Assert.equals(" Just 1 comment ", q1.getNode().nodeValue);
		/*#else
		Assert.equals("Just 1 comment", q1.getNode().nodeValue);
		#end*/
		Assert.equals(1, q1.length);

		var q2 = Detox.parse("<!-- Comment --> Text Node");

		Assert.isTrue(q2.getNode().isComment());
		//#if !sys
		Assert.equals(" Comment ", q2.getNode().nodeValue);
		/*#else
		Assert.equals("Comment", q2.getNode().nodeValue);
		#end*/
		Assert.equals(2, q2.length);

		var q3 = Detox.parse("<!-- Comment1 --><!-- Comment2 -->");

		Assert.isTrue(q3.getNode().isComment());
		//#if !sys
		Assert.equals(" Comment1 ", q3.getNode(0).nodeValue);
		Assert.equals(" Comment2 ", q3.getNode(1).nodeValue);
		/*#else
		Assert.equals("Comment1", q3.getNode(0).nodeValue);
		Assert.equals("Comment2", q3.getNode(1).nodeValue);
		#end*/
		Assert.equals(2, q3.length);
	}

	public function testParseNull() 
	{
		var q = Detox.parse(null);
		Assert.equals(0, q.length);
	}

	public function testParseEmptyString() 
	{
		var q = Detox.parse("");
		Assert.equals(0, q.length);
	}

	public function testParseBrokenHTML() 
	{
		// This passes in most browsers, but it's not entirely consistent
		// in it's behaviour.  However, I don't think it's a common enough
		// (or dangerous enough) use case for us to think about correcting
		// these inconsistencies.
		// This test merely checks that it doesn't throw an error.
		var q = Detox.parse("<p>My <b>Broken Paragraph</p>");
		Assert.equals(1, q.length);
	}

	public function testParseTableElements() 
	{
		// On the JS target, the browser can be a douché and mess with the parsing of an element if it 
		// deems it to be bad html.  This mostly shows with elements used in tables - they fail to create
		// correctly unless they have the correct parent element.  
		// This test ensures that our workarounds work - and that the elements are created correctly.
		var q1 = Detox.parse("<td>Table Data Cell</td>");
		Assert.equals("td", q1.tagName());

		var q2 = Detox.parse("<th>Table Header Cell</th>");
		Assert.equals("th", q2.tagName());

		var q3 = Detox.parse("<tr>Table Row</tr>");
		Assert.equals("tr", q3.tagName());

		var q4 = Detox.parse("<colgroup>Table Column Group</colgroup>");
		Assert.equals("colgroup", q4.tagName());

		var q5 = Detox.parse("<col>Table Column</col>");
		Assert.equals("col", q5.tagName());

		var q6 = Detox.parse("<tbody>Table Body</tbody>");
		Assert.equals("tbody", q6.tagName());

		var q7 = Detox.parse("<thead>Table Body</thead>");
		Assert.equals("thead", q7.tagName());
	}

	public function testParseXmlEntities()
	{
		var content = "<p title='This &amp; That'>Allow &lt;Entities&gt;</p>";
		var xml = content.parse();
		Assert.equals( "This & That", xml.attr('title') );
		Assert.equals( "Allow &lt;Entities&gt;", xml.innerHTML() );
		Assert.equals( "Allow <Entities>", xml.firstChildren(false).getNode().nodeValue );
		Assert.isTrue( xml.html().indexOf("This &amp; That")>-1 );
	}

	public function testSetDocument()
	{
		var node = "<p>This is <b>My Element</b>.</p>".parse().getNode();
		Detox.setDocument(node);
		Assert.equals("My Element", "b".find().innerHTML());
	}

	public function testSetDocument_null()
	{
		var node = "<p>This is <b>My Element</b>.</p>".parse().getNode();
		Detox.setDocument(node);
		Detox.setDocument(null);

		// The document should still be 'node', because null is rejected.
		Assert.equals("My Element", "b".find().innerHTML());
	}

	#if js 

	public function testToDetox()
	{
		var x = Xml.parse("<div>123</div><p>ABC</p>");
		var xNull:Xml = null;

		Assert.equals(2, x.toDetox().length);
		Assert.equals(0, xNull.toDetox().length);
	}
	
	#end 

}
