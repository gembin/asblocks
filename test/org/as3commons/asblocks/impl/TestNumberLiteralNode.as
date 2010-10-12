package org.as3commons.asblocks.impl
{

import org.as3commons.asblocks.ASFactory;
import org.as3commons.asblocks.CodeMirror;
import org.as3commons.asblocks.api.INumberLiteral;
import org.as3commons.asblocks.parser.api.IParserNode;
import org.as3commons.asblocks.parser.core.SourceCode;
import org.as3commons.asblocks.parser.impl.AS3FragmentParser;
import org.flexunit.Assert;

public class TestNumberLiteralNode
{
	private var factory:ASFactory = new ASFactory();
	
	private var expression:INumberLiteral;
	
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
	public function testBasicInt():void
	{
		expression = factory.newNumberLiteral(42);
		Assert.assertEquals(42, expression.value);
		
		// TODO (mschmalle) parse and write hex correctly
		//expression = factory.newNumberLiteral(0xf42);
		//Assert.assertEquals(0xf42, expression.value);
		
	}

}
}