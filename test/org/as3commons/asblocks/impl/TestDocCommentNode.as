package org.as3commons.asblocks.impl
{

import org.as3commons.asblocks.CodeMirror;
import org.as3commons.asblocks.api.IClassType;
import org.as3commons.asblocks.api.ICompilationUnit;
import org.as3commons.asblocks.api.IDocComment;
import org.as3commons.asblocks.api.IDocTag;
import org.as3commons.asblocks.parser.api.IParserNode;
import org.as3commons.asblocks.parser.core.SourceCode;
import org.as3commons.asblocks.parser.impl.AS3FragmentParser;

public class TestDocCommentNode extends BaseASFactoryTest
{
	private var unit:ICompilationUnit;
	
	[Before]
	override public function setUp():void
	{
		super.setUp();
		
		unit = null;
	}
	
	[After]
	override public function tearDown():void
	{
		if (unit)
		{
			var sourceCode:SourceCode = new SourceCode();
			var ast:IParserNode = unit.node;
			new ASTPrinter(sourceCode).print(ast);
			var parsed:IParserNode = AS3FragmentParser.parseCompilationUnit(sourceCode.code);
			CodeMirror.assertASTMatch(ast, parsed);
			CodeMirror.assertReflection(factory, unit);
		}
	}
	
	[Test]
	public function testBasic():void
	{
		unit = project.newClass("Foo");
		var type:IClassType = unit.typeNode as IClassType;
		
		type.description = "A document comment description.";
		
		assertPrint("package {\n\t/**\n\t * A document comment description.\n\t " +
			"*/\n\tpublic class Foo {\n\t}\n}", unit);
		
		type.description = "A document comment description\nwith two lines.";
		
		assertPrint("package {\n\t/**\n\t * A document comment description\n\t * " +
			"with two lines.\n\t */\n\tpublic class Foo {\n\t}\n}", unit);
		
		type.description = "A document comment description\nwith two lines.\n<p>foo oof oofoo foo\nbaz baz baz</p>";
		
		assertPrint("package {\n\t/**\n\t * A document comment description\n\t * " +
			"with two lines.\n\t * <p>foo oof oofoo foo\n\t * baz baz baz</p>\n\t " +
			"*/\n\tpublic class Foo {\n\t}\n}", unit);
	}
	
	[Test]
	public function testParse():void
	{
		unit = project.newClass("Foo");
		var type:IClassType = unit.typeNode as IClassType;
		
		var doc:IDocComment = type.documentation;
		
		doc.description = "A document comment description.";
		
		var tag:IDocTag = doc.newDocTag("foo", "bar");
		
		assertPrint("package {\n\t/**\n\t * A document comment description.\n\t " +
			"* \n\t * @foo bar\n\t */\n\tpublic class Foo {\n\t}\n}", unit);
		
		doc.removeDocTag(tag);
		
		assertPrint("package {\n\t/**\n\t * A document comment description.\n\t " +
			"*/\n\tpublic class Foo {\n\t}\n}", unit);
		
		doc.newDocTag("baz", "baz\ngop");
		doc.newDocTag("baz", "goo");
		
		assertPrint("package {\n\t/**\n\t * A document comment description.\n\t * \n\t * " +
			"@baz baz\n\t * gop\n\t * @baz goo\n\t */\n\tpublic class Foo {\n\t}\n}", unit);
		
		doc.description = "A document comment description\nspan two lines.";
		
		doc.description;
	}
	
	[Test]
	public function test_description():void
	{
		
	}	
	
}
}