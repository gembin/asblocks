package org.teotigraphix.as3nodes.impl
{

import flexunit.framework.Assert;

import org.teotigraphix.as3nodes.api.IMetaDataNode;
import org.teotigraphix.as3nodes.api.IMetaDataParameterNode;
import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.core.Node;
import org.teotigraphix.as3parser.impl.AS3FragmentParserOLD;

public class TestMetaDataNode
{
	[Before]
	public function setUp():void
	{
		
	}
	
	[Test]
	public function testBasick():void
	{
		
	}
	
	[Test]
	public function testBasic():void
	{
		// [Style(name="myStyle",type="Number",inherit="no")]
		var metaList:IParserNode = AS3FragmentParserOLD.parseMetaData(
			"/** My style comment. */[Style(name=\"myStyle\",type=\"Number\",inherit=\"no\")]");
		var node:IParserNode = metaList.getChild(0);
		
		var element:IMetaDataNode = NodeFactory.instance.createMetaData(node, null);
		
		Assert.assertNotNull(element);
		Assert.assertNotNull(element.comment);
		Assert.assertEquals("My style comment.", element.comment.shortDescription);
		Assert.assertEquals("Style", element.name);
		//Assert.assertEquals("name = \"myStyle\" , type = \"Number\" , inherit = \"no\"", element.parameter);
		
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