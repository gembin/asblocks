package org.as3commons.asblocks.impl
{

import org.as3commons.asblocks.CodeMirror;
import org.as3commons.asblocks.api.IAssignmentExpression;
import org.as3commons.asblocks.api.IBlock;
import org.as3commons.asblocks.api.IINvocationExpression;
import org.as3commons.asblocks.api.IThisStatement;
import org.as3commons.asblocks.parser.api.IParserNode;
import org.as3commons.asblocks.parser.core.SourceCode;
import org.as3commons.asblocks.parser.impl.AS3FragmentParser;
import org.flexunit.Assert;

public class TestThisStatementNode extends BaseASFactoryTest
{
	private var block:IBlock;
	
	private var statement:IThisStatement;
	
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
		statement = block.newThis(factory.newExpression("property = 42"));
		assertPrint("{\n\tthis.property = 42;\n}", block);
		Assert.assertTrue(statement.expression is IAssignmentExpression);
		block = factory.newBlock();
		statement = block.newThis(factory.newExpression("foo(bar)"));
		assertPrint("{\n\tthis.foo(bar);\n}", block);
		Assert.assertTrue(statement.expression is IINvocationExpression);
	}
	
	[Test]
	public function testParse():void
	{
		block = factory.newBlock();
		statement = block.addStatement("this.property = 42") as IThisStatement;
		assertPrint("{\n\tthis.property = 42;\n}", block);
		Assert.assertTrue(statement.expression is IAssignmentExpression);
		block = factory.newBlock();
		statement = block.addStatement("this.foo(bar)") as IThisStatement;
		assertPrint("{\n\tthis.foo(bar);\n}", block);
		Assert.assertTrue(statement.expression is IINvocationExpression);
	}
}
}