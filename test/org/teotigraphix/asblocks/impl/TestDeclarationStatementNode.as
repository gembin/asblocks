package org.teotigraphix.asblocks.impl
{

import org.flexunit.Assert;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.core.SourceCode;
import org.teotigraphix.as3parser.impl.AS3FragmentParser;
import org.teotigraphix.asblocks.CodeMirror;
import org.teotigraphix.asblocks.api.IBlock;
import org.teotigraphix.asblocks.api.IDeclarationStatement;
import org.teotigraphix.asblocks.api.IExpression;
import org.teotigraphix.asblocks.api.INumberLiteral;
import org.teotigraphix.asblocks.api.IStatement;

public class TestDeclarationStatementNode extends BaseASFactoryTest
{
	private var block:IBlock;
	
	private var statement:IDeclarationStatement;
	
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
	}
	
	[Test]
	public function testParse():void
	{
		block = factory.newBlock();
		statement = factory.newDeclarationList("a:int = 0");
		assertPrint("var a:int = 0;", statement);
		statement = factory.newDeclarationList("a:int = 0, b:String = \"foo\"");
		assertPrint("var a:int = 0, b:String = \"foo\";", statement);
		statement = block.newDeclaration("a:int = 0");
		assertPrint("{\n\tvar a:int = 0;\n}", statement);
		block = factory.newBlock();
		statement = block.newDeclaration("a:int = 0, b:String = \"foo\"");
		assertPrint("{\n\tvar a:int = 0, b:String = \"foo\";\n}", statement);
	}
	
	[Test]
	public function test_name():void
	{
		statement = factory.newDeclarationList("a:int = 0");
		Assert.assertEquals("a", statement.name);
	}
	
	[Test]
	public function test_type():void
	{
		statement = factory.newDeclarationList("a:int = 0");
		Assert.assertEquals("int", statement.type);
	}
	
	[Test]
	public function test_initializer():void
	{
		statement = factory.newDeclarationList("a:int = 0");
		Assert.assertEquals(0, INumberLiteral(statement.initializer).value);
	}
	
	[Test]
	public function test_declarations():void
	{
		statement = factory.newDeclarationList("foo:int = 0, bar:Number, baz:int = 1");
		Assert.assertEquals(3, statement.declarations.length);
		Assert.assertEquals("foo", statement.declarations[0].name);
		Assert.assertEquals("bar", statement.declarations[1].name);
		Assert.assertEquals("baz", statement.declarations[2].name);
		Assert.assertEquals("int", statement.declarations[0].type);
		Assert.assertEquals("Number", statement.declarations[1].type);
		Assert.assertEquals("int", statement.declarations[2].type);
		Assert.assertEquals(0, INumberLiteral(statement.declarations[0].initializer).value);
		Assert.assertNull(statement.declarations[1].initializer);
		Assert.assertEquals(1, INumberLiteral(statement.declarations[2].initializer).value);
	}
}
}