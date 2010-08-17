package org.teotigraphix.as3nodes.impl
{

import org.teotigraphix.as3nodes.api.Modifier;
import org.teotigraphix.as3nodes.utils.ASTNodeUtil;
import org.teotigraphix.as3parser.api.IParserNode;

public class TestMethodNode
{
	[Test]
	public function testBasic():void
	{
		var ast:IParserNode = ASTNodeUtil.createMethod(
			"myMethod", Modifier.PUBLIC, IdentifierNode.createType("String"));
		var element:MethodNode = new MethodNode(ast, null);
	}
}
}