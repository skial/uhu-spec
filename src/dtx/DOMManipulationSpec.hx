package dtx;

import utest.Assert;

import Detox;
using Detox;
import dtx.DOMCollection;
import dtx.DOMNode;

class DOMManipulationSpec 
{
	public function new() 
	{
	}

	public var sampleDocument:DOMNode;
	public var h1:DOMNode;
	public var lists:DOMCollection;
	public var a:DOMNode;
	public var b:DOMNode;
	public var a2:DOMNode;
	public var nonElements:DOMNode;
	public var textNode1:DOMNode;
	public var comment:DOMNode;
	public var textNode2:DOMNode;
	public var emptyNode:DOMNode;
	public var nullNode:DOMNode;

	public var sampleNode:DOMNode;
	public var sampleListItem:DOMNode;
	public var sampleDOMCollection:DOMCollection;
	public var insertSiblingContentNode:DOMNode;
	public var insertSiblingContentDOMCollection:DOMCollection;
	public var insertSiblingTargetNode:DOMNode;
	public var insertSiblingTargetDOMCollection:DOMCollection;
	
	@Before
	public function setup():Void
	{
		sampleDocument = "<myxml>
			<h1>Title</h1>
			<ul id='a'>
				<li id='a1'>1</li>
				<li id='a2'>2</li>
				<li id='a3'>3</li>
			</ul>
			<ul id='b'>
				<li id='b1'>1</li>
				<li id='b2'>2</li>
				<li id='b3'>3</li>
			</ul>
			<div id='nonelements'>Start<!--Comment-->End</div>
			<div id='empty'></div>
		</myxml>".parse().getNode();

		Detox.setDocument(sampleDocument);

		h1 = "h1".find().getNode();
		lists = "ul".find();
		a = "#a".find().getNode();
		b = "#b".find().getNode();
		a2 = "#a2".find().getNode();
		nonElements = "#nonelements".find().getNode();
		textNode1 = nonElements.children(false).getNode(0);
		comment = nonElements.children(false).getNode(1);
		textNode2 = nonElements.children(false).getNode(2);
		emptyNode = "#empty".find().getNode();
		nullNode = null;

		sampleNode = "<i>Element</i>".parse().getNode();
		sampleListItem = "<li class='sample'>Sample</li>".parse().getNode();
		sampleDOMCollection = "<p class='1'><i class='target'>i</i></p><p class='2'><i class='target'>i</i></p>".parse();
		sampleDocument.append(sampleDOMCollection);

		insertSiblingTargetDOMCollection = sampleDOMCollection.find('i.target');
		insertSiblingTargetNode = sampleDOMCollection.first().find('i.target').getNode();
		insertSiblingContentDOMCollection = "<b class='content'>1</b><b class='content'>2</b>".parse();
		insertSiblingContentNode = insertSiblingContentDOMCollection.getNode(0);
	}
	
	@After
	public function tearDown():Void
	{
		// trace ("Tear Down");
	}

	public function testAppendNode()
	{
		// To start with, there is no .sample
		Assert.equals(0, a.find(".sample").length);
		a.append(sampleListItem);

		// Now it should exist, and it should be the fourth child of it's parent
		Assert.equals(1, a.find(".sample").length);
		Assert.isTrue(sampleListItem == a.children().getNode(3));
	}

	public function testAppendNodeThatIsAlreadyAttached()
	{
		Assert.equals(a.html(), a2.parents().html());
		Assert.equals(0, b.find('#a2').length);
		Assert.equals(3, a.children().length);
		Assert.equals(3, b.children().length);

		b.append(a2);

		Assert.equals(b.html(), a2.parents().html());
		Assert.equals(0, a2.find('#a2').length);
		Assert.equals(2, a.children().length);
		Assert.equals(4, b.children().length);
	}

	public function testAppendCollection()
	{
		emptyNode.append(sampleNode);
		Assert.equals(1, emptyNode.children().length);
		Assert.equals(1, emptyNode.find("i").length);

		emptyNode.append(sampleDOMCollection);

		Assert.equals(3, emptyNode.children().length);
		Assert.equals(2, emptyNode.find("p").length);
		Assert.isTrue(sampleDOMCollection.getNode(0) == emptyNode.children().getNode(1));
		Assert.isTrue(sampleDOMCollection.getNode(1) == emptyNode.children().getNode(2));
	}

	public function testAppendOnNull()
	{
		nullNode.append(sampleNode);
		Assert.notNull(sampleNode.parents());
	}

	public function testAppendNull()
	{
		Assert.equals("", emptyNode.innerHTML());
		emptyNode.append(null);
		Assert.equals("", emptyNode.innerHTML());
	}

	public function testPrependNode()
	{
		// To start with, there is no .sample
		Assert.equals(0, a.find(".sample").length);
		a.prepend(sampleListItem);

		// Now it should exist, and it should be the first child of it's parent
		Assert.equals(1, a.find(".sample").length);
		Assert.isTrue(sampleListItem == a.children().getNode(0));
	}

	public function testPrependCollection()
	{
		emptyNode.append(sampleNode);
		Assert.equals(1, emptyNode.children().length);
		Assert.equals(1, emptyNode.find("i").length);

		emptyNode.prepend(sampleDOMCollection);
		Assert.equals(3, emptyNode.children().length);
		Assert.equals(2, emptyNode.find("p").length);
		Assert.isTrue(sampleDOMCollection.getNode(0) == emptyNode.children().getNode(0));
		Assert.isTrue(sampleDOMCollection.getNode(1) == emptyNode.children().getNode(1));
	}

	public function testPrependOnNull()
	{
		nullNode.prepend(sampleNode);
		Assert.notNull(sampleNode.parents());
	}

	public function testPrependOnEmpty()
	{
		emptyNode.prepend(sampleNode);
		Assert.equals(1, emptyNode.children().length);
	}

	public function testPrependNull()
	{
		Assert.equals("", emptyNode.innerHTML());
		emptyNode.prepend(null);
		Assert.equals("", emptyNode.innerHTML());
	}

	public function testAppendTo_Node()
	{
		// To start with, there is no .sample
		Assert.equals(0, a.find(".sample").length);
		sampleListItem.appendTo(a);

		// Now it should exist, and it should be the fourth child of it's parent
		Assert.equals(1, a.find(".sample").length);
		Assert.isTrue(sampleListItem == a.children().getNode(3));
	}

	public function testAppendTo_Collection()
	{
		Assert.equals(3, a.children().length);
		Assert.equals(0, a.find(".sample").length);
		Assert.equals(3, b.children().length);
		Assert.equals(0, b.find(".sample").length);

		sampleListItem.appendTo(lists);

		Assert.equals(4, a.children().length);
		Assert.equals(4, b.children().length);
		Assert.equals(1, a.find(".sample").length);
		Assert.equals(1, b.find(".sample").length);
		Assert.isTrue(a.children().getNode(3).hasClass('sample'));
		Assert.isTrue(a.children().getNode(3).hasClass('sample'));
	}

	public function testAppendTo_OnNull()
	{
		Assert.equals("", emptyNode.innerHTML());
		nullNode.appendTo(emptyNode);
		Assert.equals("", emptyNode.innerHTML());
	}

	public function testAppendTo_Null()
	{
		emptyNode.appendTo(null);
		Assert.notNull(emptyNode.parents());
	}

	public function testPrependTo_Node()
	{
		// To start with, there is no .sample
		Assert.equals(0, a.find(".sample").length);
		sampleListItem.prependTo(a);

		// Now it should exist, and it should be the first child of it's parent
		Assert.equals(1, a.find(".sample").length);
		Assert.isTrue(sampleListItem == a.children().getNode(0));
	}

	public function testPrependTo_OnEmpty()
	{
		sampleNode.prependTo(emptyNode);
		Assert.equals(1, emptyNode.children().length);
	}

	public function testPrependTo_Collection()
	{
		Assert.equals(3, a.children().length);
		Assert.equals(0, a.find(".sample").length);
		Assert.equals(3, b.children().length);
		Assert.equals(0, b.find(".sample").length);

		sampleListItem.prependTo(lists);

		Assert.equals(4, a.children().length);
		Assert.equals(4, b.children().length);
		Assert.equals(1, a.find(".sample").length);
		Assert.equals(1, b.find(".sample").length);
		Assert.isTrue(a.children().getNode(0).hasClass('sample'));
		Assert.isTrue(a.children().getNode(0).hasClass('sample'));
	}

	public function testPrependTo_OnNull()
	{
		Assert.equals("", emptyNode.innerHTML());
		nullNode.prependTo(emptyNode);
		Assert.equals("", emptyNode.innerHTML());
	}

	public function testPrependTo_Null()
	{
		emptyNode.prependTo(null);
		Assert.notNull(emptyNode.parents());
	}

	public function testInsertThisBefore_Node()
	{
		insertSiblingContentNode.insertThisBefore(insertSiblingTargetNode);

		// content should be first child, target second
		Assert.isTrue(insertSiblingContentNode == sampleDOMCollection.eq(0).children().getNode(0));
		Assert.isTrue(insertSiblingTargetNode == sampleDOMCollection.eq(0).children().getNode(1));
	}

	public function testInsertThisBefore_Collection()
	{
		var div1 = sampleDOMCollection.eq(0);
		var div2 = sampleDOMCollection.eq(1);

		// they should start with 1 child each
		Assert.equals(1, div1.children().length);
		Assert.equals(1, div2.children().length);
		
		insertSiblingContentNode.insertThisBefore(insertSiblingTargetDOMCollection);

		// they should end with 2 children each
		Assert.equals(2, div1.children().length);
		Assert.equals(2, div2.children().length);

		// the innerHTML should be the same
		Assert.equals(div1.innerHTML(), div2.innerHTML());

		// check the order: should be content first, then target
		Assert.isTrue(insertSiblingContentNode == div1.children().getNode(0));
		Assert.isTrue(insertSiblingTargetDOMCollection.getNode(0) == div1.children().getNode(1));
		
		Assert.isTrue(insertSiblingTargetDOMCollection.getNode(1) == div2.children().getNode(1));
		// This final one is a clone, so it won't be exactly equal, but it should be identical
		Assert.equals(insertSiblingContentNode.innerHTML(), div2.children().getNode(0).innerHTML());
		Assert.equals(insertSiblingContentNode.attr('class'), div2.children().getNode(0).attr('class'));
	}

	public function testInsertThisBefore_OnNull()
	{
		nullNode.insertThisBefore(a2);
		Assert.equals(0, a.find('.sample').length);
	}

	public function testInsertThisBefore_Null()
	{
		a2.insertThisBefore(nullNode);
		Assert.isTrue(a == a2.parents());
	}

	public function testInsertThisAfter_Node()
	{
		insertSiblingContentNode.insertThisAfter(insertSiblingTargetNode);

		// First node should be target, second should be content
		Assert.isTrue(insertSiblingTargetNode == sampleDOMCollection.eq(0).children().getNode(0));
		Assert.isTrue(insertSiblingContentNode == sampleDOMCollection.eq(0).children().getNode(1));
	}

	public function testInsertThisAfter_Collection()
	{
		var div1 = sampleDOMCollection.eq(0);
		var div2 = sampleDOMCollection.eq(1);

		// they should start with 1 child each
		Assert.equals(1, div1.children().length);
		Assert.equals(1, div2.children().length);

		insertSiblingContentNode.insertThisAfter(insertSiblingTargetDOMCollection);

		// they should end with 2 children each
		Assert.equals(2, div1.children().length);
		Assert.equals(2, div2.children().length);

		// the innerHTML should be the same
		Assert.equals(div1.innerHTML(), div2.innerHTML());

		// check the order: should be target first, then content
		Assert.isTrue(insertSiblingTargetDOMCollection.getNode(0) == div1.children().getNode(0));
		Assert.isTrue(insertSiblingContentNode == div1.children().getNode(1));
		Assert.isTrue(insertSiblingTargetDOMCollection.getNode(1) == div2.children().getNode(0));
		// This final one is a clone, so it won't be exactly equal, but it should be identical
		Assert.equals(insertSiblingContentNode.innerHTML(), div2.children().getNode(1).innerHTML());
		Assert.equals(insertSiblingContentNode.attr('class'), div2.children().getNode(1).attr('class'));
	}

	public function testInsertThisAfter_OnNull()
	{
		var before = a.innerHTML();
		nullNode.insertThisAfter(a2);
		Assert.isTrue(before == a.innerHTML());
	}

	public function testInsertThisAfter_Null()
	{
		a2.insertThisAfter(nullNode);
		Assert.isTrue(a == a2.parents());
	}

	public function testBeforeThisInsert_Node()
	{
		insertSiblingTargetNode.beforeThisInsert(insertSiblingContentNode);

		// First node should be content, second should be target
		Assert.isTrue(insertSiblingContentNode == sampleDOMCollection.eq(0).children().getNode(0));
		Assert.isTrue(insertSiblingTargetNode == sampleDOMCollection.eq(0).children().getNode(1));
	}

	public function testBeforeThisInsert_Collection()
	{
		insertSiblingTargetNode.beforeThisInsert(insertSiblingContentDOMCollection);

		// first and second should be content, third should be target
		Assert.equals(3, sampleDOMCollection.eq().children().length);
		Assert.isTrue(insertSiblingContentDOMCollection.getNode(0) == sampleDOMCollection.eq(0).children().getNode(0));
		Assert.isTrue(insertSiblingContentDOMCollection.getNode(1) == sampleDOMCollection.eq(0).children().getNode(1));
		Assert.isTrue(insertSiblingTargetNode == sampleDOMCollection.eq(0).children().getNode(2));
	}

	public function testBeforeThisInsert_OnNull()
	{
		nullNode.beforeThisInsert(a2);
		Assert.isTrue(a == a2.parents());
	}

	public function testBeforeThisInsert_Null()
	{
		a2.beforeThisInsert(nullNode);
		Assert.isNull(nullNode.parents());
	}

	public function testAfterThisInsert_Node()
	{
		insertSiblingTargetNode.afterThisInsert(insertSiblingContentNode);

		// First node should be target, second should be content
		Assert.isTrue(insertSiblingTargetNode == sampleDOMCollection.eq(0).children().getNode(0));
		Assert.isTrue(insertSiblingContentNode == sampleDOMCollection.eq(0).children().getNode(1));
	}

	public function testAfterThisInsert_Collection()
	{
		insertSiblingTargetNode.afterThisInsert(insertSiblingContentDOMCollection);

		// first should be target, second and third content
		Assert.equals(3, sampleDOMCollection.eq().children().length);
		Assert.isTrue(insertSiblingTargetNode == sampleDOMCollection.eq(0).children().getNode(0));
		Assert.isTrue(insertSiblingContentDOMCollection.getNode(0) == sampleDOMCollection.eq(0).children().getNode(1));
		Assert.isTrue(insertSiblingContentDOMCollection.getNode(1) == sampleDOMCollection.eq(0).children().getNode(2));
	}

	public function testAfterThisInsert_OnNull()
	{
		nullNode.afterThisInsert(a2);
		Assert.isTrue(a == a2.parents());
	}

	public function testAfterThisInsert_Null()
	{
		var before = a.innerHTML();
		a2.afterThisInsert(null);
		Assert.isTrue(before == a.innerHTML());
	}

	public function testAfterThisInsert_CheckReference()
	{
		Assert.equals("Start<!--Comment-->End", nonElements.innerHTML());
		Assert.equals(3, nonElements.children(false).length);
		Assert.equals(7, a.children(false).length);

		// Move it to a different location
		a2.afterThisInsert(comment);

		Assert.equals("StartEnd", nonElements.innerHTML());
		Assert.equals(2, nonElements.children(false).length);
		Assert.equals(8, a.children(false).length);

		// Update the inner text, and check the new location updates
		comment.setInnerHTML("Two");

		Assert.equals("<!--Two-->", a.find("#a2").next(false).html());
	}

	public function testAfterThisInsert_CheckReferenceDOM()
	{
		// Start with a collection, things labelled "before"
		insertSiblingTargetDOMCollection.setInnerHTML("BEFORE");
		Assert.equals(7, a.children(false).length);

		// Move it to a different location
		a2.afterThisInsert(insertSiblingTargetDOMCollection);
		Assert.equals(9, a.children(false).length);
		Assert.equals("BEFOREBEFORE", a.find("i.target").text());

		// Update the inner text, and check the new location updates
		insertSiblingTargetDOMCollection.setInnerHTML("AFTER");
		Assert.equals(9, a.children(false).length);
		Assert.equals("AFTERAFTER", a.find("i.target").text());
	}

	public function testRemoveFromDOM()
	{
		Assert.equals(3, a.children().length);
		"#a1".find().getNode().removeFromDOM();

		Assert.equals(2, a.children().length);
		"#a2".find().getNode().removeFromDOM();

		Assert.equals(1, a.children().length);
		"#a3".find().getNode().removeFromDOM();

		Assert.equals(0, a.children().length);
	}

	public function testRemove_onNull()
	{
		Assert.equals(null, nullNode.removeFromDOM());
	}

	public function testRemoveChildren_Node()
	{
		Assert.equals(3, a.children().length);
		a.removeChildren("#a1".find().getNode());

		Assert.equals(2, a.children().length);
		a.removeChildren("#a2".find().getNode());

		Assert.equals(1, a.children().length);
		a.removeChildren("#a3".find().getNode());

		Assert.equals(0, a.children().length);
	}

	public function testRemoveChildren_Collection()
	{
		Assert.equals(3, a.children().length);
		a.removeChildren("#a li".find());

		Assert.equals(0, a.children().length);
	}

	public function testRemoveChildren_Null()
	{
		var original = a.innerHTML();
		a.removeChildren(null);

		// check nothing changed
		Assert.isTrue(original == a.innerHTML());
	}

	public function testRemoveChildren_OnNull()
	{
		nullNode.removeChildren(emptyNode);
		Assert.isNull(nullNode);
	}

	public function testRemoveChildren_ThatAreNotActuallyChildren()
	{
		var original = a.innerHTML();
		a.removeChildren(h1);

		// check nothing changed
		Assert.isTrue(original == a.innerHTML());
	}

	public function testReplaceWith_Node()
	{
		insertSiblingTargetNode.replaceWith(insertSiblingContentNode);

		// target should be removed, have no parent. Content should be in place, with correct html
		Assert.isNull(insertSiblingTargetNode.parents());		
		Assert.equals('<p class="1"><b class="content">1</b></p><p class="2"><i class="target">i</i></p>', sampleDOMCollection.html());
	}

	public function testReplaceWith_Collection()
	{
		insertSiblingTargetNode.replaceWith(insertSiblingContentDOMCollection);

		// target should be removed, have no parent. All content should be in place, correct HTML
		Assert.isNull(insertSiblingTargetNode.parents());
		Assert.equals('<p class="1"><b class="content">1</b><b class="content">2</b></p><p class="2"><i class="target">i</i></p>', sampleDOMCollection.html());
	}

	public function testReplaceWith_OnNull()
	{
		var before = a.innerHTML();
		nullNode.replaceWith(a2);

		// Nothing has changed
		Assert.isTrue(before == a.innerHTML());
	}

	public function testReplaceWith_Null()
	{
		var before = a.innerHTML();
		a2.replaceWith(null);

		// a2 should be gone
		Assert.equals(1, a.find("#a1").length);
		Assert.equals(0, a.find("#a2").length);
		Assert.equals(1, a.find("#a3").length);
		Assert.equals(2, a.children().length);
	}

	public function testEmpty()
	{
		Assert.equals(3, a.children().length);
		a.empty();
		Assert.equals(0, a.children().length);
	}

	public function testEmptyOnNull()
	{
		nullNode.empty();
		Assert.isNull(nullNode);
	}

	/*public function testChaining()
	{
		sampleDocument.append().prepend()
			.appendTo().prependTo()
			.insertThisBefore().insertThisAfter()
			.beforeThisInsert().afterThisInsert()
			.removeFromDOM().removeChildren().empty();

	}*/

}
