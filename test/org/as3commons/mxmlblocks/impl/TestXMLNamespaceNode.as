package org.as3commons.mxmlblocks.impl
{

import org.as3commons.asblocks.ASBlocksSyntaxError;
import org.as3commons.asblocks.CodeMirror;
import org.as3commons.asblocks.impl.ASTPrinter;
import org.as3commons.asblocks.impl.BaseASFactoryTest;
import org.as3commons.asblocks.parser.api.IParserNode;
import org.as3commons.asblocks.parser.core.SourceCode;
import org.as3commons.mxmlblocks.api.IBlockTag;
import org.as3commons.mxmlblocks.api.IXMLNamespace;
import org.as3commons.mxmlblocks.parser.impl.MXMLFragmentParser;
import org.flexunit.Assert;

public class TestXMLNamespaceNode extends BaseASFactoryTest
{
	private var tag:IBlockTag;
	
	private var xmlns:IXMLNamespace;
	
	[Before]
	override public function setUp():void
	{
		super.setUp();
		
		xmlns = null;
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
	public function testBasicEmpty():void
	{
		tag = factory.newTag("Foo");
		xmlns = tag.newXMLNS(null, "*");
		Assert.assertNull(xmlns.localName);
		Assert.assertEquals("*", xmlns.uri);
		assertPrint("<Foo xmlns=\"*\">\n</Foo>", tag);
	}
	
	[Test]
	public function testBasic():void
	{
		tag = factory.newTag("Foo");
		xmlns = tag.newXMLNS("foo", "bar.*");
		Assert.assertEquals("foo", xmlns.localName);
		Assert.assertEquals("bar.*", xmlns.uri);
		assertPrint("<Foo xmlns:foo=\"bar.*\">\n</Foo>", tag);
	}
	
	[Test]
	public function testParse():void
	{
		//tag = factory.addTag("<Foo></Foo>");
	}
	
	[Test]
	public function test_localName():void
	{
		tag = factory.newTag("Foo");
		xmlns = tag.newXMLNS(null, "*");
		Assert.assertNull(xmlns.localName);
		assertPrint("<Foo xmlns=\"*\">\n</Foo>", tag);
		xmlns.localName = "foo";
		Assert.assertEquals("foo", xmlns.localName);
		assertPrint("<Foo xmlns:foo=\"*\">\n</Foo>", tag);
	}
	
	[Test]
	public function test_uri():void
	{
		tag = factory.newTag("Foo");
		xmlns = tag.newXMLNS("foo", "*");
		Assert.assertEquals("*", xmlns.uri);
		assertPrint("<Foo xmlns:foo=\"*\">\n</Foo>", tag);
		xmlns.uri = "foo.bar.*";
		Assert.assertEquals("foo.bar.*", xmlns.uri);
		assertPrint("<Foo xmlns:foo=\"foo.bar.*\">\n</Foo>", tag);
		try
		{
			xmlns.uri = null;
			Assert.fail("uri for IXMLNamespace cannot be null");
		}
		catch (e:ASBlocksSyntaxError) {}
		assertPrint("<Foo xmlns:foo=\"foo.bar.*\">\n</Foo>", tag);
	}
}
}