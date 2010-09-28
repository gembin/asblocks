package org.as3commons.mxmlblocks.impl
{

import org.as3commons.asblocks.CodeMirror;
import org.as3commons.asblocks.impl.ASTPrinter;
import org.as3commons.asblocks.impl.BaseASFactoryTest;
import org.as3commons.asblocks.parser.api.IParserNode;
import org.as3commons.asblocks.parser.core.SourceCode;
import org.as3commons.mxmlblocks.api.IAttribute;
import org.as3commons.mxmlblocks.api.IBlockTag;
import org.as3commons.mxmlblocks.parser.impl.MXMLFragmentParser;
import org.flexunit.Assert;

public class TestAttributeNode extends BaseASFactoryTest
{
	private var tag:IBlockTag;
	
	private var attribute:IAttribute;
	
	[Before]
	override public function setUp():void
	{
		super.setUp();
		
		tag = null;
		attribute = null;
	}
	
	[After]
	override public function tearDown():void
	{
		if (tag)
		{
			var sourceCode:SourceCode = new SourceCode();
			var ast:IParserNode = tag.node;
			new ASTPrinter(sourceCode).print(ast);
			var parsed:IParserNode = MXMLFragmentParser.parseTagList(sourceCode.code);
			CodeMirror.assertASTMatch(ast, parsed);
		}
	}
	
	[Test]
	public function testBasic():void
	{
		tag = factory.newTag("Foo");
		attribute = tag.newAttribute("foo", "bar");
	}
	
	[Test]
	public function testParse():void
	{
		//tag = factory.addTag("<Foo></Foo>");
	}
	
	[Test]
	public function test_name():void
	{
		tag = factory.newTag("Foo");
		attribute = tag.newAttribute("foo", "bar");
		
		Assert.assertEquals("foo", attribute.name);
		assertPrint("<Foo foo=\"bar\">\n</Foo>", tag);
		attribute.name = "goo";
		Assert.assertEquals("goo", attribute.name);
		assertPrint("<Foo goo=\"bar\">\n</Foo>", tag);
	}
	
	[Test]
	public function test_value():void
	{
		tag = factory.newTag("Foo");
		attribute = tag.newAttribute("foo", "bar");
		Assert.assertEquals("bar", attribute.value);
		assertPrint("<Foo foo=\"bar\">\n\</Foo>", tag);
		attribute.value = "goo";
		Assert.assertEquals("goo", attribute.value);
		assertPrint("<Foo foo=\"goo\">\n</Foo>", tag);
	}
	
	[Test]
	public function test_state():void
	{
		tag = factory.newTag("Foo");
		attribute = tag.newAttribute("foo", "bar", "baz");
		
		Assert.assertEquals("foo", attribute.name);
		Assert.assertEquals("baz", attribute.state);
		Assert.assertEquals("bar", attribute.value);
		
		assertPrint("<Foo foo.baz=\"bar\">\n</Foo>", tag);
	}
	
	[Test]
	public function test_setState():void
	{
		tag = factory.newTag("Foo");
		attribute = tag.newAttribute("foo", "bar");
		
		Assert.assertEquals("foo", attribute.name);
		Assert.assertNull(attribute.state);
		Assert.assertEquals("bar", attribute.value);
		
		assertPrint("<Foo foo=\"bar\">\n</Foo>", tag);
		
		attribute.state = "baz";
		Assert.assertEquals("baz", attribute.state);
		assertPrint("<Foo foo.baz=\"bar\">\n</Foo>", tag);
		
		attribute.state = null;
		Assert.assertNull(attribute.state);
		assertPrint("<Foo foo=\"bar\">\n</Foo>", tag);
	}
}
}