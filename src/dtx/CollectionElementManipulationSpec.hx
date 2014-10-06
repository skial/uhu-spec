package dtx;

import utest.Assert;

import dtx.DOMCollection;
import Detox;
using Detox;

class CollectionElementManipulationSpec 
{
	public function new() 
	{
	}

	public var sampleDocument:DOMCollection;
	public var h1:DOMCollection;
	public var lists:DOMCollection;
	public var listItems:DOMCollection;
	public var pickme:DOMCollection;
	public var emptyNode:DOMCollection;
	public var nonElements:DOMCollection;
	public var textNodes:DOMCollection;
	public var commentNodes:DOMCollection;
	public var emptyCollection:DOMCollection;
	public var nullDOMCollection:DOMCollection;
	public var a:DOMCollection;
	public var b:DOMCollection;
	public var b2:DOMCollection;
	
	@Before
	public function setup():Void
	{
		sampleDocument = "<myxml>
			<h1>Title</h1>
			<ul id='a' title='first'>
				<li id='a1'>1</li>
				<li id='a2' class='pickme'>2</li>
				<li id='a3'>3</li>
			</ul>
			<ul id='b' title='second'>
				<li id='b1'>1</li>
				<li id='b2' class='pickme'>2</li>
				<li id='b3'>3</li>
			</ul>
			<div class='empty'></div>
			<div class='nonelements'>Start<!--Comment1-->End<!--Comment2--></div>
		</myxml>".parse();

		Detox.setDocument(sampleDocument.getNode());

		h1 = "h1".find();
		lists = "ul".find();
		listItems = "li".find();
		pickme = "li.pickme".find();
		emptyNode = ".empty".find();
		nonElements = ".nonelements".find().children(false);
		textNodes = nonElements.filter(function (node) {
			return node.isTextNode();
		});

		commentNodes = nonElements.filter(function (node) {
			return node.isComment();
		});
		emptyCollection = new DOMCollection();
		nullDOMCollection = null;
		a = "#a".find();
		b = "#b".find();
		b2 = "#b2".find();
	}
	
	@After
	public function tearDown():Void
	{
		// trace ("Tear Down");
	}

	public function testAttr()
	{
		Assert.equals("first", a.attr('title'));
		Assert.equals("second", b.attr('title'));
		Assert.equals("pickme", b2.attr('class'));
	}

	public function testAttrOnNull()
	{
		Assert.equals("", nullDOMCollection.attr('id'));
	}

	public function testAttrOnEmpty()
	{
		Assert.equals("", emptyCollection.attr('id'));
	}

	public function testAttrDoesNotExist()
	{
		Assert.equals("", a.attr('doesnotexist'));
		Assert.equals("", a.attr('bad attribute name'));
	}

	public function testAttrOnMultiple()
	{
		Assert.equals("first", lists.attr('title'));
		Assert.equals("a2", pickme.attr('id'));
	}

	public function testSetAttr()
	{
		a.setAttr('title', '1st');
		b2.setAttr('class', 'dontpickme');
		Assert.equals("1st", a.attr('title'));
		Assert.equals("second", b.attr('title'));
		Assert.equals("dontpickme", b2.attr('class'));
	}

	public function testSetAttrMultiple()
	{
		lists.setAttr('title', 'thesame');
		Assert.equals('thesame', a.attr('title'));
		Assert.equals('thesame', b.attr('title'));
	}

	public function testSetAttrOnNull()
	{
		nullDOMCollection.setAttr('id', 'myID');
		Assert.equals("", nullDOMCollection.attr('id'));
	}

	public function testSetAttrOnEmpty()
	{
		emptyCollection.setAttr('id', 'myID');
		Assert.equals("", emptyCollection.attr('id'));
	}

	public function testRemoveAttr()
	{
		lists.removeAttr('title');
		Assert.equals('', a.attr('title'));
		Assert.equals('', b.attr('title'));
	}

	public function testRemoveAttrOnNull()
	{
		nullDOMCollection.removeAttr('id');
		Assert.equals("", nullDOMCollection.attr('id'));
	}

	public function testRemoveAttrOnEmpty()
	{
		emptyCollection.removeAttr('id');
		Assert.equals("", emptyCollection.attr('id'));
	}

	public function testRemoveAttrThatDoesNotExist()
	{
		lists.removeAttr('attrdoesnotexist');
		lists.removeAttr('attr bad input');
		Assert.equals('', a.attr('attrdoesnotexist'));
		Assert.equals('', b.attr('attrdoesnotexist'));
		Assert.equals('', a.attr('attr bad input'));
		Assert.equals('', b.attr('attr bad input'));
	}

	public function testHasClass()
	{
		Assert.isFalse("#a1".find().hasClass('pickme'));
		Assert.isTrue("#a2".find().hasClass('pickme'));
	}

	public function testHasClassOnNull()
	{
		Assert.isFalse(nullDOMCollection.hasClass('myclass'));
	}

	public function testHasClassOnEmpty()
	{
		Assert.isFalse(emptyCollection.hasClass('myclass'));
	}

	public function testHasClassMultiple()
	{
		Assert.isFalse(lists.hasClass('pickme'));
		Assert.isTrue(pickme.hasClass('pickme'));

		// Try a collection with some of each... 
		// It should only return true if all things are true
		var q = new DOMCollection();
		q.addCollection(lists);
		q.addCollection(pickme);
		Assert.isFalse(q.hasClass('pickme'));
	}

	public function testHasClassMultipleClassNames()
	{
		var q = "<p>My Paragraph</p>".parse();

		q.addClass('first');
		q.addClass('second');
		q.addClass('fourth');

		// single tests
		Assert.isTrue(q.hasClass('first'));
		Assert.isTrue(q.hasClass('second'));
		Assert.isFalse(q.hasClass('third'));
		Assert.isTrue(q.hasClass('fourth'));

		// multiple true
		Assert.isTrue(q.hasClass('first second'));
		Assert.isTrue(q.hasClass('second first'));
		Assert.isTrue(q.hasClass('second  first'));
		Assert.isTrue(q.hasClass('second fourth first'));

		// multiple false
		Assert.isFalse(q.hasClass('third fifth'));

		// multiple mixed
		Assert.isFalse(q.hasClass('first second third'));
		Assert.isFalse(q.hasClass('third fourth'));
	}

	public function testAddClass()
	{
		Assert.isFalse(h1.hasClass("first"));
		h1.addClass('first');
		Assert.isTrue(h1.hasClass("first"));
		
		Assert.isFalse(h1.hasClass("second"));
		h1.addClass('second');
		Assert.isTrue(h1.hasClass("second"));

		Assert.equals("first second", h1.attr('class'));
	}

	public function testAddClassMultipleClasses()
	{
		Assert.isFalse(h1.hasClass("first"));
		Assert.isFalse(h1.hasClass("second"));
		h1.addClass('first second');
		Assert.isTrue(h1.hasClass("first"));
		Assert.isTrue(h1.hasClass("second"));

		Assert.equals("first second", h1.attr('class'));
	}

	public function testAddClassThatAlreadyExists()
	{
		Assert.isFalse(h1.hasClass("test"));
		h1.addClass('test');
		Assert.equals("test", h1.attr('class'));

		// now add it again and check it doesn't double up
		h1.addClass('test');
		Assert.equals("test", h1.attr('class'));
	}

	public function testAddClassOnNull()
	{
		nullDOMCollection.addClass('myclass');
		Assert.isFalse(nullDOMCollection.hasClass('myclass'));
	}

	public function testAddClassOnEmpty()
	{
		emptyCollection.addClass('myclass');
		Assert.isFalse(emptyCollection.hasClass('myclass'));
	}

	public function testRemoveClass()
	{
		Assert.isFalse(h1.hasClass("first"));
		h1.addClass('first');
		Assert.equals("first", h1.attr('class'));
		
		Assert.isFalse(h1.hasClass("second"));
		h1.addClass('second');
		Assert.equals("first second", h1.attr('class'));
	}

	public function testRemoveClassMultipleClassNames()
	{
		h1.addClass('first');
		h1.addClass('second');
		h1.addClass('fourth');
		h1.addClass('fifth');
		Assert.isTrue(h1.hasClass("first"));
		Assert.isTrue(h1.hasClass("second"));
		Assert.isFalse(h1.hasClass("third"));
		Assert.isTrue(h1.hasClass("fourth"));

		h1.removeClass('fourth fifth first');

		Assert.equals("second", h1.attr('class'));
	}

	public function testRemoveClassWhereSomeDoNotExist()
	{
		Assert.isFalse(h1.hasClass("third"));
		h1.removeClass('third');
		Assert.isFalse(h1.hasClass("third"));


		h1.addClass('first');
		h1.addClass('second');
		h1.addClass('fourth');
		h1.addClass('fifth');
		Assert.isTrue(h1.hasClass("first"));
		Assert.isTrue(h1.hasClass("second"));
		Assert.isFalse(h1.hasClass("third"));
		Assert.isTrue(h1.hasClass("fourth"));

		h1.removeClass('fourth fifth third first');

		Assert.equals("second", h1.attr('class'));
	}

	public function testRemoveClassOnNull()
	{
		nullDOMCollection.removeClass('myclass');
		Assert.isFalse(nullDOMCollection.hasClass('myclass'));
	}

	public function testRemoveClassOnEmpty()
	{
		emptyCollection.removeClass('myclass');
		Assert.isFalse(emptyCollection.hasClass('myclass'));
	}

	public function testToggleClass()
	{
		// It doesn't exist, toggle it on
		Assert.isFalse(h1.hasClass('first'));
		h1.toggleClass('first');
		Assert.isTrue(h1.hasClass('first'));

		// it does exist, toggle it off
		Assert.isTrue(h1.hasClass('first'));
		h1.toggleClass('first');
		Assert.isFalse(h1.hasClass('first'));

		Assert.equals("", h1.attr('class'));
	}

	public function testToggleClassMultipleClassNames()
	{
		h1.toggleClass('first second fourth fifth');
		Assert.isTrue(h1.hasClass('first second fourth fifth'));
		Assert.isFalse(h1.hasClass('third'));

		h1.toggleClass('second third fourth');
		Assert.isTrue(h1.hasClass('first third fifth'));
		Assert.isFalse(h1.hasClass('second fourth'));

		Assert.equals('first fifth third', h1.attr('class'));
	}

	public function testToggleClassOnNull()
	{
		nullDOMCollection.toggleClass('myclass');
		Assert.isFalse(nullDOMCollection.hasClass('myclass'));

		// no matter which side of the toggle this should return false
		nullDOMCollection.toggleClass('myclass');
		Assert.isFalse(nullDOMCollection.hasClass('myclass'));
	}

	public function testToggleClassOnEmpty()
	{
		emptyCollection.toggleClass('myclass');
		Assert.isFalse(emptyCollection.hasClass('myclass'));

		// no matter which side of the toggle this should return false
		emptyCollection.toggleClass('myclass');
		Assert.isFalse(emptyCollection.hasClass('myclass'));
	}

	public function testTagName()
	{
		Assert.equals("h1", h1.tagName());
		Assert.equals("ul", a.tagName());
		Assert.equals("div", emptyNode.tagName());
	}

	public function testTagNameOnNull()
	{
		Assert.equals("", nullDOMCollection.tagName());
	}

	public function testTagNameOnEmpty()
	{
		Assert.equals("", emptyCollection.tagName());
	}

	public function testTagNameOnMultiple()
	{
		var q = new DOMCollection();
		q.addCollection(lists);
		q.addCollection(listItems);

		Assert.equals("ul", q.tagName());
	}

	public function testVal()
	{
		// The actual reading of "val" is done in single.ElementManipulation
		// and we already have unit tests for that.
		// Keep this simple:
		// Make sure it reads the first Node in the set.

		var input1 = "<input type='text' value='attr' />".parse().getNode();
		var input2 = "<input type='text' value='attr' />".parse().getNode();
		#if js 
		Reflect.setField(input1, "value", "value1");
		Reflect.setField(input2, "value", "value2");
		#else 
		input1.setVal("value1");
		input2.setVal("value2");
		#end

		var q = new DOMCollection().add(input1).add(input2);

		Assert.equals("value1", q.val());
	}

	public function testValOnEmpty()
	{
		Assert.equals("", emptyCollection.val());
	}

	public function testValOnNull()
	{
		Assert.equals("", nullDOMCollection.val());
	}

	public function testSetVal()
	{
		// The actual setting of "val" is done in single.ElementManipulation
		// and we already have unit tests for that.
		// Keep this simple:
		// Make sure it sets for every element


		var input1 = "<input type='text' value='attr' />".parse().getNode();
		var input2 = "<input type='text' value='attr' />".parse().getNode();
		#if js
		// On Javascript this behaviour works with the javascript field "value"
		Reflect.setField(input1, "value", "value1");
		Reflect.setField(input2, "value", "value2");
		#else 
		// On other platforms, we use attributes
		input1.setAttr("value", "value1");
		input2.setAttr("value", "value2");
		#end

		var q = new DOMCollection().add(input1).add(input2);
		q.setVal("newValue");

		Assert.equals("newValue", q.val());
		Assert.equals("newValue", q.getNode(0).val());
		Assert.equals("newValue", q.getNode(1).val());
	}

	public function testSetValOnNull()
	{
		nullDOMCollection.setVal("newvalue");
		Assert.equals("", nullDOMCollection.val());
	}

	public function testSetValOnEmpty()
	{
		emptyCollection.setVal("newvalue");
		Assert.equals("", emptyCollection.val());
	}

	public function testTextOnSingle()
	{
		Assert.equals("Title", h1.text());
		Assert.equals("StartEnd", ".nonelements".find().text());
	}

	public function testTextOnMultiple()
	{
		Assert.equals("22", pickme.text());
		Assert.equals("123123", listItems.text());
		Assert.equals("StartEnd", textNodes.text());
		Assert.equals("Comment1Comment2", commentNodes.text());
		Assert.equals("StartComment1EndComment2", ".nonelements".find().children(false).text());
	}

	public function testTextOnNull()
	{
		Assert.equals("", nullDOMCollection.text());
	}

	public function testTextOnEmpty()
	{
		Assert.equals("", emptyCollection.text());
	}

	public function testSetText()
	{
		Assert.equals("123123", listItems.text());
		listItems.setText('a');
		Assert.equals("aaaaaa", listItems.text());
	}

	public function testSetTextOnNull()
	{
		nullDOMCollection.setText("My New Text");
		Assert.equals("", nullDOMCollection.text());
	}

	public function testSetTextOnEmpty()
	{
		emptyCollection.setText("My New Text");
		Assert.equals("", emptyCollection.text());
	}

	public function testInnerHTML() 
	{
		Assert.equals("123123", listItems.innerHTML());

		var html = ".nonelements".find().innerHTML();
		Assert.equals("Start<!--Comment1-->End<!--Comment2-->", html);

		Assert.isTrue(a.innerHTML().indexOf('</li>') > -1);
	}

	public function testInnerHTMLOnNull()
	{
		Assert.equals("", nullDOMCollection.innerHTML());
	}

	public function testInnerHTMLOnEmpty()
	{
		Assert.equals("", emptyCollection.innerHTML());
	}

	public function testSetInnerHTML()
	{
		Assert.equals("123123", listItems.innerHTML());
		listItems.setInnerHTML('a');
		Assert.equals("aaaaaa", listItems.innerHTML());

		// Check this is actually creating elements
		listItems.setInnerHTML('<a href="#">Link</a>');
		Assert.equals(listItems.length, listItems.find("a").length);
	}

	public function testSetInnerHTMLOnNull()
	{
		nullDOMCollection.setInnerHTML("My Inner HTML");
		Assert.equals("", nullDOMCollection.innerHTML());
	}

	public function testSetInnerHTMLOnEmpty()
	{
		emptyCollection.setInnerHTML("My Inner HTML");
		Assert.equals("", emptyCollection.innerHTML());
	}

	public function testHtml() 
	{
		// slight differences in toString() rendering between JS and Xml platforms
		var expected = "<li id='a1'>1</li><li id='a2' class='pickme'>2</li><li id='a3'>3</li><li id='b1'>1</li><li id='b2' class='pickme'>2</li><li id='b3'>3</li>";
		Assert.equals(expected.length, listItems.html().length);

		var html = ".nonelements".find().html();
		Assert.equals('<div class="nonelements">Start<!--Comment1-->End<!--Comment2--></div>', html);

		Assert.isTrue(a.html().indexOf('</li>') > -1);
	}

	public function testHtmlWithDifferentNodeTypes() 
	{
		// slight differences in toString() rendering between JS and Xml platforms
		// toString() seems to ignore empty text nodes...
		var expected = "<p>Text Node</p>  <p>  Text Node with Spaces  </p> <!-- Comment -->";
		var xml = expected.parse();
		var result = xml.html();
		Assert.equals(5, xml.length);
		Assert.equals(expected, result);
	}

	public function testHtmlOnNull()
	{
		Assert.equals("", nullDOMCollection.html());
	}

	public function testHtmlOnEmpty()
	{
		Assert.equals("", emptyCollection.html());
	}

	function testIndexNormal():Void 
	{
		// As long as it checks the index of the first node, we're good.
		Assert.equals(3, lists.index());
	}

	function testIndexNull():Void 
	{
		Assert.equals(-1, nullDOMCollection.index());
	}

	function testIndexEmpty():Void 
	{
		Assert.equals(-1, emptyCollection.index());
	}

	public function testChaining()
	{
		// Run every possible chaining command
		var returnValue = lists.setAttr("title", "hey").removeAttr("title")
			.addClass("mylist").removeClass("mylist").toggleClass("mylist")
			.setVal("value").setText("text").setInnerHTML("html");
		
		// Check that we're still looking at the same thing
		Assert.equals(2, returnValue.length);
		Assert.equals("a", returnValue.eq(0).attr('id'));
		Assert.equals("b", returnValue.eq(1).attr('id'));
	}
}
