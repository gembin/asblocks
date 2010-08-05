package org.teotigraphix.as3book.impl
{

import flexunit.framework.Assert;

import org.teotigraphix.as3nodes.api.IMetaDataNode;
import org.teotigraphix.as3nodes.api.IMetaDataParameterNode;
import org.teotigraphix.as3nodes.impl.NodeFactory;
import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.core.Node;

public class TestMetaDataNode
{
	[Before]
	public function setUp():void
	{
		
	}
	
	[Test]
	public function testBasic():void
	{
		// [Style(name="myStyle",type="Number",inherit="no")]
		var asdocValue:String = "/** My style comment. */";
		var value:String = "Style ( name = \"myStyle\" , type = \"Number\" , inherit = \"no\" )";
		var asdoc:IParserNode = Node.create(AS3NodeKind.AS_DOC, -1, -1, asdocValue);
		var node:IParserNode = Node.create(AS3NodeKind.META, -1, -1, value);
		node.addChild(asdoc);
		
		var element:IMetaDataNode = NodeFactory.instance.createMetaData(node, null);
		
		Assert.assertNotNull(element);
		Assert.assertNotNull(element.comment);
		Assert.assertEquals("My style comment.", element.comment.shortDescription);
		Assert.assertEquals("Style", element.name);
		Assert.assertEquals("name = \"myStyle\" , type = \"Number\" , inherit = \"no\"", element.parameter);
		
		var param:IMetaDataParameterNode;
		
		param = element.getParameterAt(0);
		Assert.assertNotNull(param);
		Assert.assertTrue(param.hasName);
		Assert.assertEquals("name", param.name);
		Assert.assertEquals("\"myStyle\"", param.value);
		
		param = element.getParameterAt(1);
		Assert.assertNotNull(param);
		Assert.assertTrue(param.hasName);
		Assert.assertEquals("type", param.name);
		Assert.assertEquals("\"Number\"", param.value);
		
		param = element.getParameterAt(2);
		Assert.assertNotNull(param);
		Assert.assertTrue(param.hasName);
		Assert.assertEquals("inherit", param.name);
		Assert.assertEquals("\"no\"", param.value);
		
		param = element.getParameter("name");
		Assert.assertNotNull(param);
		Assert.assertTrue(param.hasName);
		Assert.assertEquals("name", param.name);
		Assert.assertEquals("\"myStyle\"", param.value);
		
		param = element.getParameter("type");
		Assert.assertNotNull(param);
		Assert.assertTrue(param.hasName);
		Assert.assertEquals("type", param.name);
		Assert.assertEquals("\"Number\"", param.value);
		
		param = element.getParameter("inherit");
		Assert.assertNotNull(param);
		Assert.assertTrue(param.hasName);
		Assert.assertEquals("inherit", param.name);
		Assert.assertEquals("\"no\"", param.value);
	}
}
}