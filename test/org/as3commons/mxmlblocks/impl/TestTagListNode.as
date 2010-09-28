package org.as3commons.mxmlblocks.impl
{

import org.as3commons.asblocks.ASBlocksSyntaxError;
import org.as3commons.asblocks.CodeMirror;
import org.as3commons.asblocks.api.IMetaData;
import org.as3commons.asblocks.api.IMethod;
import org.as3commons.asblocks.api.Visibility;
import org.as3commons.asblocks.impl.ASTPrinter;
import org.as3commons.asblocks.impl.BaseASFactoryTest;
import org.as3commons.asblocks.parser.api.IParserNode;
import org.as3commons.asblocks.parser.core.SourceCode;
import org.as3commons.mxmlblocks.api.IBlockTag;
import org.as3commons.mxmlblocks.api.IMetadataTag;
import org.as3commons.mxmlblocks.api.IScriptTag;
import org.as3commons.mxmlblocks.parser.impl.MXMLFragmentParser;
import org.flexunit.Assert;

public class TestTagListNode extends BaseASFactoryTest
{
	private var tag:IBlockTag;
	
	[Before]
	override public function setUp():void
	{
		super.setUp();
		
		tag = null;
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
		assertPrint("<Foo>\n</Foo>", tag);
		Assert.assertNull(tag.binding);
		Assert.assertEquals("Foo", tag.localName);
		assertPrint("<Foo>\n</Foo>", tag);
	}
	
	[Test]
	public function testBasicNested():void
	{
		tag = factory.newTag("Foo");
		assertPrint("<Foo>\n</Foo>", tag);
		tag.newTag("Bar");
		var baz:IBlockTag = tag.newTag("Baz");
		var goo:IBlockTag = baz.newTag("Goo");
		goo.newTag("Fudge");
		goo.newTag("Fickle");
		assertPrint("<Foo>\n\t<Bar>\n\t</Bar>\n\t<Baz>\n\t\t<Goo>\n\t\t\t<Fudge>" +
			"\n\t\t\t</Fudge>\n\t\t\t<Fickle>\n\t\t\t</Fickle>\n\t\t" +
			"</Goo>\n\t</Baz>\n</Foo>", tag);
	}
	
	[Test]
	public function testScript():void
	{
		tag = factory.newTag("Foo");
		
		var stag:IScriptTag = tag.newScriptTag();
		stag.block.newField("foo", Visibility.PUBLIC, "int");
		stag.block.newField("bar", Visibility.PUBLIC, "int");
		var m:IMethod = stag.block.newMethod("foo", Visibility.PUBLIC, "void");
		m.description = "A script block method";
		m.addComment("single comment");
		m.newReturn();
		
		assertPrint("<Foo>\n\t<fx:Script>\n\t<![CDATA[\n\t\tpublic var foo:int;" +
			"\n\t\tpublic var bar:int;\n\t\t/**\n\t\t * A script block method\n\t\t " +
			"*/\n\t\tpublic function foo():void {\n\t\t\t//single comment\n\t\t\t" +
			"return;\n\t\t}\n\t]]>\n\t</fx:Script>\n</Foo>", tag);
	}
	
	[Test]
	public function testMetadata():void
	{
		tag = factory.newTag("Foo");
		
		var mtag:IMetadataTag = tag.newMetadataTag();
		mtag.block.newMetaData("Bindable");
		var event:IMetaData = mtag.block.newMetaData("Event");
		event.addNamedStringParameter("name", "myEvent");
		event.description = "A custom event.";
		
		assertPrint("<Foo>\n\t<fx:Metadata>\n\t<![CDATA[\n\t\t[Bindable]\n\t\t/**\n" +
			"\t\t * A custom event.\n\t\t */\n\t\t[Event(name=\"myEvent\")]\n\t]]>" +
			"\n\t</fx:Metadata>\n</Foo>", tag);
	}
	
	[Test]
	public function testParse():void
	{
		//tag = factory.addTag("<Foo></Foo>");
	}
	
	[Test]
	public function test_binding():void
	{
		tag = factory.newTag("Foo");
		Assert.assertNull(tag.binding);
		Assert.assertEquals("Foo", tag.localName);
		assertPrint("<Foo>\n</Foo>", tag);
		tag.binding = "bar";
		Assert.assertEquals("bar", tag.binding);
		assertPrint("<bar:Foo>\n</bar:Foo>", tag);
		tag.binding = null;
		tag.localName = "Bar";
		Assert.assertNull(tag.binding);
		assertPrint("<Bar>\n</Bar>", tag);
		tag.binding = "baz";
		Assert.assertEquals("baz", tag.binding);
		assertPrint("<baz:Bar>\n</baz:Bar>", tag);
	}
	
	[Test]
	public function test_localName():void
	{
		tag = factory.newTag("Foo");
		Assert.assertEquals("Foo", tag.localName);
		tag.localName = "Bar";
		Assert.assertEquals("Bar", tag.localName);
		assertPrint("<Bar>\n</Bar>", tag);
		try
		{
			tag.localName = null;
			Assert.fail("tag localName connot be null");
		}
		catch (e:ASBlocksSyntaxError) {}
		try
		{
			tag.localName = "";
			Assert.fail("tag localName connot be null");
		}
		catch (e:ASBlocksSyntaxError) {}
	}
	
	/*
	<Foo>
		<!-- foo bar baz -->
		<Bar>
		</Bar>
	</Foo>
	
	
	<Foo>
	    <Bar>
	    </Bar>
	    <!-- foo bar baz-->
	</Foo>
	*/
	
	//[Test]
	public function test_addComment():void
	{
		tag = factory.newTag("Foo");
		tag.addComment("foo bar baz");
		var child:IBlockTag = tag.newTag("Bar");
		child.addComment("goo bar baz");
		assertPrint("\n\t<Bar>\n\t</Bar>\n", tag);
	}
	
	[Test]
	public function test_newTagMultiple():void
	{
		tag = factory.newTag("Foo");
		tag.newTag("Bar");
		tag.newTag("Baz");
		assertPrint("<Foo>\n\t<Bar>\n\t</Bar>\n\t<Baz>\n\t</Baz>\n</Foo>", tag);
	}
}
}