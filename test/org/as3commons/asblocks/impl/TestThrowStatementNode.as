package org.as3commons.asblocks.impl
{

import org.as3commons.asblocks.CodeMirror;
import org.as3commons.asblocks.api.IBlock;
import org.as3commons.asblocks.api.INewExpression;
import org.as3commons.asblocks.api.ISimpleNameExpression;
import org.as3commons.asblocks.api.IThrowStatement;
import org.as3commons.asblocks.parser.api.IParserNode;
import org.as3commons.asblocks.parser.core.SourceCode;
import org.as3commons.asblocks.parser.impl.AS3FragmentParser;
import org.flexunit.Assert;

public class TestThrowStatementNode extends BaseASFactoryTest
{
	private var block:IBlock;
	
	private var statement:IThrowStatement;
	
	[Before]
	override public function setUp():void
	{
		super.setUp();
		
		block = null;
		statement = null;
	}
	
	[After]
	override public function tearDown():void
	{
		if (statement && !block)
		{
			var sourceCode:SourceCode = new SourceCode();
			var ast:IParserNode = statement.node;
			new ASTPrinter(sourceCode).print(ast);
			var parsed:IParserNode = AS3FragmentParser.parseStatement(sourceCode.code);
			CodeMirror.assertASTMatch(ast, parsed);
		}
	}
	
	[Test]
	public function testBasic():void
	{
		block = factory.newBlock();
		statement = block.newThrow(factory.newExpression("new Error()"));
		assertPrint("{\n\tthrow new Error();\n}", block);
		Assert.assertTrue(statement.expression is INewExpression);
		block = factory.newBlock();
		statement = block.newThrow(factory.newExpression("e1"));
		assertPrint("{\n\tthrow e1;\n}", block);
		Assert.assertTrue(statement.expression is ISimpleNameExpression);
	}
	
	[Test]
	public function testParse():void
	{
		block = factory.newBlock();
		statement = block.addStatement("throw new Error('message')") as IThrowStatement;
		assertPrint("{\n\tthrow new Error('message');\n}", block);
		Assert.assertTrue(statement.expression is INewExpression);
		block = factory.newBlock();
		statement = block.addStatement("throw e1") as IThrowStatement;
		assertPrint("{\n\tthrow e1;\n}", block);
		Assert.assertTrue(statement.expression is ISimpleNameExpression);
	}
}
}