package dtx;

import utest.Assert;

import dtx.DOMCollection;
import dtx.DOMNode;
using Detox;

class CollectionSpec 
{
	public function new() 
	{
	}

	var sampleDocument:DOMCollection;
	var h1:DOMCollection;
	var lists:DOMCollection;
	var list1:DOMCollection;
	var list2:DOMCollection;
	var listItems:DOMCollection;
	
	public function setup():Void
	{
		// trace ("Setup");
		sampleDocument = "<myxml>
		<div>
			<h1>Title</h1>
			<ul id='a'>
				<li id='a1'>One A</li>
				<li id='a2'>Two A</li>
				<li id='a3'>Three A</li>
			</ul>
			<ul id='b'>
				<li id='b1'>One B</li>
				<li id='b2'>Two B</li>
				<li id='b3'>Three B</li>
			</ul>
		</div>
		<table>
			<thead>
				<tr>
					<th></th>
					<th>One</th>
					<th>Two</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<th>A</th>
					<td>One - A</td>
					<td>Two - A</td>
				</tr>
				<tr>
					<th>B</th>
					<td>One - B</td>
					<td>Two - B</td>
				</tr>
			</tbody>
		</table>
		</myxml>".parse();

		Detox.setDocument(sampleDocument.getNode());

		h1 = "h1".find();
		lists = "ul".find();
		list1 = "#a".find();
		list2 = "#b".find();
		listItems = "li".find();
	}
	
	public function tearDown():Void
	{
		// trace ("Tear Down");
	}

	public function testCreateEmptyQuery()
	{
		var q = new DOMCollection();
		Assert.equals(0, q.length);
	}

	public function testCreateQueryFromArray()
	{
		var arr = ["#a1".find().getNode(), "#b2".find().getNode(), "#a3".find().getNode()];

		var q1 = new DOMCollection(arr);
		Assert.equals(3, q1.length);
	}

	public function testIterator()
	{
		var total = 0;
		for (i in listItems)
		{
			total++;
		}
		Assert.equals(6, total);
	}

	public function testIteratorOnEmpty()
	{
		var total = 0;
		for (i in new DOMCollection())
		{
			total++;
		}
		Assert.equals(0, total);
	}

	public function testGetNodeFirst()
	{
		// if we can access the nodeType property, then we know we're on a Node 
		Assert.equals(dtx.DOMType.ELEMENT_NODE, h1.getNode().nodeType);
	}

	public function testGetNodeN()
	{
		Assert.equals('a3', listItems.getNode(2).attr('id'));
	}

	public function testGetNodeFromEmpty()
	{
		var q = new DOMCollection();
		Assert.isNull(q.getNode());
	}

	public function testGetNodeOutOfBounds()
	{
		Assert.isNull(listItems.getNode(100));
	}

	public function testEq()
	{
		Assert.equals(1, listItems.eq(3).length);
		Assert.equals("b1", listItems.eq(3).attr('id'));
	}

	public function testEqDefault()
	{
		Assert.equals(1, listItems.eq().length);
		Assert.equals("a1", listItems.eq().attr('id'));
	}

	public function testEqOutOfBounds()
	{
		Assert.equals(0, listItems.eq(100).length);
		// This should not throw any errors, but silently fail
		Assert.equals("", listItems.eq(100).attr('id'));
	}

	public function testFirst()
	{
		Assert.equals("a1", listItems.first().attr("id"));
	}

	public function testFirstOnEmpty()
	{
		var q = new DOMCollection();
		Assert.equals(null, q.first());
		Assert.equals("", q.first().attr("id"));
	}

	public function testLast()
	{
		Assert.equals("b3", listItems.last().attr("id"));
	}

	public function testLastOnEmpty()
	{
		var q = new DOMCollection();
		Assert.equals(null, q.last());
		Assert.equals("", q.last().attr("id"));
	}

	public function testAdd()
	{
		var q = new DOMCollection();
		Assert.equals(0, q.length);
		
		q.add(h1.getNode());
		Assert.equals(1, q.length);
		
		q.add("h2".create());
		Assert.equals(2, q.length);
	}

	public function testAddNull()
	{
		var q = new DOMCollection();
		q.add(null);
		Assert.equals(0, q.length);
	}

	public function testAddAlreadyInCollection()
	{
		var q = new DOMCollection();
		Assert.equals(0, q.length);
		
		q.add(h1.getNode());
		Assert.equals(1, q.length);
		
		// Even if we add it again we should only have a 1 length
		q.add(h1.getNode());
		Assert.equals(1, q.length);
	}

	public function testAddCollection()
	{
		var q = new DOMCollection();
		var arr = ["h1".create(), "h2".create(), "h3".create()];
		q.addCollection(arr);

		Assert.equals(3, q.length);
	}

	public function testAddCollectionNull()
	{
		var q = new DOMCollection();
		var arr:Array<DOMNode> = null;
		q.addCollection(arr);
		
		Assert.equals(0, q.length);
	}

	public function testAddCollectionWithNull()
	{
		var q = new DOMCollection();
		var arr = ["h1".create(), null, "h3".create()];
		q.addCollection(arr);
		
		Assert.equals(2, q.length);
	}

	public function testAddCollectionElementsOnly()
	{
		var q1 = new DOMCollection();
		var q2 = new DOMCollection();
		var q3 = new DOMCollection();
		#if js
		var nodeList = ("table".find().getNode():js.html.Node).childNodes;
		#elseif mo
		var nodeList = 'table'.find().getNode().childNodes;
		#else 
		var nodeList = "table".find().getNode();
		#end
		var collection = new DOMCollection().addNodeList(nodeList, false);
		
		// The default should be true
		q1.addCollection(collection);
		q2.addCollection(collection, true);
		q3.addCollection(collection, false);

		Assert.equals(5, q1.length);
		Assert.equals(2, q2.length);
		Assert.equals(5, q3.length);
	}

	public function testAddNodeList()
	{
		var q = new DOMCollection();
		#if js 
		  var nodeList = Detox.document.querySelectorAll("li");
		#else
		  var nodeList = Detox.document.find("li");
		#end 
		q.addNodeList(cast nodeList);
		Assert.equals(6, q.length);
	}

	public function testAddNodeListElementsOnly()
	{
		var q1 = new DOMCollection();
		var q2 = new DOMCollection();
		var q3 = new DOMCollection();

		#if js
		var nodeList = ("table".find().getNode():js.html.Node).childNodes;
		#elseif mo
		var nodeList = 'table'.find().getNode().childNodes;
		#else 
		var nodeList = "table".find().getNode();
		#end
		
		// The default should be true
		q1.addNodeList(nodeList);
		q2.addNodeList(nodeList, true);
		q3.addNodeList(nodeList, false);

		Assert.equals(5, q1.length);
		Assert.equals(2, q2.length);
		Assert.equals(5, q3.length);
	}

	public function testAddNodeListNull()
	{
		var q1 = new DOMCollection();
		q1.addNodeList(null);
		Assert.equals(0, q1.length);
	}

	public function testRemoveFromCollection()
	{
		var string = "";
		listItems.removeFromCollection("#b1".find().getNode());
		listItems.removeFromCollection("#b3".find().getNode());

		Assert.equals(4, listItems.length);
		for (item in listItems)
		{
			string += item.attr('id');
		}
		Assert.equals("a1a2a3b2", string);
	}

	public function testRemoveQueryFromCollection()
	{
		var string = "";
		listItems.removeFromCollection("li".find());
		Assert.equals(0, listItems.length);
	}

	public function testRemoveQueryFromCollection2()
	{
		var string = "";
		listItems.removeFromCollection("#b1".find());
		listItems.removeFromCollection("#b3".find());
		
		Assert.equals(4, listItems.length);
		for (item in listItems)
		{
			string += item.attr('id');
		}
		Assert.equals("a1a2a3b2", string);
	}

	public function testRemoveFromCollectionNull()
	{
		listItems.removeFromCollection();
		listItems.removeFromCollection(null, null);
		Assert.equals(6, listItems.length);
	}

	public function testRemoveFromCollectionNotInCollection()
	{
		var t = "table".find();
		listItems.removeFromCollection(t);
		listItems.removeFromCollection(t.getNode());

		Assert.equals(6, listItems.length);
	}

	public function testEach()
	{
		var total = 0;
		listItems.each(function (li) {
			// Check each element exists and is functional
			Assert.isTrue(li.attr('id') != "");
			// Count the total number of times this function is called
			total++;
		});

		Assert.equals(6, total);
	}

	public function testEachOnEmpty()
	{
		var q = new DOMCollection();
		var total = 0;
		q.each(function (li) {
			// Count the total number of times this function is called
			total++;
		});

		Assert.equals(0, total);
	}

	public function eachNullCallback()
	{
		// Just check it doesn't throw an error...
		listItems.each(null);
	}

	public function testFilter()
	{
		var filteredList = listItems.filter(function (li) {
			var id = li.attr('id');
			return id.indexOf('a') > -1;
		});
		var filteredList2 = listItems.filter(function (li) {
			var id = li.attr('id');
			return id.indexOf('3') > -1;
		});
		Assert.equals(6, listItems.length);
		Assert.equals(3, filteredList.length);
		Assert.equals(2, filteredList2.length);
	}

	public function testFilterOnEmpty()
	{
		var q = new DOMCollection();
		var total = 0;

		var filteredList = q.filter(function (li) {
			total++;
			return true;
		});

		Assert.equals(0, filteredList.length);
		Assert.equals(0, total);
	}

	public function testFilterNullCallback()
	{
		var filteredList = listItems.filter(null);

		Assert.equals(6, filteredList.length);
	}

	public function testFilterCallbackReturnsNull()
	{
		var filteredList = listItems.filter(function (li) {
			#if (flash9 || cpp || cs || java)
			var returnValue = false;
			#else
			var returnValue:Bool = null;
			#end
			return returnValue;
		});

		Assert.equals(6, listItems.length);
		Assert.equals(0, filteredList.length);
	}

	public function testDOMclone()
	{
		// Create a clone of list items and modify every element
		var listItemsClone = listItems.clone();
		listItemsClone.addClass("newlistitem");

		// Check none of the original elements have changed
		for (li in listItems)
		{
			Assert.isFalse(li.hasClass('newlistitem'));
		}

		// Check all of the new elements have changed
		for (li in listItemsClone)
		{
			Assert.isTrue(li.hasClass('newlistitem'));
		}
	}
}
