package org.teotigraphix.asblocks.impl
{

import org.flexunit.asserts.assertFalse;
import org.flexunit.asserts.assertNotNull;
import org.flexunit.asserts.assertTrue;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.core.SourceCode;
import org.teotigraphix.as3parser.impl.AS3FragmentParser;
import org.teotigraphix.asblocks.ASFactory;
import org.teotigraphix.asblocks.CodeMirror;
import org.teotigraphix.asblocks.api.IBooleanLiteral;

public class TestBooleanLiteralNode
{
	private var factory:ASFactory = new ASFactory();
	
	private var expression:IBooleanLiteral;
	
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
	public function testBasicTrue():void
	{
		expression = factory.newBooleanLiteral(true);
	}
	
	[Test]
	public function testBasicFalse():void
	{
		expression = factory.newBooleanLiteral(false);
	}
	
	[Test]
	public function testParseTrue():void
	{
		expression = factory.newExpression("true") as IBooleanLiteral;
		assertNotNull(expression);
	}
	
	[Test]
	public function testParseFalse():void
	{
		expression = factory.newExpression("false") as IBooleanLiteral;
		assertNotNull(expression);
	}
	
	[Test]
	public function test_value():void
	{
		expression = factory.newBooleanLiteral(true);
		assertTrue(expression.value);
		expression.value = false;
		assertFalse(expression.value);
	}
}
}