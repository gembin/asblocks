package org.as3commons.asblocks.impl
{

import org.flexunit.asserts.assertNotNull;
import org.as3commons.asblocks.parser.api.IParserNode;
import org.as3commons.asblocks.parser.core.SourceCode;
import org.as3commons.asblocks.parser.impl.AS3FragmentParser;
import org.as3commons.asblocks.ASFactory;
import org.as3commons.asblocks.CodeMirror;
import org.as3commons.asblocks.api.IBlock;
import org.as3commons.asblocks.api.IBreakStatement;
import org.as3commons.asblocks.api.IContinueStatement;

public class TestContinueStatementNode
{
	private var factory:ASFactory = new ASFactory();
	
	private var block:IBlock;
	
	private var expression:IContinueStatement;
	
	[Before]
	public function setUp():void
	{
		block = null;
		expression = null;
	}
	
	[After]
	public function tearDown():void
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
		expression = block.newContinue();
	}
	
	[Test]
	public function testBasicLabel():void
	{
		block = factory.newBlock();
		expression = block.newContinue("foo");
	}
	
	[Test]
	public function testParse():void
	{
		block = factory.newBlock();
		expression = block.addStatement("continue") as IContinueStatement;
		assertNotNull(expression);
	}
	
	[Test]
	public function testParseLabel():void
	{
		block = factory.newBlock();
		expression = block.addStatement("continue foo") as IContinueStatement;
		assertNotNull(expression);
	}
	
	// FIXME (mschmalle) impl IContinueStatement.label set correctly
	//[Test]
	public function test_label():void
	{
		block = factory.newBlock();
		expression = block.addStatement("continue foo") as IContinueStatement;
		//assertNotNull(expression.label);
		//assertEquals("foo", ISimpleNameExpression(expression.label).name);
		//expression.label = null;
		//assertNull(expression.label);
		//expression.label = factory.newExpression("bar");
		//assertEquals("bar", ISimpleNameExpression(expression.label).name);
	}
	
	//[Test]
	public function test_set_label():void
	{
		block = factory.newBlock();
		expression = block.addStatement("continue") as IContinueStatement;
		expression.label = factory.newExpression("bar");
	}
}
}