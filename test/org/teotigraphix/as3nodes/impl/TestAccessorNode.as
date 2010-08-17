package org.teotigraphix.as3nodes.impl
{

import flexunit.framework.Assert;

import org.teotigraphix.as3nodes.api.Access;
import org.teotigraphix.as3nodes.api.Modifier;
import org.teotigraphix.as3nodes.utils.ASTNodeUtil;
import org.teotigraphix.as3parser.api.IParserNode;

public class TestAccessorNode
{
	[Test]
	public function testBasic():void
	{
		var ast:IParserNode = ASTNodeUtil.createAccessor(
			"myProperty", Modifier.PUBLIC, Access.READ, IdentifierNode.createType("String"));
		var element:AccessorNode = new AccessorNode(ast, null);
		
		Assert.assertFalse(element.isConstructor);
		Assert.assertFalse(element.isOverride);
		
		Assert.assertTrue(element.isReadOnly);
	}
}
}