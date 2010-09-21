package org.teotigraphix.asblocks.impl
{

import org.flexunit.Assert;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.core.SourceCode;
import org.teotigraphix.as3parser.impl.AS3FragmentParser;
import org.teotigraphix.asblocks.CodeMirror;
import org.teotigraphix.asblocks.api.IBlock;
import org.teotigraphix.asblocks.api.IExpression;
import org.teotigraphix.asblocks.api.IForInStatement;

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
		
		statement.declaration = factory.newExpression("baz");
		assertPrint("{\n\tfor (baz in bar) {\n\t}\n}", block);
		
		statement.declaration = factory.newDeclaration("foo:String");
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