package org.teotigraphix.asblocks.impl
{

import org.flexunit.asserts.assertEquals;
import org.flexunit.asserts.assertFalse;
import org.flexunit.asserts.assertNotNull;
import org.flexunit.asserts.assertNull;
import org.flexunit.asserts.assertTrue;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.core.SourceCode;
import org.teotigraphix.as3parser.impl.AS3FragmentParser;
import org.teotigraphix.asblocks.CodeMirror;
import org.teotigraphix.asblocks.api.IClassType;
import org.teotigraphix.asblocks.api.ICompilationUnit;
import org.teotigraphix.asblocks.api.IField;
import org.teotigraphix.asblocks.api.IMethod;
import org.teotigraphix.asblocks.api.Visibility;

public class TestClassTypeNode extends BaseASFactoryTest
{
	private var unit:ICompilationUnit;
	
	[Before]
	override public function setUp():void
	{
		super.setUp();
		
		unit = project.newClass("A");
		assertNotNull(unit);
		assertNotNull(unit.typeNode);
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
		}
	}
	
	[Test]
	public function test_newField():void
	{
		var typeNode:IClassType = unit.typeNode as IClassType;
		// TODO make sure dups cannot be created
		var field:IField = typeNode.newField("fieldOne", Visibility.PUBLIC, "String");
		assertNotNull(field);
		assertEquals(Visibility.PUBLIC, field.visibility);
		assertEquals("fieldOne", field.name);
		assertEquals("String", field.type);
		assertPrint("package {\n\tpublic class A {\n\t\tpublic var fieldOne:String;\n\t}\n}", unit);
		
		assertTrue(typeNode.removeField("fieldOne"));
		assertPrint("package {\n\tpublic class A {\n\t}\n}", unit);
		assertFalse(typeNode.removeField("fieldOne"));
	}
	
	[Test]
	public function test_getField():void
	{
		var typeNode:IClassType = unit.typeNode as IClassType;
		var field:IField = typeNode.newField("fieldOne", Visibility.PUBLIC, "String");
		assertEquals(field.name, typeNode.getField("fieldOne").name);
		assertNull(typeNode.getField("fieldTwo"));
		typeNode.removeField("fieldOne");
		assertNull(typeNode.getField("fieldOne"));
	}
	
	[Test]
	public function test_removeField():void
	{
		var typeNode:IClassType = unit.typeNode as IClassType;
		var field1:IField = typeNode.newField("fieldOne", Visibility.PUBLIC, "String");
		var field2:IField = typeNode.newField("fieldTwo", Visibility.PUBLIC, "String");
		var field3:IField = typeNode.newField("fieldThree", Visibility.PUBLIC, "String");
		assertEquals(3, typeNode.fields.length);
		assertTrue(typeNode.removeField("fieldOne"));
		assertEquals(2, typeNode.fields.length);
		assertTrue(typeNode.removeField("fieldTwo"));
		assertEquals(1, typeNode.fields.length);
		assertTrue(typeNode.removeField("fieldThree"));
		assertEquals(0, typeNode.fields.length);
		assertFalse(typeNode.removeField("fieldFour"));
	}
	
	[Test]
	public function test_newMethod():void
	{
		var typeNode:IClassType = unit.typeNode as IClassType;
		// TODO make sure dups cannot be created
		var method:IMethod = typeNode.newMethod("methodOne", Visibility.PUBLIC, "String");
		assertNotNull(method);
		assertEquals(Visibility.PUBLIC, method.visibility);
		assertEquals("methodOne", method.name);
		assertEquals("String", method.type);
		assertPrint("package {\n\tpublic class A {\n\t\tpublic function methodOne()" +
			":String {\n\t\t}\n\t}\n}", unit);
		
		assertTrue(typeNode.removeMethod("methodOne"));
		assertPrint("package {\n\tpublic class A {\n\t}\n}", unit);
		assertFalse(typeNode.removeMethod("methodOne"));
	}
	
	[Test]
	public function test_getMethod():void
	{
		var typeNode:IClassType = unit.typeNode as IClassType;
		var method:IMethod = typeNode.newMethod("methodOne", Visibility.PUBLIC, "String");
		assertEquals(method.name, typeNode.getMethod("methodOne").name);
		assertNull(typeNode.getMethod("methodTwo"));
		typeNode.removeMethod("methodOne");
		assertNull(typeNode.getMethod("methodOne"));
	}
	
	[Test]
	public function test_removeMethod():void
	{
		var typeNode:IClassType = unit.typeNode as IClassType;
		var method1:IMethod = typeNode.newMethod("methodOne", Visibility.PUBLIC, "String");
		var method2:IMethod = typeNode.newMethod("methodTwo", Visibility.PUBLIC, "String");
		var method3:IMethod = typeNode.newMethod("methodThree", Visibility.PUBLIC, "String");
		assertEquals(3, typeNode.methods.length);
		assertTrue(typeNode.removeMethod("methodOne"));
		assertEquals(2, typeNode.methods.length);
		assertTrue(typeNode.removeMethod("methodTwo"));
		assertEquals(1, typeNode.methods.length);
		assertTrue(typeNode.removeMethod("methodThree"));
		assertEquals(0, typeNode.methods.length);
		assertFalse(typeNode.removeMethod("methodFour"));
	}
	
	[Test]
	public function test_isDynamic():void
	{
		var typeNode:IClassType = unit.typeNode as IClassType;
		assertFalse(typeNode.isDynamic);
		typeNode.isDynamic = true;
		assertTrue(typeNode.isDynamic);
		typeNode.isDynamic = false;
		assertFalse(typeNode.isDynamic);
	}
	
	[Test]
	public function test_isFinal():void
	{
		var typeNode:IClassType = unit.typeNode as IClassType;
		assertFalse(typeNode.isFinal);
		typeNode.isFinal = true;
		assertTrue(typeNode.isFinal);
		typeNode.isFinal = false;
		assertFalse(typeNode.isFinal);
	}
	
	[Test]
	public function test_visibility():void
	{
		var typeNode:IClassType = unit.typeNode as IClassType;
		assertEquals(Visibility.PUBLIC, typeNode.visibility);
		assertPrint("package {\n\tpublic class A {\n\t}\n}", unit);
		// TOD this shouldn' be possible, just testing right now
		//typeNode.visibility = Visibility.INTERNAL;
		//assertEquals(Visibility.INTERNAL, typeNode.visibility);
		//assertPrint("package {\n\internal class A {\n\t}\n}", unit);
	}
	
	[Test]
	public function test_name():void
	{
		var typeNode:IClassType = unit.typeNode as IClassType;
		assertEquals("A", typeNode.name);
		assertPrint("package {\n\tpublic class A {\n\t}\n}", unit);
		typeNode.name = "TestA";
		assertEquals("TestA", typeNode.name);
		assertPrint("package {\n\tpublic class TestA {\n\t}\n}", unit);
		// test that name cannot be set to null or ""
	}
	
	[Test]
	public function test_superClass():void
	{
		var typeNode:IClassType = unit.typeNode as IClassType;
		assertNull(typeNode.superClass);
		typeNode.superClass = "ClassB";
		assertEquals("ClassB", typeNode.superClass);
		assertPrint("package {\n\tpublic class A extends ClassB {\n\t}\n}", unit);
		typeNode.superClass = "ClassD";
		assertEquals("ClassD", typeNode.superClass);
		assertPrint("package {\n\tpublic class A extends ClassD {\n\t}\n}", unit);
		typeNode.superClass = null;
		assertNull(typeNode.superClass);
		assertPrint("package {\n\tpublic class A {\n\t}\n}", unit);
	}
	
	[Test]
	public function test_addImplementedInterface():void
	{
		// TODO block adding the same type
		assertPrint("package {\n\tpublic class A {\n\t}\n}", unit);
		var typeNode:IClassType = unit.typeNode as IClassType;
		typeNode.addImplementedInterface("IInterfaceA");
		assertPrint("package {\n\tpublic class A implements IInterfaceA {\n\t}\n}", unit);
		typeNode.addImplementedInterface("IInterfaceB");
		assertPrint("package {\n\tpublic class A implements IInterfaceA, IInterfaceB {\n\t}\n}", unit);
		typeNode.removeImplementedInterface("IInterfaceA");
		assertPrint("package {\n\tpublic class A implements IInterfaceB {\n\t}\n}", unit);
		typeNode.removeImplementedInterface("IInterfaceB");
		assertPrint("package {\n\tpublic class A {\n\t}\n}", unit);
	}
	
	[Test]
	public function test_removeImplementedInterface():void
	{
		assertPrint("package {\n\tpublic class A {\n\t}\n}", unit);
		var typeNode:IClassType = unit.typeNode as IClassType;
		typeNode.addImplementedInterface("IInterfaceA");
		assertPrint("package {\n\tpublic class A implements IInterfaceA {\n\t}\n}", unit);
		typeNode.addImplementedInterface("IInterfaceB");
		assertPrint("package {\n\tpublic class A implements IInterfaceA, IInterfaceB {\n\t}\n}", unit);
		assertTrue(typeNode.removeImplementedInterface("IInterfaceA"));
		assertPrint("package {\n\tpublic class A implements IInterfaceB {\n\t}\n}", unit);
		assertTrue(typeNode.removeImplementedInterface("IInterfaceB"));
		assertPrint("package {\n\tpublic class A {\n\t}\n}", unit);
		assertFalse(typeNode.removeImplementedInterface("IInterfaceB"));
	}
	
	[Test]
	public function test_implementedInterface():void
	{
		var typeNode:IClassType = unit.typeNode as IClassType;
		typeNode.addImplementedInterface("IInterfaceA");
		typeNode.addImplementedInterface("IInterfaceB");
		typeNode.addImplementedInterface("IInterfaceC");
		
		var ifaces:Vector.<String> = typeNode.implementedInterfaces;
		assertNotNull(ifaces);
		assertEquals(3, ifaces.length);
		assertEquals("IInterfaceA", ifaces[0]);
		assertEquals("IInterfaceB", ifaces[1]);
		assertEquals("IInterfaceC", ifaces[2]);
		
		typeNode.removeImplementedInterface("IInterfaceA");
		
		ifaces = typeNode.implementedInterfaces;
		assertNotNull(ifaces);
		assertEquals(2, ifaces.length);
		assertEquals("IInterfaceB", ifaces[0]);
		assertEquals("IInterfaceC", ifaces[1]);
	}
}
}