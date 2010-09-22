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
import org.teotigraphix.asblocks.api.IForStatement;

public class TestForStatementNode extends BaseASFactoryTest
{
	private var block:IBlock;
	
	private var statement:IForStatement;
	
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
		var intializer:IExpression = factory.newExpression("i = 0");
		var condition:IExpression = factory.newExpression("i < len");
		var iterator:IExpression = factory.newExpression("i++");
		statement = block.newFor(intializer, condition, iterator);
		assertPrint("{\n\tfor (i = 0; i < len; i++) {\n\t}\n}", block);
	}
	
	[Test]
	public function testParse():void
	{
		block = factory.newBlock();
		statement = block.addStatement("for (i = 0; i < len; i++) { }") as IForStatement;
		Assert.assertNotNull(statement);
		assertPrint("{\n\tfor (i = 0; i < len; i++) { }\n}", block);
	}
	
	[Test]
	public function test_initializer():void
	{
		block = factory.newBlock();
		statement = block.addStatement("for (i = 0; i < len; i++) { }") as IForStatement;
		var initializer:IDeclarationStatement = factory.newDeclaration("j:int = 0");
		statement.initializer = initializer;
		assertPrint("{\n\tfor (var j:int = 0; i < len; i++) { }\n}", block);
	}
	
	[Test]
	public function test_condition():void
	{
		block = factory.newBlock();
		statement = block.addStatement("for (i = 0; i < len; i++) { }") as IForStatement;
		var condition:IExpression = factory.newExpression("hasFoo() && i < len");
		statement.condition = condition;
		assertPrint("{\n\tfor (i = 0; hasFoo() && i < len; i++) { }\n}", block);
	}
	
	[Test]
	public function test_iterated():void
	{
		block = factory.newBlock();
		statement = block.addStatement("for (i = 0; i < len; i++) { }") as IForStatement;
		var iterator:IExpression = factory.newExpression("--i");
		statement.iterator = iterator;
		assertPrint("{\n\tfor (i = 0; i < len; --i) { }\n}", block);
	}
	
	[Test]
	public function test_emptyStatement():void
	{
		block = factory.newBlock();
		statement = block.addStatement("for ( ; ; ) { }") as IForStatement;
		assertPrint("{\n\tfor ( ; ; ) { }\n}", block);
		block = factory.newBlock();
		statement = block.addStatement("for (i = 0; i < len; i++) { }") as IForStatement;
		assertPrint("{\n\tfor (i = 0; i < len; i++) { }\n}", block);
		statement.initializer = null;
		statement.condition = null;
		statement.iterator = null;
		assertPrint("{\n\tfor (; ; ) { }\n}", block);
	}
}
}