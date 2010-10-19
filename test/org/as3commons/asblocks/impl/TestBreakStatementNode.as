package org.as3commons.asblocks.impl
{

import org.as3commons.asblocks.ASFactory;
import org.as3commons.asblocks.CodeMirror;
import org.as3commons.asblocks.api.IBlock;
import org.as3commons.asblocks.api.IBreakStatement;
import org.as3commons.asblocks.api.ISimpleNameExpression;
import org.as3commons.asblocks.parser.api.IParserNode;
import org.as3commons.asblocks.parser.core.SourceCode;
import org.as3commons.asblocks.parser.impl.AS3FragmentParser;
import org.flexunit.Assert;
import org.flexunit.asserts.assertNotNull;

public class TestBreakStatementNode extends BaseASFactoryTest
{
	private var block:IBlock;
	
	private var expression:IBreakStatement;
	
	[Before]
	override public function setUp():void
	{
		super.setUp();
		
		block = null;
		expression = null;
	}
	
	[After]
	override public function tearDown():void
	{
		if (expression)
		{
			var sourceCode:SourceCode = new SourceCode();
			var ast:IParserNode = block.node;
			new ASTPrinter(sourceCode).print(ast);
			var parsed:IParserNode = AS3FragmentParser.parseStatement(sourceCode.code);
			CodeMirror.assertASTMatch(ast, parsed);
		}
	}
	
	[Test]
	public function testBasic():void
	{
		block = factory.newBlock();
		expression = block.newBreak();
		assertPrint("{\n\tbreak;\n}", expression);
	}
	
	[Test]
	public function testBasicLabel():void
	{
		block = factory.newBlock();
		expression = block.newBreak("foo");
		assertPrint("{\n\tbreak foo;\n}", expression);
	}
	
	[Test]
	public function testParse():void
	{
		block = factory.newBlock();
		expression = block.addStatement("break") as IBreakStatement;
		assertNotNull(expression);
	}
	
	[Test]
	public function testParseLabel():void
	{
		block = factory.newBlock();
		expression = block.addStatement("break foo") as IBreakStatement;
		assertNotNull(expression);
	}
	
	// FIXME (mschmalle) impl IBreakStatement.label set correctly
	[Test]
	public function test_label():void
	{
		block = factory.newBlock();
		expression = block.addStatement("break foo") as IBreakStatement;
		assertNotNull(expression.label);
		Assert.assertEquals("foo", ISimpleNameExpression(expression.label).name);
		expression.label = null;
		assertPrint("{\n\tbreak;\n}", expression);
		//Assert.assertNull(expression.label);
		//expression.label = factory.newExpression("bar");
		//Assert.assertEquals("bar", ISimpleNameExpression(expression.label).name);
		//assertPrint("{\n\tbreak bar;\n}", expression);
	}
	
	//[Test]
	public function test_set_label():void
	{
		block = factory.newBlock();
		expression = block.addStatement("break") as IBreakStatement;
		expression.label = factory.newExpression("bar");
	}
}
}