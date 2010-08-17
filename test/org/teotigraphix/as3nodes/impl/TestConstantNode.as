package org.teotigraphix.as3nodes.impl
{
import flexunit.framework.Assert;

import org.teotigraphix.as3nodes.api.Modifier;
import org.teotigraphix.as3nodes.utils.ASTNodeUtil;
import org.teotigraphix.as3parser.api.IParserNode;

public class TestConstantNode
{
	[Test]
	public function testBasic():void
	{
		var ast:IParserNode = ASTNodeUtil.createConstant(
			"MY_CONSTANT", Modifier.PUBLIC, IdentifierNode.createType("String"), "null");
		var element:ConstantNode = new  ConstantNode(ast, null);
		
		Assert.assertNotNull(element.comment);
		Assert.assertTrue(element.isPublic);
		Assert.assertNotNull(element.modifiers);
		Assert.assertEquals(2, element.modifiers.length);
		Assert.assertTrue(element.hasModifier(Modifier.PUBLIC));
		Assert.assertTrue(element.hasModifier(Modifier.STATIC));
		Assert.assertEquals("MY_CONSTANT", element.name);
		Assert.assertStrictlyEquals(ast, element.node);
		Assert.assertEquals(0, element.numMetaData);
		Assert.assertNotNull(element.type);
		Assert.assertEquals("String", element.type.localName);
		
		// test comment
		element.description = "A comment.\n <p>Long desc.</p>";
		Assert.assertTrue(element.hasDescription);
		Assert.assertEquals("A comment.", element.comment.shortDescription);
		Assert.assertEquals("<p>Long desc.</p>", element.comment.longDescription);
		
		// test name
		element.uid = IdentifierNode.createName("MY_OTHER_CONSTANT");
		Assert.assertEquals("MY_OTHER_CONSTANT", element.name);
	}
}
}