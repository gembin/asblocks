package org.as3commons.asblocks.impl
{

import org.flexunit.Assert;
import org.flexunit.asserts.assertNotNull;
import org.as3commons.asblocks.parser.api.IParserNode;
import org.as3commons.asblocks.parser.core.SourceCode;
import org.as3commons.asblocks.parser.impl.AS3FragmentParser;
import org.as3commons.asblocks.CodeMirror;
import org.as3commons.asblocks.api.IBlock;
import org.as3commons.asblocks.api.IDefaultXMLNamespaceStatement;

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