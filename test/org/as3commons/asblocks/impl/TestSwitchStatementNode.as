package org.as3commons.asblocks.impl
{

import org.as3commons.asblocks.CodeMirror;
import org.as3commons.asblocks.api.IBlock;
import org.as3commons.asblocks.api.IINvocationExpression;
import org.as3commons.asblocks.api.ISimpleNameExpression;
import org.as3commons.asblocks.api.ISwitchStatement;
import org.as3commons.asblocks.parser.api.IParserNode;
import org.as3commons.asblocks.parser.core.SourceCode;
import org.as3commons.asblocks.parser.impl.AS3FragmentParser;
import org.flexunit.Assert;

public class TestSwitchStatementNode extends BaseASFactoryTest
{
	private var block:IBlock;
	
	private var statement:ISwitchStatement;
	
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
		//block = factory.newBlock();
		//var condition:IExpression = factory.newExpression("foo");
		//statement = block.newSwitch(condition);
		//assertPrint("{\n\tswitch (foo) {\n\t}\n}", block);
		//statement.newCase("1");
		//assertPrint("{\n\tswitch (foo) {\n\t\tcase 1:\n\t}\n}", block);
		//statement.newDefault();
		//assertPrint("{\n\tswitch (foo) {\n\t\tcase 1:\n\t\tdefault:\n\t}\n}", block);
		//Assert.assertEquals(2, statement.labels.length);
	}
	
	[Test]
	public function testParse():void
	{
		block = factory.newBlock();
		statement = block.addStatement("switch (foo){ }") as ISwitchStatement;
		Assert.assertNotNull(statement);
		assertPrint("{\n\tswitch (foo){ }\n}", block);
		Assert.assertTrue(statement.condition is ISimpleNameExpression);
		Assert.assertEquals(0, statement.labels.length);
		
	}
	
	[Test]
	public function test_condition():void
	{
		block = factory.newBlock();
		statement = block.addStatement("switch (foo){ }") as ISwitchStatement;
		statement.condition = factory.newExpression("getName()");
		assertPrint("{\n\tswitch (getName()){ }\n}", block);
		Assert.assertTrue(statement.condition is IINvocationExpression);
	}
}
}