package org.as3commons.asblocks.impl
{

import org.flexunit.Assert;
import org.as3commons.asblocks.parser.api.IParserNode;
import org.as3commons.asblocks.parser.core.SourceCode;
import org.as3commons.asblocks.parser.impl.AS3FragmentParser;
import org.as3commons.asblocks.CodeMirror;
import org.as3commons.asblocks.api.IBlock;
import org.as3commons.asblocks.api.IExpression;
import org.as3commons.asblocks.api.IForInStatement;

public class TestForInStatementNode extends BaseASFactoryTest
{
	private var block:IBlock;
	
	private var statement:IForInStatement;
	
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
		var declaration:IExpression = factory.newExpression("foo");
		var target:IExpression = factory.newExpression("bar");
		statement = block.newForIn(declaration, target);
		assertPrint("{\n\tfor (foo in bar) {\n\t}\n}", block);
	}
	
	[Test]
	public function testParse():void
	{
		block = factory.newBlock();
		statement = block.addStatement("for (foo in bar) { }") as IForInStatement;
		Assert.assertNotNull(statement);
		assertPrint("{\n\tfor (foo in bar) { }\n}", block);
	}
	
	[Test]
	public function test_declaration():void
	{
		block = factory.newBlock();
		var declaration:IExpression = factory.newExpression("foo");
		var target:IExpression = factory.newExpression("bar");
		statement = block.newForIn(declaration, target);
		assertPrint("{\n\tfor (foo in bar) {\n\t}\n}", block);
		
		statement.initializer = factory.newExpression("baz");
		assertPrint("{\n\tfor (baz in bar) {\n\t}\n}", block);
		
		statement.initializer = factory.newDeclaration("foo:String");
		assertPrint("{\n\tfor (var foo:String in bar) {\n\t}\n}", block);
	}
	
	[Test]
	public function test_iterated():void
	{
		block = factory.newBlock();
		var declaration:IExpression = factory.newExpression("foo");
		var target:IExpression = factory.newExpression("bar");
		statement = block.newForIn(declaration, target);
		assertPrint("{\n\tfor (foo in bar) {\n\t}\n}", block);
		
		statement.iterated = factory.newExpression("baz");
		assertPrint("{\n\tfor (foo in baz) {\n\t}\n}", block);
		
		statement.iterated = factory.newExpression("getObject(bar)");
		assertPrint("{\n\tfor (foo in getObject(bar)) {\n\t}\n}", block);
	}
}
}