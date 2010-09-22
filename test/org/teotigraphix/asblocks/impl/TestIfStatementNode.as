package org.teotigraphix.asblocks.impl
{

import org.flexunit.Assert;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.core.SourceCode;
import org.teotigraphix.as3parser.impl.AS3FragmentParser;
import org.teotigraphix.asblocks.ASBlocksSyntaxError;
import org.teotigraphix.asblocks.CodeMirror;
import org.teotigraphix.asblocks.api.IBinaryExpression;
import org.teotigraphix.asblocks.api.IBlock;
import org.teotigraphix.asblocks.api.IExpression;
import org.teotigraphix.asblocks.api.IIfStatement;

public class TestIfStatementNode extends BaseASFactoryTest
{
	private var block:IBlock;
	
	private var statement:IIfStatement;
	
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
		var condition:IExpression = factory.newExpression("foo == bar");
		statement = block.newIf(condition);
		assertPrint("{\n\tif (foo == bar) {\n\t}\n}", statement);
	}
	
	[Test]
	public function testParse():void
	{
		block = factory.newBlock();
		statement = block.addStatement("if (foo == bar) { }") as IIfStatement;
		Assert.assertNotNull(statement);
		assertPrint("{\n\tif (foo == bar) { }\n}", statement);
	}
	
	[Test]
	public function test_condition():void
	{
		block = factory.newBlock();
		var condition:IExpression = factory.newExpression("foo == bar");
		statement = block.newIf(condition);
		statement.condition = factory.newExpression("foo == bar && baz != foo");
		Assert.assertTrue(statement.condition is IBinaryExpression);
		assertPrint("{\n\tif (foo == bar && baz != foo) {\n\t}\n}", statement);
		try
		{
			statement.condition = null;
			Assert.fail("if condition cannot be null");
		}
		catch (e:ASBlocksSyntaxError) {}
	}
	
	[Test]
	public function test_thenBlock():void
	{
		block = factory.newBlock();
		statement = block.newIf(factory.newExpression("foo"));
		Assert.assertNotNull(statement.thenBlock);
		statement.thenBlock.addStatement("trace('foo')");
		assertPrint("{\n\tif (foo) {\n\t\ttrace('foo');\n\t}\n}", statement);
		var thenBlock:IBlock = factory.newBlock();
		thenBlock.addStatement("trace('bar')");
		statement.thenBlock = thenBlock;
		assertPrint("{\n\tif (foo) {\n\t\ttrace('bar');\n\t}\n}", statement);
		try
		{
			statement.thenBlock = null;
			Assert.fail("if then block cannot be null");
		}
		catch (e:ASBlocksSyntaxError) {}
	}
	
	[Test]
	public function test_elseBlock():void
	{
		block = factory.newBlock();
		statement = block.newIf(factory.newExpression("foo"));
		Assert.assertNotNull(statement.elseBlock);
		statement.elseBlock.addStatement("trace('foo')");
		assertPrint("{\n\tif (foo) {\n\t} else {\n\t\ttrace('foo');\n\t}\n}", statement);
		var elseBlock:IBlock = factory.newBlock();
		elseBlock.addStatement("trace('bar')");
		statement.elseBlock = elseBlock;
		assertPrint("{\n\tif (foo) {\n\t} else {\n\t\ttrace('bar');\n\t}\n}", statement);
		// remove the else
		statement.elseBlock = null;
		//Assert.assertNull(statement.elseBlock);
		assertPrint("{\n\tif (foo) {\n\t}\n}", statement);
	}
}
}