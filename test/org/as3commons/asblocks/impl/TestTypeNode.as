package org.as3commons.asblocks.impl
{

import org.as3commons.asblocks.ASBlocksSyntaxError;
import org.as3commons.asblocks.CodeMirror;
import org.as3commons.asblocks.api.IClassType;
import org.as3commons.asblocks.api.ICompilationUnit;
import org.as3commons.asblocks.api.IMethod;
import org.as3commons.asblocks.api.IType;
import org.as3commons.asblocks.api.Visibility;
import org.as3commons.asblocks.parser.api.IParserNode;
import org.as3commons.asblocks.parser.core.SourceCode;
import org.as3commons.asblocks.parser.impl.AS3FragmentParser;
import org.flexunit.asserts.assertEquals;
import org.flexunit.asserts.assertFalse;
import org.flexunit.asserts.assertNotNull;
import org.flexunit.asserts.assertNull;
import org.flexunit.asserts.assertTrue;
import org.flexunit.asserts.fail;

public class TestTypeNode extends BaseASFactoryTest
{
	private var unit:ICompilationUnit;
	
	private var type:IClassType;
	
	[Before]
	override public function setUp():void
	{
		super.setUp();
		
		unit = null;
		type = null;
	}
	
	[After]
	override public function tearDown():void
	{
		if (type)
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
		unit = factory.newClass("my.domain.Test");
		type = unit.typeNode as IClassType;
	}
	
	[Test]
	public function testParse():void
	{
	}
	
	[Test]
	public function test_name():void
	{
		unit = factory.newClass("my.domain.Test");
		type = unit.typeNode as IClassType;
		type.name = "NewTest";
		assertEquals("NewTest", type.name);
		try
		{
			type.name = null;
			fail("Cannot set IType.name to null");
		}
		catch (e:ASBlocksSyntaxError){}
		try
		{
			type.name = null;
			fail("Cannot set IType.name to an empty string");
		}
		catch (e:ASBlocksSyntaxError){}
		assertPrint("package my.domain {\n\tpublic class NewTest {\n\t}\n}", unit);
	}
	
	[Test]
	public function test_visibility():void
	{
		unit = factory.newClass("my.domain.Test");
		type = unit.typeNode as IClassType;
		assertTrue(type.visibility.equals(Visibility.PUBLIC));
		try
		{
			type.visibility = Visibility.PROTECTED;
			fail("IType visibility must be public");
		}
		catch (e:ASBlocksSyntaxError){}
		
		assertPrint("package my.domain {\n\tpublic class Test {\n\t}\n}", unit);
	}
	
	[Test]
	public function test_methods():void
	{
		unit = factory.newClass("my.domain.Test");
		type = unit.typeNode as IClassType;
		assertNotNull(type.methods);
		assertEquals(0, type.methods.length);
		var method:IMethod = type.newMethod("method", Visibility.PUBLIC, "void");
		assertEquals(1, type.methods.length);
		
		assertPrint("package my.domain {\n\tpublic class Test {\n\t\tpublic " +
			"function method():void {\n\t\t}\n\t}\n}", unit);
	}
	
	[Test]
	public function test_newMethod():void
	{
		unit = factory.newClass("my.domain.Test");
		type = unit.typeNode as IClassType;
		var method1:IMethod = type.newMethod("method1", Visibility.PUBLIC, "void");
		var method2:IMethod = type.newMethod("method2", Visibility.PRIVATE, "String");
		assertPrint("package my.domain {\n\tpublic class Test {\n\t\tpublic " +
			"function method1():void {\n\t\t}\n\t\tprivate function method2():" +
			"String {\n\t\t}\n\t}\n}", unit);
	}
	
	[Test]
	public function test_getMethod():void
	{
		unit = factory.newClass("my.domain.Test");
		type = unit.typeNode as IClassType;
		var method1:IMethod = type.newMethod("method1", Visibility.PUBLIC, "void");
		var method2:IMethod = type.newMethod("method2", Visibility.PRIVATE, "String");
		
		assertEquals(method1.node, type.getMethod("method1").node);
		assertEquals(method2.node, type.getMethod("method2").node);
		assertNull(type.getMethod("method3"));
	}
	
	[Test]
	public function test_removeMethod():void
	{
		unit = factory.newClass("my.domain.Test");
		type = unit.typeNode as IClassType;
		var method1:IMethod = type.newMethod("method1", Visibility.PUBLIC, "void");
		var method2:IMethod = type.newMethod("method2", Visibility.PRIVATE, "String");
		
		assertEquals(2, type.methods.length);
		assertTrue(type.removeMethod("method1"));
		assertEquals(1, type.methods.length);
		assertFalse(type.removeMethod("method3"));
		assertTrue(type.removeMethod("method2"));
		assertEquals(0, type.methods.length);
		assertPrint("package my.domain {\n\tpublic class Test {\n\t}\n}", unit);
	}
}
}