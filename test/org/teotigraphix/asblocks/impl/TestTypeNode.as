package org.teotigraphix.asblocks.impl
{

import org.flexunit.asserts.assertEquals;
import org.flexunit.asserts.assertFalse;
import org.flexunit.asserts.assertNotNull;
import org.flexunit.asserts.assertNull;
import org.flexunit.asserts.assertTrue;
import org.flexunit.asserts.fail;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.core.SourceCode;
import org.teotigraphix.as3parser.impl.AS3FragmentParser;
import org.teotigraphix.asblocks.ASBlocksSyntaxError;
import org.teotigraphix.asblocks.CodeMirror;
import org.teotigraphix.asblocks.api.ICompilationUnit;
import org.teotigraphix.asblocks.api.IMethod;
import org.teotigraphix.asblocks.api.IType;
import org.teotigraphix.asblocks.api.Visibility;

public class TestTypeNode extends BaseASFactoryTest
{
	private var unit:ICompilationUnit;
	
	private var type:IType;
	
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
		}
	}
	
	[Test]
	public function testBasic():void
	{
		unit = factory.newClass("my.domain.Test");
		type = unit.typeNode;
	}
	
	[Test]
	public function testParse():void
	{
	}
	
	[Test]
	public function test_name():void
	{
		unit = factory.newClass("my.domain.Test");
		type = unit.typeNode;
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
		type = unit.typeNode;
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
		type = unit.typeNode;
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
		type = unit.typeNode;
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
		type = unit.typeNode;
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
		type = unit.typeNode;
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