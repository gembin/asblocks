package org.as3commons.asblocks.impl
{

import org.as3commons.asblocks.CodeMirror;
import org.as3commons.asblocks.api.IBlock;
import org.as3commons.asblocks.api.IBooleanLiteral;
import org.as3commons.asblocks.api.IExpression;
import org.as3commons.asblocks.api.IWhileStatement;
import org.as3commons.asblocks.parser.api.IParserNode;
import org.as3commons.asblocks.parser.core.SourceCode;
import org.as3commons.asblocks.parser.impl.AS3FragmentParser;
import org.flexunit.Assert;

public class TestWhileStatementNode extends BaseASFactoryTest
{
	private var block:IBlock;
	
	private var statement:IWhileStatement;
	
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
		if (block)
		{
			var sourceCode:SourceCode = new SourceCode();
			var ast:IParserNode = block.node;
			new ASTPrinter(sourceCode).print(ast);
			var parsed:IParserNode = AS3FragmentParser.parseStatement(sourceCode.code);
			CodeMirror.assertASTMatch(ast.getFirstChild(), parsed.getFirstChild());
		}
	}
	
	[Test]
	public function testBasic():void
	{
		block = factory.newBlock();
		var condition:IExpression = factory.newExpression("obj.hasNext()");
		statement = block.newWhile(condition);
		assertPrint("{\n\twhile (obj.hasNext()){\n\t}\n}", block);
		statement.addStatement("current = obj.next()");
		assertPrint("{\n\twhile (obj.hasNext()){\n\t\tcurrent = obj.next();\n\t}\n}", block);
	}
	
	[Test]
	public function testParse():void
	{
		block = factory.newBlock();
		statement = block.addStatement("while (obj.hasNext()){ }") as IWhileStatement;
		Assert.assertNotNull(statement);
		assertPrint("{\n\twhile (obj.hasNext()){ }\n}", block);
	}
	
	[Test]
	public function test_condition():void
	{
		block = factory.newBlock();
		statement = block.addStatement("while (obj.hasNext()){ }") as IWhileStatement;
		statement.condition = factory.newExpression("true");
		Assert.assertNotNull(statement.condition is IBooleanLiteral);
		assertPrint("{\n\twhile (true){ }\n}", block);
	}
}
}