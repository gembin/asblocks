package org.as3commons.asblocks.impl
{

import org.flexunit.Assert;
import org.as3commons.asblocks.parser.api.IParserNode;
import org.as3commons.asblocks.parser.core.SourceCode;
import org.as3commons.asblocks.parser.impl.AS3FragmentParser;
import org.as3commons.asblocks.ASBlocksSyntaxError;
import org.as3commons.asblocks.CodeMirror;
import org.as3commons.asblocks.api.IClassType;
import org.as3commons.asblocks.api.ICompilationUnit;
import org.as3commons.asblocks.api.IMember;
import org.as3commons.asblocks.api.Visibility;

public class TestMemberNode extends BaseASFactoryTest
{
	private var unit:ICompilationUnit;
	
	private var type:IClassType;
	
	private var member:IMember;
	
	[Before]
	override public function setUp():void
	{
		super.setUp();
		
		unit = null;
		member = null;
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
		unit = factory.newClass("A");
		type = unit.typeNode as IClassType;
		member = type.newField("foo", Visibility.PUBLIC, "int");
		assertPrint("package {\n\tpublic class A {\n\t\tpublic var foo:int;\n\t}\n}", unit);
	}
	
	[Test]
	public function test_visibility():void
	{
		unit = factory.newClass("A");
		type = unit.typeNode as IClassType;
		member = type.newField("foo", Visibility.PUBLIC, "int");
		Assert.assertTrue(member.visibility.equals(Visibility.PUBLIC));
		member.visibility = Visibility.PROTECTED;
		Assert.assertTrue(member.visibility.equals(Visibility.PROTECTED));
		assertPrint("package {\n\tpublic class A {\n\t\tprotected var foo:int;\n\t}\n}", unit);
		member.visibility = Visibility.DEFAULT;
		Assert.assertTrue(member.visibility.equals(Visibility.DEFAULT));
		assertPrint("package {\n\tpublic class A {\n\t\tvar foo:int;\n\t}\n}", unit);
		// add back the mod-list
		member.visibility = Visibility.PUBLIC;
		Assert.assertTrue(member.visibility.equals(Visibility.PUBLIC));
		assertPrint("package {\n\tpublic class A {\n\t\tpublic var foo:int;\n\t}\n}", unit);
		// try to add public again
		member.visibility = Visibility.PUBLIC;
		Assert.assertTrue(member.visibility.equals(Visibility.PUBLIC));
		assertPrint("package {\n\tpublic class A {\n\t\tpublic var foo:int;\n\t}\n}", unit);
	}
	
	[Test]
	public function test_visibilityWithNamespaceAndStatic():void
	{
		unit = factory.newClass("A");
		type = unit.typeNode as IClassType;
		member = type.newField("foo", Visibility.PUBLIC, "int");
		Assert.assertTrue(member.visibility.equals(Visibility.PUBLIC));
		var visibility:Visibility = Visibility.create("flash_proxy");
		member.visibility = visibility;
		Assert.assertTrue(member.visibility.equals(visibility));
		assertPrint("package {\n\tpublic class A {\n\t\tflash_proxy var foo:int;\n\t}\n}", unit);
		member.isStatic = true;
		assertPrint("package {\n\tpublic class A {\n\t\tflash_proxy static var foo:int;\n\t}\n}", unit);
	}
	
	[Test]
	public function test_name():void
	{
		unit = factory.newClass("A");
		type = unit.typeNode as IClassType;
		member = type.newField("foo", Visibility.PUBLIC, "int");
		Assert.assertEquals("foo", member.name);
		member.name = "bar";
		Assert.assertEquals("bar", member.name);
		assertPrint("package {\n\tpublic class A {\n\t\tpublic var bar:int;\n\t}\n}", unit);
		// try setting the name twice
		member.name = "bar";
		Assert.assertEquals("bar", member.name);
		assertPrint("package {\n\tpublic class A {\n\t\tpublic var bar:int;\n\t}\n}", unit);
		// set illegal
		try 
		{
			member.name = "foo.bar";
			Assert.fail("member names cannot contain a period");
		}
		catch (e:ASBlocksSyntaxError)
		{
			Assert.assertEquals("bar", member.name);
		}
	}
	
	[Test]
	public function test_type():void
	{
		unit = factory.newClass("A");
		type = unit.typeNode as IClassType;
		member = type.newField("foo", Visibility.PUBLIC, "int");
		Assert.assertEquals("int", member.type);
		member.type = "String";
		Assert.assertEquals("String", member.type);
		assertPrint("package {\n\tpublic class A {\n\t\tpublic var foo:String;\n\t}\n}", unit);
		// try setting the name twice
		member.type = "String";
		Assert.assertEquals("String", member.type);
		assertPrint("package {\n\tpublic class A {\n\t\tpublic var foo:String;\n\t}\n}", unit);
	}
	
	[Test]
	public function test_isStatic():void
	{
		unit = factory.newClass("A");
		type = unit.typeNode as IClassType;
		member = type.newField("foo", Visibility.PUBLIC, "int");
		Assert.assertFalse(member.isStatic);
		member.isStatic = true;
		Assert.assertTrue(member.isStatic);
		assertPrint("package {\n\tpublic class A {\n\t\tpublic static var foo:int;\n\t}\n}", unit);
		member.isStatic = false;
		Assert.assertFalse(member.isStatic);
		assertPrint("package {\n\tpublic class A {\n\t\tpublic var foo:int;\n\t}\n}", unit);
	}
	
	[Test]
	public function test_isStaticChangeVisibility():void
	{
		unit = factory.newClass("A");
		type = unit.typeNode as IClassType;
		member = type.newField("foo", Visibility.PUBLIC, "int");
		Assert.assertFalse(member.isStatic);
		member.isStatic = true;
		member.visibility = Visibility.DEFAULT;
		assertPrint("package {\n\tpublic class A {\n\t\tstatic var foo:int;\n\t}\n}", unit);
		member.visibility = Visibility.PRIVATE;
		// vis goes in front
		assertPrint("package {\n\tpublic class A {\n\t\tprivate static var foo:int;\n\t}\n}", unit);
		member.isStatic = false;
		assertPrint("package {\n\tpublic class A {\n\t\tprivate var foo:int;\n\t}\n}", unit);
	}
}
}