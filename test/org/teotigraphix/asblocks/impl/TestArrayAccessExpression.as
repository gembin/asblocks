package org.teotigraphix.asblocks.impl
{

import org.flexunit.asserts.assertEquals;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.core.SourceCode;
import org.teotigraphix.as3parser.impl.AS3FragmentParser;
import org.teotigraphix.asblocks.ASFactory;
import org.teotigraphix.asblocks.CodeMirror;
import org.teotigraphix.asblocks.api.IArrayAccessExpression;
import org.teotigraphix.asblocks.api.IExpression;

public class TestArrayAccessExpression
{
	private var factory:ASFactory = new ASFactory();
	private var expression:IArrayAccessExpression;
	private var target:IExpression;
	private var subscript:IExpression;
	
	[Before]
	public function setUp():void
	{
		expression = null;
	}
	
	[After]
	public function tearDown():void
	{
		if (expression)
		{
			var sourceCode:SourceCode = new SourceCode();
			var ast:IParserNode = expression.node;
			new ASTPrinter(sourceCode).print(ast);
			var parsed:IParserNode = AS3FragmentParser.parseExpression(sourceCode.code);
			CodeMirror.assertASTMatch(ast, parsed);
		}
	}
	
	[Test]
	public function testBasic():void
	{
		target = factory.newExpression("foo");
		subscript = factory.newNumberLiteral(1);
		expression = factory.newArrayAccessExpression(target, subscript);
		assertEquals(target.node, expression.target.node);
		assertEquals(subscript.node, expression.subscript.node);
	}
}
}