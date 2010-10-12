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
import org.as3commons.asblocks.api.IFunction;
import org.as3commons.asblocks.api.IMethod;
import org.as3commons.asblocks.api.IParameter;
import org.as3commons.asblocks.api.Visibility;

public class TestFunctionCommon extends BaseASFactoryTest
{
	private var unit:ICompilationUnit;
	
	private var type:IClassType;
	
	private var func:IMethod;
	
	[Before]
	override public function setUp():void
	{
		super.setUp();
		
		unit = null;
		func = null;
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
		func = type.newMethod("foo", Visibility.PUBLIC, "void");
		
		assertPrint("package {\n\tpublic class A {\n\t\tpublic function foo():void " +
			"{\n\t\t}\n\t}\n}", func);
	}
	
	[Test]
	public function test_parameters():void
	{
		unit = factory.newClass("A");
		type = unit.typeNode as IClassType;
		func = type.newMethod("foo", Visibility.PUBLIC, "void");
		func.addParameter("arg0", "int");
		func.addParameter("arg1", "int", "1");
		func.addRestParameter("rest");
		Assert.assertEquals(3, func.parameters.length);
		assertPrint("package {\n\tpublic class A {\n\t\tpublic function foo" +
			"(arg0:int, arg1:int = 1, ...rest):void {\n\t\t}\n\t}\n}", func);
		
		// test names
		Assert.assertEquals("arg0", func.parameters[0].name);
		Assert.assertEquals("arg1", func.parameters[1].name);
		Assert.assertEquals("rest", func.parameters[2].name);
		
		// test types
		Assert.assertEquals("int", func.parameters[0].type);
		Assert.assertEquals("int", func.parameters[1].type);
		Assert.assertNull(func.parameters[2].type);
		
		// test defaults
		Assert.assertNull(func.parameters[0].defaultValue);
		Assert.assertEquals("1", func.parameters[1].defaultValue);
		Assert.assertNull(func.parameters[2].defaultValue);
		
		// test rest
		Assert.assertFalse(func.parameters[0].isRest);
		Assert.assertFalse(func.parameters[1].isRest);
		Assert.assertTrue(func.parameters[2].isRest);
	}
	
	[Test]
	public function test_hasParameters():void
	{
		unit = factory.newClass("A");
		type = unit.typeNode as IClassType;
		func = type.newMethod("foo", Visibility.PUBLIC, "void");
		Assert.assertFalse(func.hasParameters);
		func.addParameter("arg0", "int");
		Assert.assertTrue(func.hasParameters);
		func.removeParameter("arg0");
		Assert.assertFalse(func.hasParameters);
	}
	
	[Test]
	public function test_returnType():void
	{
		unit = factory.newClass("A");
		type = unit.typeNode as IClassType;
		func = type.newMethod("foo", Visibility.PUBLIC, "void");
		
		Assert.assertEquals("void", func.returnType);
		func.returnType = "String";
		Assert.assertEquals("String", func.returnType);
		assertPrint("package {\n\tpublic class A {\n\t\tpublic function foo():String " +
			"{\n\t\t}\n\t}\n}", func);
		
		// null,remove colon
		func.returnType = null;
		Assert.assertNull(func.returnType);
		assertPrint("package {\n\tpublic class A {\n\t\tpublic function foo() " +
			"{\n\t\t}\n\t}\n}", func);
	}
	
	[Test]
	public function test_addParameter():void
	{
		unit = factory.newClass("A");
		type = unit.typeNode as IClassType;
		func = type.newMethod("foo", Visibility.PUBLIC, "void");
		func.addParameter("arg0", "int");
		// try to add a duplicate name, throw
		try
		{
			func.addParameter("arg0", "int");
			Assert.fail("a parameter of the same name already exists");
		}
		catch (e:ASBlocksSyntaxError) {}
	}
	
	[Test]
	public function test_removeParameter():void
	{
		unit = factory.newClass("A");
		type = unit.typeNode as IClassType;
		func = type.newMethod("foo", Visibility.PUBLIC, "void");
		func.addParameter("arg0", "int");
		Assert.assertNotNull(func.removeParameter("arg0"));
		Assert.assertNull(func.removeParameter("arg0"));
	}
	
	[Test]
	public function test_addRestParameter():void
	{
		unit = factory.newClass("A");
		type = unit.typeNode as IClassType;
		func = type.newMethod("foo", Visibility.PUBLIC, "void");
		func.addRestParameter("rest");
		assertPrint("package {\n\tpublic class A {\n\t\tpublic function foo(...rest):void " +
			"{\n\t\t}\n\t}\n}", func);
		// try to add rest again, throw
		try
		{
			func.addRestParameter("bar");
			Assert.fail("only one rest parameter allowed");
		}
		catch (e:ASBlocksSyntaxError) {}
		
	}
	
	//[Test]
	public function test_removeRestParameter():void
	{
		// FIXME (mschmalle) rest removal and additon
		unit = factory.newClass("A");
		type = unit.typeNode as IClassType;
		func = type.newMethod("foo", Visibility.PUBLIC, "void");
		func.addRestParameter("rest");
		func.addParameter("arg0", "int");
		assertPrint("package {\n\tpublic class A {\n\t\tpublic function foo(arg0:int, ...rest):void " +
			"{\n\t\t}\n\t}\n}", func);
		func.removeRestParameter();
	}
	
	[Test]
	public function test_hasParameter():void
	{
		unit = factory.newClass("A");
		type = unit.typeNode as IClassType;
		func = type.newMethod("foo", Visibility.PUBLIC, "void");
		func.addParameter("arg0", "int");
		Assert.assertTrue(func.hasParameter("arg0"));
		Assert.assertFalse(func.hasParameter("arg1"));
	}
	
	[Test]
	public function test_hasRestParameter():void
	{
		unit = factory.newClass("A");
		type = unit.typeNode as IClassType;
		func = type.newMethod("foo", Visibility.PUBLIC, "void");
		func.addRestParameter("rest");
		Assert.assertTrue(func.hasRestParameter());
	}
	
	//----------------------------------
	// IParameter
	//----------------------------------
	
	[Test]
	public function test_parameter_name():void
	{
		unit = factory.newClass("A");
		type = unit.typeNode as IClassType;
		func = type.newMethod("foo", Visibility.PUBLIC, "void");
		func.addParameter("arg0", "int");
		Assert.assertEquals("arg0", func.parameters[0].name);
		func.parameters[0].name = "foo1";
		Assert.assertEquals("foo1", func.parameters[0].name);
	}
	
	[Test]
	public function test_parameter_type():void
	{
		unit = factory.newClass("A");
		type = unit.typeNode as IClassType;
		func = type.newMethod("foo", Visibility.PUBLIC, "void");
		func.addParameter("arg0", "int");
		Assert.assertEquals("int", func.parameters[0].type);
		func.parameters[0].type = "String";
		Assert.assertEquals("String", func.parameters[0].type);
	}
	
	[Test]
	public function test_parameter_defaultValue():void
	{
		unit = factory.newClass("A");
		type = unit.typeNode as IClassType;
		func = type.newMethod("foo", Visibility.PUBLIC, "void");
		func.addParameter("arg0", "int");
		Assert.assertEquals("int", func.parameters[0].type);
		func.parameters[0].type = "String";
		Assert.assertEquals("String", func.parameters[0].type);
	}
	
	[Test]
	public function test_parameter_hasType():void
	{
		unit = factory.newClass("A");
		type = unit.typeNode as IClassType;
		func = type.newMethod("foo", Visibility.PUBLIC, "void");
		func.addParameter("arg0", "int");
		Assert.assertTrue(func.parameters[0].hasType);
	}
	
	//[Test] FIXME (mschmalle) ut TestFunctionCommon#test_parameter_hasDefaultValue()
	public function test_parameter_hasDefaultValue():void
	{
		unit = factory.newClass("A");
		type = unit.typeNode as IClassType;
		func = type.newMethod("foo", Visibility.PUBLIC, "void");
		//var param:IParameter = func.addParameter("arg0", "int");
		//Assert.assertFalse(param.hasDefaultValue);
		//param.defaultValue = "42";
		//Assert.assertTrue(param.hasDefaultValue);
	}
}
}