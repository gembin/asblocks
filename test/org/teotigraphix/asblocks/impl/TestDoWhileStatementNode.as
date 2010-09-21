package org.teotigraphix.asblocks.impl
{

import org.flexunit.Assert;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.core.SourceCode;
import org.teotigraphix.as3parser.impl.AS3FragmentParser;
import org.teotigraphix.asblocks.CodeMirror;
import org.teotigraphix.asblocks.api.IBinaryExpression;
import org.teotigraphix.asblocks.api.IBlock;
import org.teotigraphix.asblocks.api.IDoWhileStatement;
import org.teotigraphix.asblocks.api.IExpression;
import org.teotigraphix.asblocks.api.IINvocationExpression;

public class TestDoWhileStatementNode extends BaseASFactoryTest
{
	private var block:IBlock;
	
	private var statement:IDoWhileStatement;
	
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
			CodeMirror.assertASTMatch(ast, parsed);
		}
	}
	
	[Test]
	public function testBasic():void
	{
		block = factory.newBlock();
		var condition:IExpression = factory.newExpression("hasNext()");
		statement = block.newDoWhile(condition);
		assertPrint("{\n\tdo {\n\t} while (hasNext());\n}", block);
	}
	
	[Test]
	public function testParse():void
	{
		block = factory.newBlock();
		statement = block.addStatement("do { } while (hasNext())") as IDoWhileStatement;
		Assert.assertNotNull(statement);
		assertPrint("{\n\tdo { } while (hasNext());\n}", block);
	}
	
	[Test]
	public function test_condition():void
	{
		block = factory.newBlock();
		var condition:IExpression = factory.newExpression("hasNext()");
		statement = block.newDoWhile(condition);
		Assert.assertTrue(statement.condition is IINvocationExpression);
		statement.condition = factory.newExpression("i > 42");
		Assert.assertTrue(statement.condition is IBinaryExpression);
		assertPrint("{\n\tdo {\n\t} while (i > 42);\n}", block);
	}
}
}