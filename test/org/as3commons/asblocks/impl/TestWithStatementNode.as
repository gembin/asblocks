package org.as3commons.asblocks.impl
{

import org.as3commons.asblocks.CodeMirror;
import org.as3commons.asblocks.api.IBinaryExpression;
import org.as3commons.asblocks.api.IBlock;
import org.as3commons.asblocks.api.IDoWhileStatement;
import org.as3commons.asblocks.api.IExpression;
import org.as3commons.asblocks.api.IFieldAccessExpression;
import org.as3commons.asblocks.api.IINvocationExpression;
import org.as3commons.asblocks.api.IWithStatement;
import org.as3commons.asblocks.parser.api.IParserNode;
import org.as3commons.asblocks.parser.core.SourceCode;
import org.as3commons.asblocks.parser.impl.AS3FragmentParser;
import org.flexunit.Assert;

public class TestWithStatementNode extends BaseASFactoryTest
{
	private var block:IBlock;
	
	private var statement:IWithStatement;
	
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
		var condition:IExpression = factory.newExpression("foo.bar");
		statement = block.newWith(condition);
		assertPrint("{\n\twith (foo.bar){\n\t}\n}", block);
		statement.addStatement("baz = 1");
		assertPrint("{\n\twith (foo.bar){\n\t\tbaz = 1;\n\t}\n}", block);
	}
	
	[Test]
	public function testParse():void
	{
		block = factory.newBlock();
		statement = block.addStatement("with (foo.bar){ }") as IWithStatement;
		Assert.assertNotNull(statement);
		assertPrint("{\n\twith (foo.bar){ }\n}", block);
	}
	
	[Test]
	public function test_object():void
	{
		block = factory.newBlock();
		var object:IExpression = factory.newExpression("foo.bar");
		statement = block.newWith(object);
		Assert.assertTrue(statement.object is IFieldAccessExpression);
		statement.object = factory.newExpression("getName()");
		Assert.assertTrue(statement.object is IINvocationExpression);
		assertPrint("{\n\twith (getName()){\n\t}\n}", block);
	}
}
}