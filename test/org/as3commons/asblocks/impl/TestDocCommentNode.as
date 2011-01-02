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
import org.as3commons.asblocks.utils.DocCommentUtil;
import org.flexunit.Assert;

// - set description
// - unset description
// - add doctag w/o body
// - add doctag w/body
// - remove doctag w/o body
// - remove doctag w/body

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
	public function testBasicDocComment():void
	{
		var ast:IParserNode = ASTTypeBuilder.newClassAST("foo.bar.Baz");
		
		var comment:DocCommentNode = DocCommentUtil.createDocComment(ast) as DocCommentNode;
		
		Assert.assertNotNull(comment.node);
		Assert.assertNull(comment.asdocNode);
		
		return;
		
		comment.description = "A doc comment.";
		Assert.assertEquals("A doc comment.", comment.description);
		
		comment.description = "A doc comment\nwith newline.";
		Assert.assertEquals("A doc comment\nwith newline.", comment.description);
		
		comment.description = "A short foo.\n\n<p>With a para.</p>\n\n<p>And a bar para.</p>";
		Assert.assertEquals("A short foo.\n\n<p>With a para.</p>\n\n<p>And a bar para.</p>", comment.description);
		
		comment.description = "A doc comment.";
		Assert.assertEquals("A doc comment.", comment.description);
		
		comment.description = null;
		Assert.assertNull(comment.description);
	}
	
	//[Test]
	public function testBasicDocTag():void
	{
		var ast:IParserNode = ASTTypeBuilder.newClassAST("Foo");
		var comment:DocCommentNode = DocCommentUtil.createDocComment(ast) as DocCommentNode;
		
		var foo:IDocTag = comment.newDocTag("foo");
		assertPrint("/**\n * @foo\n */" +
			"\npublic class Foo {\n}", comment);
		
		
		
		
		//var bar:IDocTag = comment.newDocTag("bar", "baz goo");
		//assertPrint("/**\n * A doc comment.\n * \n * @foo\n */" +
		//	"\npublic class foo.bar.Baz {\n}", comment);
	}
	
	//[Test]
	public function testBasicDocCommentAndDocTag():void
	{
		var ast:IParserNode = ASTTypeBuilder.newClassAST("foo.bar.Baz");
		
		var comment:DocCommentNode = DocCommentUtil.createDocComment(ast) as DocCommentNode;
		
		Assert.assertNotNull(comment.node);
		Assert.assertNull(comment.asdocNode);
		
		comment.description = "A doc comment.";
		Assert.assertEquals("A doc comment.", comment.description);
		
		var foo:IDocTag = comment.newDocTag("foo");
		// make sure body stays the same
		Assert.assertEquals("A doc comment.", comment.description);
		assertPrint("/**\n * A doc comment.\n * \n * @foo\n */" +
			"\npublic class foo.bar.Baz {\n}", comment);
		
		comment.removeDocTag(foo);
		// make sure body stays the same
		Assert.assertEquals("A doc comment.", comment.description);
		assertPrint("/**\n * A doc comment.\n */\npublic class foo.bar.Baz {\n}", comment);
	}
	
	//[Test]
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
	
	//[Test]
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
		
		//doc.description;
	}
	
	//[Test]
	public function test_description():void
	{
		
	}	
	
}
}