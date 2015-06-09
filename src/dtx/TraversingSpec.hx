package dtx;

import utest.Assert;

import Detox;
using Detox;
import dtx.DOMCollection;
import dtx.DOMNode;
#if macro 
	import haxe.macro.Expr;
#end

using StringTools;

class TraversingSpec 
{
	public function new() 
	{
	}

	public var sampleDocument:DOMNode;
	public var h1:DOMNode;
	public var a:DOMNode;
	public var b:DOMNode;
	public var emptyNode:DOMNode;
	public var nullNode:DOMNode;
	public var textNode1:DOMNode;
	public var textNode2:DOMNode;
	public var commentNode:DOMNode;
	public var recursive:DOMNode;
	
	public function setup():Void
	{
		sampleDocument = "<myxml>
			<h1>Title</h1>
			<ul id='a'>
				<li id='a1'>1</li>
				<li id='a2' class='pickme'>2</li>
				<li id='a3'>3</li>
				<li id='a4'>4</li>
			</ul>
			<ul id='b'>
				<li id='b1'>1</li>
				<li id='b2' class='pickme'>2</li>
				<li id='b3'>3</li>
				<li id='b4'>4</li>
			</ul>
			<div id='empty1' class='empty'></div>
			<div id='empty2' class='empty'></div>
			<div id='nonElements'>Before<!--Comment-->After</div>
			<div id='recursive' class='level1'>
				<div class='level2'>
					<div class='level3'>
						<div class='level4'>
						</div>
					</div>
				</div>
			</div>
		</myxml>".parse().getNode();
		Detox.setDocument(sampleDocument);

		h1 = "h1".find().getNode();
		a = "#a".find().getNode();
		b = "#b".find().getNode();
		emptyNode = "#empty1".find().getNode();
		nullNode = null;
		var nonElements = "#nonElements".find().children(false);
		textNode1 = nonElements.getNode(0);
		commentNode = nonElements.getNode(1);
		textNode2 = nonElements.getNode(2);
		recursive = "#recursive".find().getNode();
	}
	
	public function tearDown():Void
	{
		// trace ("Tear Down");
	}

	public function testChildren()
	{
		Assert.equals(4, a.children().length);
		Assert.equals(4, b.children().length);
		Assert.equals(7, sampleDocument.children().length);
	}

	public function testChildrenOnNull()
	{
		Assert.equals(0, nullNode.children().length);
	}

	public function testChildrenOnNonElement()
	{
		Assert.equals(0, textNode1.children().length);
		Assert.equals(0, textNode2.children().length);
		Assert.equals(0, commentNode.children().length);
	}

	public function testChildrenElementsOnly()
	{
		Assert.equals(0, h1.children().length);
		Assert.equals(1, h1.children(false).length);
	}

	public function testChildrenOnEmptyElement()
	{
		Assert.equals(0, emptyNode.children().length);
	}

	public function testFirstChildren()
	{
		Assert.equals("a1", a.firstChildren().attr('id'));
		Assert.equals("b1", b.firstChildren().attr('id'));
		var level2 = ".level2".find().getNode();
		Assert.equals("level3", level2.firstChildren().attr('class'));
	}

	public function testFirstChildrenOnNull()
	{
		Assert.isNull(nullNode.firstChildren());
	}

	public function testFirstChildrenOnEmptyElm()
	{
		Assert.isNull(emptyNode.firstChildren());
	}

	public function testFirstChildrenOnNonElement()
	{
		Assert.isNull(textNode1.firstChildren());
		Assert.isNull(textNode2.firstChildren());
		Assert.isNull(commentNode.firstChildren());
	}

	public function testFirstChildrenElementsOnly()
	{
		Assert.isNull(h1.firstChildren());
		Assert.equals("Title", h1.firstChildren(false).text());
	}

	public function testLastChildren()
	{
		Assert.equals("a4", a.lastChildren().attr('id'));
		Assert.equals("b4", b.lastChildren().attr('id'));
		var level2 = ".level2".find().getNode();
		Assert.equals("level3", level2.lastChildren().attr('class'));
	}

	public function testLastChildrenOnNull()
	{
		Assert.isNull(nullNode.lastChildren());
	}

	public function testLastChildrenOnEmptyElm()
	{
		Assert.isNull(emptyNode.lastChildren());
	}

	public function testLastChildrenOnNonElement()
	{
		Assert.isNull(textNode1.lastChildren());
		Assert.isNull(textNode2.lastChildren());
		Assert.isNull(commentNode.lastChildren());
	}

	public function testLastChildrenElementsOnly()
	{
		Assert.isNull(h1.firstChildren());
		Assert.equals("Title", h1.firstChildren(false).text());
	}

	public function testParent()
	{
		Assert.isTrue(a == "#a1".find().getNode().parents());
		Assert.isTrue(".level4".find().getNode().parents().hasClass('level3'));
		Assert.equals("nonElements", textNode1.parents().attr('id'));
		Assert.equals("nonElements", textNode2.parents().attr('id'));
		Assert.equals("nonElements", commentNode.parents().attr('id'));
	}

	public function testParentOnNull()
	{
		// When we use XML, parent is already a method of the object,
		// so our "using Detox" parents() doesn't get called.
		// As a result, we loose null-safety.  The workaround is to 
		// use parents() instead.
		Assert.isNull(nullNode.parents());
	}

	/*public function testParentOnParentNull()
	{
		#if js
		var doc:DOMNode = untyped __js__('document');
		#else 
		var doc = Xml.createDocument();
		#end
		Assert.isNull(doc.parents());
		Assert.isNull(sampleDocument.parents());
	}*/

	public function testAncestors()
	{
		var level4 = ".level4".find().getNode();
		var level3 = ".level3".find().getNode();
		var level2 = ".level2".find().getNode();
		var level1 = ".level1".find().getNode();
		var textNode = h1.children(false).getNode();

		Assert.equals(4, level4.ancestors().length);
		Assert.equals(3, level3.ancestors().length);
		Assert.equals(2, level2.ancestors().length);
		Assert.equals(1, level1.ancestors().length);
		Assert.equals(2, textNode.ancestors().length);
	}

	public function testAncestorsOnNull()
	{
		Assert.equals(0, nullNode.ancestors().length);
	}

	/*public function TestAncestorsOnParentNull()
	{
		#if js 
		var doc:DOMNode = untyped __js__('document');
		#else
		var doc = Xml.createDocument(); 
		#end 
		Assert.equals(0, doc.ancestors().length);
		Assert.equals(0, sampleDocument.ancestors().length);
	}*/

	public function testDescendants()
	{
		Assert.equals(4, a.descendants().length);
		Assert.equals(3, recursive.descendants().length);
	}

	public function testDescendantsElementsOnly()
	{
		Assert.equals(13, a.descendants(false).length);
		Assert.equals(10, recursive.descendants(false).length);
	}

	public function testDescendantsOnNull()
	{
		Assert.equals(0, nullNode.descendants().length);
	}

	public function testDescendantsOnNonElement()
	{
		Assert.equals(0, textNode1.descendants().length);
		Assert.equals(0, textNode2.descendants().length);
		Assert.equals(0, commentNode.descendants().length);
	}

	public function testDescendantsOnNoDescendants()
	{
		Assert.equals(0, emptyNode.descendants().length);
	}

	public function testNext()
	{
		var node1 = a.find('.pickme').getNode();
		var node2 = b.find('.pickme').getNode();
		Assert.equals('a3', node1.next().attr('id'));
		Assert.equals('b3', node2.next().attr('id'));
	}

	public function testNextElementOnly()
	{
		Assert.isNull(commentNode.next());
		Assert.notNull(commentNode.next(false));
		Assert.equals(textNode2.val(), commentNode.next(false).val());
	}

	public function testNextOnNull()
	{
		Assert.isNull(nullNode.next());
	}

	public function testNextWhenThereIsNoNext()
	{
		var lastLi = a.children().getNode(3);
		Assert.isNull(lastLi.next());
	}

	public function testPrev()
	{
		var node1 = a.find('.pickme').getNode();
		var node2 = b.find('.pickme').getNode();
		Assert.equals('a1', node1.prev().attr('id'));
		Assert.equals('b1', node2.prev().attr('id'));
	}

	public function testPrevElementOnly()
	{
		Assert.isNull(commentNode.prev());
		Assert.notNull(commentNode.prev(false));
		Assert.equals(textNode1.val(), commentNode.prev(false).val());
	}

	public function testPrevOnNull()
	{
		Assert.isNull(nullNode.prev());
	}

	public function testPrevWhenThereIsNoPrev()
	{
		var lastLi = a.children().getNode(0);
		Assert.isNull(lastLi.prev());
	}

	public function testFind()
	{
		Assert.notEquals(0, sampleDocument.find('*').length);
		Assert.equals(2, sampleDocument.find('ul').length);
		Assert.equals(7, sampleDocument.find('div').length);
		Assert.equals(1, sampleDocument.find('#a').length);
		var recursive = "#recursive".find().getNode();
		Assert.equals(1, recursive.find('.level4').length);
		Assert.equals(1, recursive.find('.level4').length);
		Assert.equals(3, recursive.find('div').length);
	}

	public function testFindTwice() 
	{
		var length1 = "#recursive".find().length;
		var length2 = "#recursive".find().length;
		Assert.equals(length1, length2);
	}

	public function testFindOnNull()
	{
		Assert.equals(0, nullNode.find('*').length);
	}

	public function testFindNoResults()
	{
		Assert.equals(0, sampleDocument.find('video').length);
	}

	public function testFindOnWrongNodeType()
	{
		Assert.equals(0, commentNode.find('ul').length);
	}

	public function testTestFindInMacros()
	{
		Assert.equals("Two", macroFind());
	}

	static macro function macroFind():ExprOf<String> {
		var doc = "<doc><ul><li>One</li><li class='special'>Two</li></ul></doc>".parse().getNode();
		var text = doc.find("li.special").text();
		return macro $v{text};
	}

	public function testChaining()
	{
		Assert.equals('b', a.firstChildren().lastChildren(false).parents().parents().next().attr('id'));
		Assert.equals('a', b.firstChildren().lastChildren(false).parents().parents().prev().attr('id'));
		Assert.equals('a1', a.find('li').attr('id'));
		Assert.equals('a1', a.children().attr('id'));
		Assert.equals('myxml', a.ancestors().tagName());
	}
}
