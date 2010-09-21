package org.teotigraphix.asblocks.impl
{

import org.flexunit.Assert;
import org.flexunit.asserts.assertNotNull;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.core.SourceCode;
import org.teotigraphix.as3parser.impl.AS3FragmentParser;
import org.teotigraphix.asblocks.CodeMirror;
import org.teotigraphix.asblocks.api.IBlock;
import org.teotigraphix.asblocks.api.IDefaultXMLNamespaceStatement;

public class TestDefaultXMLNamespaceStatementNode extends BaseASFactoryTest
{
	private var block:IBlock;
	
	private var statement:IDefaultXMLNamespaceStatement;
	
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
		statement = block.newDefaultXMLNamespace("foo_namespace");
		assertPrint("{\n\tdefault xml namespace = foo_namespace;\n}", block);
	}
	
	[Test]
	public function testParse():void
	{
		block = factory.newBlock();
		statement = block.newDefaultXMLNamespace("foo_namespace");
		assertNotNull(statement);
		assertPrint("{\n\tdefault xml namespace = foo_namespace;\n}", block);
	}
	
	[Test]
	public function test_namespace():void
	{
		block = factory.newBlock();
		statement = block.newDefaultXMLNamespace("foo_namespace");
		Assert.assertEquals("foo_namespace", statement.namespace);
		statement.namespace = "bar_namespace";
		Assert.assertEquals("bar_namespace", statement.namespace);
		assertPrint("{\n\tdefault xml namespace = bar_namespace;\n}", block);
	}
}
}