package dtx;

import utest.Assert;

import dtx.DOMNode;
using Detox;

class ElementManipulationSpec 
{
	var sampleDocument:DOMNode;
	var h1:DOMNode;
	var h2:DOMNode;
	var comment:DOMNode;
	var text:DOMNode;

	var parent:DOMNode;
	var child:DOMNode;
	var classTest:DOMNode;
	var nullnode:DOMNode;
	
	public function new() 
	{
	}
	
	public function setup():Void
	{
		var html = "<myxml>
		<h1 id='title'>My Header</h1>
		<h2>My Sub Header</h2>
		<div class='containscomment'><!-- A comment --></div>
		<div class='containstext'>Text</div>
		<div class='parent'><span class='child'>Child</span></div>
		<div id='classtest' class='first third fourth'></div>
		</myxml>";

		sampleDocument = html.parse().getNode();
		h1 = sampleDocument.find('h1').getNode();
		h2 = sampleDocument.find('h2').getNode();
		comment = sampleDocument.find('.containscomment').getNode().firstChild;
		text = sampleDocument.find('.containstext').getNode().firstChild;
		parent = sampleDocument.find('.parent').getNode();
		child = sampleDocument.find('.child').getNode();
		classTest = sampleDocument.find('#classtest').getNode();
		nullnode = null;
	}
	
	public function tearDown():Void
	{
		// trace ("Tear Down");
	}
	
	
	public function testIsElement():Void
	{
		Assert.isTrue(sampleDocument.isElement());
		Assert.isTrue(h1.isElement());
		Assert.isFalse(comment.isElement());
		Assert.isFalse(text.isElement());
	}

	public function testIsComment():Void
	{
		Assert.isFalse(h1.isComment());
		Assert.isTrue(comment.isComment());
		Assert.isFalse(text.isComment());
	}


	public function testIsTextNode():Void
	{
		Assert.isFalse(h1.isTextNode());
		Assert.isFalse(comment.isTextNode());
		Assert.isTrue(text.isTextNode());
	}
	
	public function testTypeCheckOnNull():Void
	{
		Assert.isFalse(nullnode.isElement());
		Assert.isFalse(nullnode.isTextNode());
		Assert.isFalse(nullnode.isComment());
		Assert.isFalse(nullnode.isDocument());
	}

	public function testReadAttr():Void
	{
		Assert.equals("title", h1.attr("id"));
	}

	public function testNullReadAttr():Void
	{
		Assert.equals("", nullnode.attr("id"));
	}

	public function testSetAttr():Void
	{
		var newID = "test";
		child.setAttr('id', newID);
		Assert.equals(newID, child.attr("id"));
	}

	public function testNullSetAttr():Void
	{
		var result = nullnode.setAttr('id', "test");
		Assert.equals(null, result);
	}

	public function testRemoveAttr():Void
	{
		h1.removeAttr('id');
		#if js
		Assert.isFalse(h1.hasAttributes());
		#else 
		var i = 0;
		for (attr in h1.attributes) i++;
		Assert.equals(0, i);
		#end
	}

	public function testNullRemoveAttr():Void
	{
		var result = nullnode.removeAttr('id');
		Assert.equals(null, result);
	}

	public function testHasClass():Void
	{
		Assert.isTrue(classTest.hasClass('first'));
		Assert.isFalse(classTest.hasClass('second'));
		Assert.isTrue(classTest.hasClass('third'));
		Assert.isTrue(classTest.hasClass('fourth'));
	}

	public function testNullHasClass():Void
	{
		Assert.isFalse(nullnode.hasClass('second'));
	}

	public function testHasClassMultiple():Void
	{
		Assert.isTrue(classTest.hasClass('third first'));
		Assert.isTrue(classTest.hasClass('third   first'));
		Assert.isFalse(classTest.hasClass('fourth second third'));
	}

	public function testAddClass():Void
	{
		h1.addClass('myclass');
		Assert.isTrue(h1.hasClass('myclass'));
	}

	public function testNullAddClass():Void
	{
		var result = nullnode.addClass('myclass');
		Assert.equals(null, result);
	}

	public function testAddMultipleClasses():Void
	{
		h1.addClass('myclass myclass2 myclass3');
		Assert.isTrue(h1.hasClass('myclass'));
		Assert.isTrue(h1.hasClass('myclass2'));
		Assert.isTrue(h1.hasClass('myclass3'));
	}

	public function testAddClassThatAlreadyExists():Void
	{
		h1.addClass('myclass');
		h1.addClass('myclass');
		var classVal = h1.attr('class');
		Assert.equals(classVal.indexOf('myclass'), classVal.lastIndexOf('myclass'));
	}

	public function testRemoveClass():Void
	{
		h1.addClass('myclass1 myclass2 myclass3');

		Assert.isTrue(h1.hasClass('myclass1'));
		Assert.isTrue(h1.hasClass('myclass2'));
		Assert.isTrue(h1.hasClass('myclass3'));
		Assert.equals(h1.attr('class'), 'myclass1 myclass2 myclass3');

		h1.removeClass('myclass1');
		Assert.isFalse(h1.hasClass('myclass1'));
		Assert.isTrue(h1.hasClass('myclass2'));
		Assert.isTrue(h1.hasClass('myclass3'));
		Assert.equals('myclass2 myclass3', h1.attr('class'));

		h1.removeClass('myclass2');
		Assert.isFalse(h1.hasClass('myclass1'));
		Assert.isFalse(h1.hasClass('myclass2'));
		Assert.isTrue(h1.hasClass('myclass3'));
		Assert.equals('myclass3', h1.attr('class'));

		h1.removeClass('myclass3');
		Assert.isFalse(h1.hasClass('myclass1'));
		Assert.isFalse(h1.hasClass('myclass2'));
		Assert.isFalse(h1.hasClass('myclass3'));
		Assert.equals('', h1.attr('class'));
	}

	public function testRemoveMultipleClasses():Void
	{
		h1.addClass('myclass');
		h1.addClass('myclass2');
		h1.addClass('myclass3');
		h1.addClass('myclass4');
		Assert.isTrue(h1.hasClass('myclass'));
		Assert.isTrue(h1.hasClass('myclass2'));
		Assert.isTrue(h1.hasClass('myclass3'));
		Assert.isTrue(h1.hasClass('myclass4'));

		h1.removeClass('myclass4 myclass myclass3');
		Assert.isFalse(h1.hasClass('myclass'));
		Assert.isTrue(h1.hasClass('myclass2'));
		Assert.isFalse(h1.hasClass('myclass3'));
		Assert.isFalse(h1.hasClass('myclass4'));
	}

	public function testNullRemoveClass():Void
	{
		var result = nullnode.removeClass('myclass');
		Assert.equals(null, result);
	}

	public function testToggleClass():Void
	{
		h1.addClass('myclass');
		h1.toggleClass('myclass');
		Assert.isFalse(h1.hasClass('myclass'));

		h1.toggleClass('myclass2');
		Assert.isTrue(h1.hasClass('myclass2'));

		h1.addClass('myclass3 myclass4');
		h1.toggleClass('myclass3');
		Assert.equals('myclass2 myclass4', h1.attr('class'));
	}

	public function testToggleMultipleClasses():Void
	{
		h1.addClass('myclass1 myclass2 myclass3 myclass4');
		h1.toggleClass('myclass1 myclass3');
		Assert.isFalse(h1.hasClass('myclass1'));
		Assert.isTrue(h1.hasClass('myclass2'));
		Assert.isFalse(h1.hasClass('myclass3'));
		Assert.isTrue(h1.hasClass('myclass4'));
	}

	public function testNullToggleClass():Void
	{
		var result = nullnode.toggleClass('myclass');
		Assert.equals(null, result);
	}

	public function testTagName():Void 
	{
		Assert.equals("h1", h1.tagName());
		Assert.equals("h2", h2.tagName());
		Assert.equals("myxml", sampleDocument.tagName());
	}

	public function testTagNameOfNonElement():Void 
	{
		Assert.equals("#text", text.tagName());
		Assert.equals("#comment", comment.tagName());
		Assert.equals("", nullnode.tagName());
	}

	public function testUpperCaseTagName():Void 
	{
		var elm = "MyElement".create();
		Assert.equals( "myelement", elm.tagName() );
		Assert.equals( "<myelement></myelement>", elm.html() );
	}

	public function testValInput():Void 
	{
		var input = "<input type='text' value='attr' />".parse().getNode();
		#if js 
		Reflect.setField(input, "value", "myvalue");
		#else 
		input.setAttr("value", "myvalue"); 
		#end
		Assert.equals("myvalue", input.val());
	}

	public function testValOnTextArea():Void 
	{
		var ta = "<textarea>test</textarea>".parse().getNode();
		#if js 
		Reflect.setField(ta, "value", "myvalue");
		#else 
		ta.setAttr("value", "myvalue");
		#end
		Assert.equals("myvalue", ta.val());
	}

	public function testValOnComment():Void 
	{
		/*#if sys
		Assert.equals("A comment", comment.val());
		#else*/
		Assert.equals(" A comment ", comment.val());
		//#end
	}

	public function testValOnTextNode():Void 
	{
		Assert.equals("Text", text.val());
	}

	public function testValOnAttribute():Void 
	{
		var div = "<div value='attr'></div>".parse().getNode();
		Assert.equals("attr", div.val());
	}

	public function testNullVal():Void
	{
		Assert.equals("", nullnode.val());
	}

	public function testSetValInput():Void 
	{
		var input = "<input type='text' value='attr' />".parse().getNode();
		input.setVal("newvalue");
		Assert.equals("newvalue", input.val());
	}

	public function testNullSetVal():Void
	{
		var result = nullnode.setVal("value");
		Assert.equals(null, result);
	}

	public function testSetValComment():Void 
	{
		comment.setVal("mycomment");
		Assert.equals("<!--mycomment-->", sampleDocument.find('.containscomment').innerHTML());
	}

	public function testSetValTextNode():Void 
	{
		text.setVal("NewText");
		Assert.equals("NewText", sampleDocument.find('.containstext').innerHTML());
	}

	public function testText():Void 
	{
		var helloworld = "<div>Hello <i>World</i></div>".parse().getNode();
		Assert.equals("Hello World", helloworld.text());
	}

	public function testNullText():Void 
	{
		Assert.equals("", nullnode.text());
	}

	public function testSetText():Void 
	{
		var helloworld = "<div>Hello <i>World</i></div>".parse().getNode();
		helloworld.setText("Goodbye Planet");
		Assert.equals("Goodbye Planet", helloworld.innerHTML());
	}

	public function testNullSetText():Void 
	{
		Assert.equals(null, nullnode.setText("text"));
	}

	public function testSetTextComment():Void 
	{
		comment.setText("mycomment");
		Assert.equals("<!--mycomment-->", sampleDocument.find('.containscomment').innerHTML());
	}

	public function testSetTextTextNode():Void 
	{
		text.setText("NewText");
		Assert.equals("NewText", sampleDocument.find('.containstext').innerHTML());
	}

	public function testInnerHTML():Void 
	{
		var helloworld = "<div>Hello <i>World</i></div>".parse().getNode();
		Assert.equals("Hello <i>World</i>", helloworld.innerHTML());
		Assert.equals("World", helloworld.find("i").innerHTML());
	}

	public function testNullInnerHTML():Void 
	{
		Assert.equals("", nullnode.innerHTML());
	}

	public function testInnerHTMLOnNonElements():Void 
	{
		/*#if sys
		Assert.equals("A comment", comment.innerHTML());
		#else*/
		Assert.equals(" A comment ", comment.innerHTML());
		//#end
		Assert.equals("Text", text.innerHTML());
	}

	public function testSetInnerHTML():Void 
	{
		var helloworld = "<div>Hello <i>World</i></div>".parse().getNode();
		helloworld.setInnerHTML("Goodbye <i>Cruel</i> Planet");
		Assert.equals("Goodbye <i>Cruel</i> Planet", helloworld.innerHTML());
	}

	public function testNullSetInnerHTML():Void 
	{
		Assert.equals(null, nullnode.setInnerHTML("innerhtml"));
	}

	public function testSetInnerHTMLComment():Void 
	{
		comment.setInnerHTML("mycomment");
		Assert.equals("<!--mycomment-->", sampleDocument.find('.containscomment').innerHTML());
	}

	public function testSetInnerHTMLTextNode():Void 
	{
		text.setInnerHTML("NewText");
		Assert.equals("NewText", sampleDocument.find('.containstext').innerHTML());
	}

	public function testHtml():Void 
	{
		var helloworld = "<div>Hello <i>World</i></div>".parse().getNode();
		Assert.equals("<div>Hello <i>World</i></div>", helloworld.html());
		Assert.equals("<i>World</i>", helloworld.find("i").html());
	}

	public function testHtmlSelfClosing():Void 
	{
		var div = "<div id='1'>Test</div>".parse().getNode();
		var emptyDiv = "<div id='1' />".parse().getNode();
		var emptyImg = "<img id='1' />".parse().getNode();

		Assert.equals('<div id="1">Test</div>', div.html());
		Assert.equals('<div id="1"></div>', emptyDiv.html());
		Assert.isTrue(emptyImg.html().indexOf(">") > -1);
		Assert.isTrue(emptyImg.html().indexOf("</img>") == -1);
	}

	public function htmlWithDifferentNodeTypes() 
	{
		// slight differences in toString() rendering between JS and Xml platforms
		// toString() seems to ignore empty text nodes...
		var expected = "<p>Text <i>Node</i> </p>  <p>  Text Node with Spaces  </p> <!-- Comment -->";
		var xml = expected.parse();
		Assert.equals(5, xml.length);
		Assert.equals("<p>Text <i>Node</i> </p>", xml.getNode(0).html());
		Assert.equals("  ", xml.getNode(1).html());
		Assert.equals("<p>  Text Node with Spaces  </p>", xml.getNode(2).html());
		Assert.equals(" ", xml.getNode(3).html());
		Assert.equals("<!-- Comment -->", xml.getNode(4).html());
	}

	public function testNullHtml():Void 
	{
		Assert.equals("", nullnode.html());
	}

	public function testHtmlOnNonElements():Void 
	{
		/*#if sys
		Assert.equals("<!--A comment-->", comment.html());
		#else*/
		Assert.equals("<!-- A comment -->", comment.html());
		//#end
		Assert.equals("Text", text.html());
	}

	public function testHtmlEntityEscaping() {
		var div = 'div'.create();

		// Test basic escaping from `setText`

		div.setText( 'Please no <b>Bold</b>' );
		Assert.equals( "Please no <b>Bold</b>", div.text() );
		Assert.equals( "<div>Please no &lt;b&gt;Bold&lt;/b&gt;</div>", div.html() );
		var newDiv = div.html().parse();
		Assert.equals( 0, newDiv.find("b").length );

		div.setText( 'This & That' );
		var newDiv = div.html().parse();
		Assert.equals( "<div>This &amp; That</div>", div.html() );

		// Test escapting quotes in `setAttr` to prevent maliciousness
		
		var link = '<a href="">Link</a>'.parse();

		var attemptEscapeAttr = 'fakelink" onclick="HAHA!';
		link.setAttr( "href", attemptEscapeAttr );
		Assert.equals( attemptEscapeAttr, link.attr('href') );
		Assert.equals( '', link.attr('onclick') );
		Assert.isTrue( link.html().indexOf(StringTools.htmlEscape(attemptEscapeAttr,true))>-1 );

		var newLink = link.html().parse();
		Assert.equals( attemptEscapeAttr, newLink.attr('href') );
		Assert.equals( '', newLink.attr('onclick') );
		
		// Test escaping from `setAttr`

		var div = "div".create();
		var content = "Hello <\'Friends\' & \"Family\">";
		var encodedContent = StringTools.htmlEscape( content, true );
		
		div.setAttr("title",content);

		Assert.equals('<div title="$encodedContent"></div>', div.html());
		var newDiv = div.html().parse();
		Assert.isTrue( div.html().indexOf(encodedContent)>-1 );
		Assert.equals(content, newDiv.attr('title'));

		// Test escaping from innerHTML

		var content = "<p>Here is some code: <code>var arr:Array&lt;String&gt;</code> - nice hey!</p>";
		var div = "div".create();
		div.setInnerHTML( content );
		Assert.equals( '$content', div.innerHTML() );
		Assert.equals( '<div>$content</div>', div.html() );

		// Test escaping of non-standard entities
		var content = "<div>&laquo;Haxe&raquo;</div>";
		var div = content.parse();
		#if js
			// This difference is frustrating but I can't yet find a workaround.
			// On JS, when parsing the string into the DOM, those entities are converted to the unicode characters.
			// When we go to output, they are unicode, not the entities.
			// Ideally, I would like text() to contain the unencoded unicode, and html() to use the entities.
			// If anyone can think of an implementation please let me know.
			Assert.equals( 6, div.text().length ); // "«Haxe»"
			Assert.equals( 17, div.html().length ); // "<div>«Haxe»</div>"
		#else
			Assert.equals( "&laquo;Haxe&raquo;", div.text() );
			Assert.equals( "<div>&laquo;Haxe&raquo;</div>", div.html() );
		#end

		// Test escaping of non-standard entities
		var content = "<p>Furthermore, Cauê Waneck's</p>";
		var div = content.parse();
		Assert.equals( "Furthermore, Cauê Waneck's", div.text() );
		Assert.equals( "<p>Furthermore, Cauê Waneck's</p>", div.html() );
	}

	public function testCloneTextNode():Void 
	{
		var newText = text.clone();
		Assert.equals(text.nodeValue, newText.nodeValue);
		newText.setText("Different");
		Assert.notEquals(text.nodeValue, newText.nodeValue);
	}

	public function testCloneNullNode():Void 
	{
		Assert.equals(null, nullnode.clone());
	}

	public function testCloneComment():Void 
	{
		var newComment = comment.clone();
		Assert.equals(comment.nodeValue, newComment.nodeValue);
		newComment.setText("Different");
		Assert.notEquals(comment.nodeValue, newComment.nodeValue);
	}

	public function testCloneElement():Void 
	{
		var newH1 = h1.clone();
		Assert.equals(h1.text(), newH1.text());
		Assert.equals(h1.attr('id'), newH1.attr('id'));

		newH1.setText("Different");
		newH1.setAttr("id", "differentid");
		Assert.notEquals(h1.text(), newH1.text());
		Assert.notEquals(h1.attr('id'), newH1.attr('id'));
	}

	public function testCloneElementRecursive():Void 
	{
		var newSampleDoc = sampleDocument.clone();
		var newH1 = newSampleDoc.find('h1').getNode();
		var newH2 = newSampleDoc.find('h2').getNode();
		newH1.setText("Different");
		newH1.setAttr("id", "differentid");

		Assert.notEquals(h1.text(), newH1.text());
		Assert.notEquals(h1.attr('id'), newH1.attr('id'));
		Assert.notEquals(sampleDocument.innerHTML(), newSampleDoc.innerHTML());
		Assert.equals(h2.text(), newH2.text());
	}

	function testIndexNormal():Void 
	{
		Assert.equals(1, h1.index());
		Assert.equals(3, h2.index());
		Assert.equals(0, text.index());
		Assert.equals(9, parent.index());
		Assert.equals(0, child.index());
	}

	function testIndexNull():Void 
	{
		Assert.equals(-1, nullnode.index());
	}

	function testChaining():Void 
	{
		var originalElement:DOMNode = "div".create().setAttr("id", "original");
		var returnedElement:DOMNode;

		returnedElement = originalElement
			.setAttr("title", "")
			.removeAttr("title")
			.addClass("class")
			.toggleClass("class")
			.removeClass("class")
			.setVal("test")
			.setText("mytext")
			.setInnerHTML("myinnerHTML")
		;

		returnedElement.setAttr("id", "updatedID");
		Assert.equals(originalElement.attr('id'), returnedElement.attr('id'));
	}
}
