package dtx;

import utest.Assert;

import Detox;
using Detox;
import dtx.DOMCollection;
import dtx.DOMNode;
#if macro 
	import haxe.macro.Expr;
#end

class CollectionTraversingSpec 
{
	public function new() 
	{
	}

	var sampleDocument:DOMCollection;
	var nullDOMCollection:DOMCollection;
	var emptyDOMCollection:DOMCollection;
	
	@Before
	public function setup():Void
	{
		var sampleDocument = "<myxml>
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
		</myxml>".parse();
		nullDOMCollection = null;
		emptyDOMCollection = new DOMCollection();

		Detox.setDocument(sampleDocument.getNode());

	}
	
	@After
	public function tearDown():Void
	{
		// trace ("Tear Down");
	}

	public function testChildren_normal()
	{
		var q1 = 'ul'.find().children();
		Assert.equals(8, q1.length);
	}

	public function testChildren_elementsOnly()
	{
		var q1 = '#nonElements'.find().children();
		var q2 = '#nonElements'.find().children(false);
		Assert.equals(0, q1.length);
		Assert.equals(3, q2.length);
	}

	public function testChildren_onNull()
	{
		Assert.equals(0, nullDOMCollection.children().length);
	}

	public function testChildren_onEmptyParent()
	{
		var q1 = ".empty".find();
		Assert.equals(2, q1.length);
		Assert.equals(0, q1.children().length);
	}

	public function testChildren_onEmptyCollection()
	{
		Assert.equals(0, emptyDOMCollection.children().length);
	}

	public function testFirstChildren()
	{
		var q1 = "ul".find().firstChildren();
		Assert.equals(2, q1.length);
		Assert.equals("a1", q1.eq(0).attr('id'));
		Assert.equals("b1", q1.eq(1).attr('id'));
	}

	public function testFirstChildren_elementsOnly()
	{
		var q1 = '#nonElements'.find().firstChildren();
		var q2 = '#nonElements'.find().firstChildren(false);
		Assert.equals(0, q1.length);
		Assert.equals(1, q2.length);
	}

	public function testFirstChildren_onNull()
	{
		Assert.equals(0, nullDOMCollection.firstChildren().length);
	}

	public function testFirstChildren_onEmptyParent()
	{
		var q1 = ".empty".find();
		Assert.equals(2, q1.length);
		Assert.equals(0, q1.firstChildren().length);
	}

	public function testFirstChildren_onEmptyCollection()
	{
		Assert.equals(0, emptyDOMCollection.firstChildren().length);
	}

	public function testLastChildren()
	{
		var q1 = "ul".find().lastChildren();
		Assert.equals(2, q1.length);
		Assert.equals("a4", q1.eq(0).attr('id'));
		Assert.equals("b4", q1.eq(1).attr('id'));
	}

	public function testLastChildren_elementsOnly()
	{
		var q1 = '#nonElements'.find().lastChildren();
		var q2 = '#nonElements'.find().lastChildren(false);
		Assert.equals(0, q1.length);
		Assert.equals(1, q2.length);
	}

	public function testLastChildren_onNull()
	{
		Assert.equals(0, nullDOMCollection.lastChildren().length);
	}

	public function testLastChildren_onEmptyCollection()
	{
		Assert.equals(0, emptyDOMCollection.lastChildren().length);
	}

	public function testLastChildren_onEmptyParent()
	{
		var q1 = ".empty".find();
		Assert.equals(2, q1.length);
		Assert.equals(0, q1.lastChildren().length);
	}

	public function testParent()
	{
		var l4 = ".level4".find();
		Assert.isTrue(l4.parent().hasClass('level3'));
	}

	public function testParent_onNull()
	{
		Assert.equals(0, nullDOMCollection.parent().length);
	}

	public function testParent_onEmptyCollection()
	{
		Assert.equals(0, emptyDOMCollection.parent().length);
	}

	/*public function testParent_onElementWithNoParent()
	{
		// eg Document
		#if js 
		var doc:DOMNode = untyped __js__('document');
		#else 
		var doc = Xml.createDocument();
		#end
		var q = new DOMCollection([doc]);
		Assert.equals(0, q.parent().length);
	}*/

	public function testAncestors()
	{
		var l4 = ".level4".find();
		var a = l4.ancestors();
		Assert.equals(4, a.length);
		Assert.isTrue(a.eq(0).hasClass('level3'));
		Assert.isTrue(a.eq(1).hasClass('level2'));
		Assert.isTrue(a.eq(2).hasClass('level1'));
		Assert.equals("myxml", a.eq(3).tagName());
	}

	public function testAncestors_onNull()
	{
		Assert.equals(0, nullDOMCollection.ancestors().length);
	}

	public function testAncestors_onEmptyCollection()
	{
		Assert.equals(0, emptyDOMCollection.ancestors().length);
	}

	/*public function testAncestors_onElementWithNoParents()
	{
		// eg Document
		#if js
		var doc:DOMNode = untyped __js__('document');
		#else 
		var doc = Xml.createDocument();
		#end
		var q = new DOMCollection([doc]);
		var a = q.ancestors();
		Assert.equals(0, a.length);
	}*/

	public function testDescendants()
	{
		Assert.equals(8, "ul".find().descendants().length);
		Assert.equals(3, "div".find().descendants().length);
		Assert.equals(3, "#recursive".find().descendants().length);
	}

	public function testDescendantsElementsOnly()
	{
		Assert.equals(26, "ul".find().descendants(false).length);
		Assert.equals(10, "#recursive".find().descendants(false).length);
	}

	public function testDescendantsOnNull()
	{
		Assert.equals(0, nullDOMCollection.descendants().length);
	}

	public function testDescendantsOnNonElement()
	{
		Assert.equals(0, "#nonElements".find().children().descendants().length);
	}

	public function testDescendantsOnNoDescendants()
	{
		Assert.equals(0, ".empty".find().descendants().length);
	}

	public function testNext()
	{
		for (li in ".pickme".find())
		{
			Assert.equals("3", li.toCollection().next().text());
		}
	}

	public function testNext_onNull()
	{
		Assert.equals(0, nullDOMCollection.next().length);
	}

	public function testNext_onEmpty()
	{
		Assert.equals(0, emptyDOMCollection.next().length);
	}

	public function testNext_onLast()
	{
		var q = new DOMCollection();
		q.addCollection('#a4'.find()); // no next()
		q.addCollection('#b4'.find()); // no next()
		q.addCollection('#b3'.find()); // next() = '#b4'
		Assert.equals(1, q.next().length);
		Assert.equals("b4", q.next().first().attr('id'));
	}

	public function testNext_elementsOnly()
	{
		var children = "#nonElements".find().children(false);
		var comment = children.eq(1);

		Assert.equals("Comment", comment.val());
		Assert.equals("After", comment.next(false).val());
		Assert.equals(0, comment.next().length);
	}

	public function testPrev()
	{
		for (li in ".pickme".find())
		{
			Assert.equals("1", li.toCollection().prev().text());
		}
	}

	public function testPrev_onNull()
	{
		Assert.equals(0, nullDOMCollection.prev().length);
	}

	public function testPrev_onEmpty()
	{
		Assert.equals(0, emptyDOMCollection.prev().length);
	}

	public function testPrev_onFirst()
	{
		var q = new DOMCollection();
		q.addCollection('#a1'.find()); // no prev()
		q.addCollection('#b1'.find()); // no prev()
		q.addCollection('#b2'.find()); // prev() = '#b1'
		Assert.equals(1, q.prev().length);
		Assert.equals("b1", q.prev().first().attr('id'));
	}

	public function testPrev_elementsOnly()
	{
		var children = "#nonElements".find().children(false);
		var comment = children.eq(1);

		Assert.equals("Comment", comment.val());
		Assert.equals("Before", comment.prev(false).val());
		Assert.equals(0, comment.prev().length);
	}

	public function testFind()
	{
		var q = "ul".find();
		Assert.equals(8, q.find('li').length);
		Assert.equals(2, q.find('.pickme').length);
		Assert.equals(1, q.find('#a1').length);
	}

	public function testFind_onNull()
	{
		Assert.equals(0, nullDOMCollection.find('li').length);
	}

	public function testFind_onEmpty()
	{
		Assert.equals(0, emptyDOMCollection.find('li').length);
	}

	public function testFind_nullInput()
	{
		var q = "ul".find();
		Assert.equals(0, q.find(null).length);
	}

	public function testFind_blankInput()
	{
		var q = "ul".find();
		Assert.equals(0, q.find('').length);
	}

	public function testFind_onNothingFound()
	{
		var q = "ul".find();
		Assert.equals(0, q.find('video').length);
	}

	public function testFindInMacros()
	{
		Assert.equals("Two", macroFind());
	}

	static macro function macroFind():ExprOf<String> {
		var doc = "<doc><ul><li>One</li><li class='special'>Two</li></ul></doc>".parse();
		var text = doc.find("li.special").text();
		return macro $v{text};
	}
}
