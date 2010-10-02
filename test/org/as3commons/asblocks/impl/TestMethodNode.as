package org.as3commons.asblocks.impl
{

import org.as3commons.asblocks.CodeMirror;
import org.as3commons.asblocks.api.IClassType;
import org.as3commons.asblocks.api.ICompilationUnit;
import org.as3commons.asblocks.api.IMethod;
import org.as3commons.asblocks.api.Visibility;
import org.flexunit.Assert;

public class TestMethodNode extends BaseASFactoryTest
{
	private var unit:ICompilationUnit;
	
	private var type:IClassType;
	
	private var method:IMethod;
	
	[Before]
	override public function setUp():void
	{
		super.setUp();
		
		unit = project.newClass("Foo");
		type = unit.typeNode as IClassType;
	}
	
	[After]
	override public function tearDown():void
	{
		CodeMirror.assertReflection(factory, unit);
	}
	
	[Test]
	public function test_name():void
	{
		method = type.newMethod("foo", Visibility.PUBLIC, "void");
		Assert.assertEquals("foo", method.name);
		method.name = "bar";
		Assert.assertEquals("bar", method.name);
		assertPrint("package {\n\tpublic class Foo {\n\t\tpublic function bar():void " +
			"{\n\t\t}\n\t}\n}", unit);
	}
	
	[Test]
	public function test_parameters():void
	{
		method = type.newMethod("test", Visibility.PUBLIC, "void");
		method.addParameter("arg0", "int");
		method.addParameter("arg1", "Vector.<String>");
		method.addParameter("arg2", "Vector.<Vector.<String>>", "null");
		Assert.assertEquals(3, method.parameters.length);
		Assert.assertEquals("arg0", method.parameters[0].name);
		Assert.assertEquals("arg1", method.parameters[1].name);
		Assert.assertEquals("arg2", method.parameters[2].name);
		Assert.assertTrue(method.parameters[0].hasType);
		Assert.assertTrue(method.parameters[1].hasType);
		Assert.assertTrue(method.parameters[2].hasType);
		Assert.assertEquals("int", method.parameters[0].type);
		Assert.assertEquals("Vector.<String>", method.parameters[1].type);
		Assert.assertEquals("Vector.<Vector.<String>>", method.parameters[2].type);
		Assert.assertFalse(method.parameters[0].hasDefaultValue);
		Assert.assertFalse(method.parameters[1].hasDefaultValue);
		Assert.assertTrue(method.parameters[2].hasDefaultValue);
		Assert.assertEquals("null", method.parameters[2].defaultValue);
		assertPrint("package {\n\tpublic class Foo {\n\t\tpublic function test" +
			"(arg0:int, arg1:Vector.<String>, arg2:Vector.<Vector.<String>> = null)" +
			":void {\n\t\t}\n\t}\n}", unit);
	}
	
	[Test]
	public function test_returnType():void
	{
		method = type.newMethod("test", Visibility.PUBLIC, "Vector.<String>");
		Assert.assertEquals("Vector.<String>", method.returnType);
		assertPrint("package {\n\tpublic class Foo {\n\t\tpublic function test():Vector.<String> " +
			"{\n\t\t}\n\t}\n}", unit);
		method.returnType = "void";
		Assert.assertEquals("void", method.returnType);
		assertPrint("package {\n\tpublic class Foo {\n\t\tpublic function test():void " +
			"{\n\t\t}\n\t}\n}", unit);
	}
	
	[Test]
	public function test_qualifiedReturnType():void
	{
		method = type.newMethod("test", Visibility.PUBLIC, "Vector.<String>");
		Assert.assertEquals("Vector.<String>", method.qualifiedReturnType);
		method.returnType = "void";
		Assert.assertEquals("void", method.qualifiedReturnType);
		unit.packageName = "my.domain";
		method.returnType = "MyClass";
		Assert.assertEquals("my.domain.MyClass", method.qualifiedReturnType);
	}
	
	[Test]
	public function test_addParameter():void
	{
	}
	
	[Test]
	public function test_addRestParameter():void
	{
	}
}
}