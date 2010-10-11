package org.as3commons.asblocks.impl
{

import org.as3commons.asblocks.CodeMirror;
import org.as3commons.asblocks.api.IAssignmentExpression;
import org.as3commons.asblocks.api.IBlock;
import org.as3commons.asblocks.api.IINvocationExpression;
import org.as3commons.asblocks.api.ISuperStatement;
import org.as3commons.asblocks.api.IThisStatement;
import org.as3commons.asblocks.parser.api.IParserNode;
import org.as3commons.asblocks.parser.core.SourceCode;
import org.as3commons.asblocks.parser.impl.AS3FragmentParser;
import org.flexunit.Assert;

public class TestSuperStatementNode extends BaseASFactoryTest
{
	private var block:IBlock;
	
	private var statement:ISuperStatement;
	
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
		
		statement = block.newSuper();
		assertPrint("{\n\tsuper();\n}", block);
		Assert.assertEquals(0, statement.arguments.length);
	}
	
	[Test]
	public function test_target():void
	{
		block = factory.newBlock();
		
		statement = block.newSuper();
		statement.target = factory.newExpression("foo");
		assertPrint("{\n\tsuper.foo();\n}", block);
	}
	
	[Test]
	public function testParse():void
	{
		block = factory.newBlock();
		statement = block.addStatement("super()") as ISuperStatement;
		assertPrint("{\n\tsuper();\n}", block);
		block = factory.newBlock();
		statement = block.addStatement("super.foo()") as ISuperStatement;
		assertPrint("{\n\tsuper.foo();\n}", block);
	}
}
}